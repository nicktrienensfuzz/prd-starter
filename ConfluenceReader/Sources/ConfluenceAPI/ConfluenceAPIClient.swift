import AEXML
import Foundation
import JSON
import Networker
import SwiftSoup

// MARK: - Substring Extension
public extension Substring {
    var asString: String {
        String(self)
    }
}

public class ConfluenceAPIClient {
    let configuration: ConfigurationInterface
    let requester: Requester

    func jsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ'"
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }
    
    /// Initializes the Confluence API client.
    ///
    /// - Parameters:
    ///   - requester: Requester instance to make API calls. Default value is RequestMaker().
    ///   - configuration: ConfigurationInterface instance for API client configuration.
    public init(requester: Requester = RequestMaker(), configuration: ConfigurationInterface) {
        self.configuration = configuration
        self.requester = requester
    }

    /// Fetches the children of a content with the given identifier.
    ///
    /// - Parameter identifier: The identifier of the content.
    /// - Returns: A Confluence.ContentListResponse containing the children contents.
    /// - Throws: An error if the operation fails.
    public func getContentsChildren(identifier: String) async throws -> Confluence.ContentListResponse {
        let target = Endpoint(
            method: .GET,
            path: configuration.baseURL + "content/search",
            parameters: [.parameter([
                "limit": "100",
                "expand": "body.view,body.export,export_view,history,version,children.comment,children.attachment,children.page",
                "cql": "parent=\(identifier)"
            ], .queryString)],
            headers: ["Authorization": "Basic \(configuration.token)"]
        )

        let data = try await requester.makeRequest(target)
        do {
            return try jsonDecoder().decode(Confluence.ContentListResponse.self, from: data)
        } catch {
            print(error)
            try? print(String(data: data, encoding: .utf8).unwrapped())
            throw error
        }
    }

    /// Fetches a content with the given identifier.
    ///
    /// - Parameter identifier: The identifier of the content.
    /// - Returns: A Confluence.Content instance.
    /// - Throws: An error if the operation fails.
    public func getContent(identifier: String) async throws -> Confluence.Content {
        let target = Endpoint(
            method: .GET,
            path: configuration.baseURL + "content/\(identifier)",
            parameters: [.parameter(["expand": "body.view,body.export, export_view,history,version,children.comment,children.attachment,children.page"], .queryString)],
            headers: ["Authorization": "Basic \(configuration.token)"]
        )
        
        let data = try await requester.makeRequest(target)
        return try jsonDecoder().decode(Confluence.Content.self, from: data)
    }

    /// Fetches the PDF version of a particular page with the given identifier.
    ///
    /// - Parameter identifier: The identifier of the page.
    /// - Returns: A String containing the task identifier.
    /// - Throws: An error if the operation fails.
    public func getPageAsPDF(identifier: String) async throws -> String {
        let target = Endpoint(
            method: .GET,
            path: "https://monstarlab.atlassian.net/wiki/spaces/flyingpdf/pdfpageexport.action",
            parameters: [.parameter(["pageId": identifier], .queryString)],
            headers: ["Authorization": "Basic \(configuration.token)"]
        )

        let data = try await requester.makeRequest(target)

        let t = String(data: data, encoding: .utf8)
        if let t, let r = t.range(of: "ajs-taskId") {
            print(r.lowerBound, r.upperBound)
            // <meta name="ajs-taskId" content="7800389853">
            let start = t.index(r.upperBound, offsetBy: 11)
            let end = t.index(r.upperBound, offsetBy: 20)
            print(t[start ... end])
            return t[start ... end].asString
        }
        throw NetworkClientError("failed to find PDF Task Identifier")
    }

    /// Polls the PDF task to check if the PDF conversion is complete.
    ///
    /// - Parameter task: The task identifier to poll.
    /// - Returns: A String containing the download link for the PDF.
    /// - Throws: An error if the operation fails.
    public func pollPDF(task: String) async throws -> String {
        let target = Endpoint(
            method: .GET,
            path: "https://monstarlab.atlassian.net/wiki/runningtaskxml.action",
            parameters: [.parameter(["taskId": task], .queryString)],
            headers: ["Authorization": "Basic \(configuration.token)"]
        )

        let data = try await requester.makeRequest(target)

        guard let xmlDoc = try? AEXMLDocument(xml: data) else {
            throw NetworkClientError("Failed to parse xml")
        }

        guard xmlDoc.root["isComplete"].bool == .some(true) else {
            throw NetworkClientError("Not Complete")
        }

        let t = xmlDoc.root["currentStatus"].string
        guard !t.isEmpty else {
            throw NetworkClientError("currentStatus not found")
        }
        print(t)

        do {
            let doc: Document = try SwiftSoup.parse(t)
            if let test = try doc.select("a").first() {
                let link = try test.attr("href")
                return link
            }

        } catch {
            print(error)
            throw NetworkClientError(error.localizedDescription)
        }
        throw NetworkClientError("failed")
    }

    public func downloadPDF(file: String) async throws -> Data {
        let target = Endpoint(
            method: .GET,
            path: "https://monstarlab.atlassian.net\(file)",
            headers: ["Authorization": "Basic \(configuration.token)"]
        )

        let data = try await requester.makeRequest(target)
        return data
    }
    
    /// Updates a content with the given identifier.
    ///
    /// - Parameters:
    ///   - identifier: The identifier of the content.
    ///   - content: The Confluence.Content to update.
    ///   - title: Optional new title for the content.
    ///   - body: Optional new body for the content.
    /// - Returns: A JSON instance containing the updated content data.
    /// - Throws: An error if the operation fails.
    public func updateContent(identifier: String, content: Confluence.Content, title: String? = nil, body: String? = nil) async throws -> JSON {
        let object = Confluence.ContentUpdate(
            content: content,
            title: title,
            body: body
        )

        let target = Endpoint(
            method: .PUT,
            path: configuration.baseURL + "content/\(identifier)",
            parameters: [.encodable(.init(object), .body)],
            headers: [
                "Authorization": "Basic \(configuration.token)",
                "Content-Type": "application/json"
            ]
        )

        let data = try await requester.makeRequest(target)
        do {
            return try JSON(data: data)
        } catch {
            print(error)
            try? print(String(data: data, encoding: .utf8).unwrapped())
            throw error
        }
    }

    /// Creates a new content under the given parent page.
    ///
    /// - Parameters:
    ///   - spaceId: The space ID where the content will be created.
    ///   - parentPage: The parent page ID to create the content under.
    ///   - title: The title of the new content.
    ///   - body: The body of the new content.
    /// - Returns: A JSON instance containing the created content data.
    /// - Throws: An error if the operation fails.
    @discardableResult
    public func createContent(spaceId: String, parentPage: String, title: String, body: String) async throws -> JSON {
        let object = Confluence.ContentCreate(
            spaceId: spaceId,
            title: title,
            ancestors: [.init(id: parentPage)],
            body: body
        )

        let target = Endpoint(
            method: .POST,
            path: configuration.baseURL + "content/",
            parameters: [.encodable(.init(object), .body)],
            headers: [
                "Authorization": "Basic \(configuration.token)",
                "Content-Type": "application/json"
            ]
        )
        print(target.cURLRepresentation())

        do {
            let data = try await requester.makeRequest(target)
            return try JSON(data: data)

        } catch {
            print("failed \(error)")
            print(target.cURLRepresentation())
            throw error
        }
    }
}
