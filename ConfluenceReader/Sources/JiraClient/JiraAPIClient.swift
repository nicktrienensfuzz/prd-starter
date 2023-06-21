import Foundation
import Networker

public class JiraAPIClient {
    let configuration: JiraConfigurationInterface
    let requester: Requester

    public init(configuration: JiraConfigurationInterface, requester: Requester = RequestMaker()) {
        self.configuration = configuration
        // super.init(baseURLString: "https://monstarlab.atlassian.net/rest/")
        self.requester = requester
    }

    public func issue(identifier: String) async throws -> Issue {
        let target = Endpoint(
            method: .GET,
            path: configuration.baseURL + "api/2/issue/\(identifier)",
            parameters: [],
            headers: ["Authorization": "Basic \(configuration.token)"]
        )

        let data = try await requester.makeRequest(target)

        do {
            return try jsonDecoder().decode(Issue.self, from: data)
        } catch {
            print(error)
            try? print(String(data: data, encoding: .utf8).unwrapped())
            throw error
        }
    }

    public func createIssue(
        projectKey: String,
        summary: String,
        description: String,
        issuetype: IssueCreate.Issuetype.Kind,
        labels: [String] = []
    ) async throws -> IssueReference {
        let object = IssueCreate(
            projectKey: projectKey,
            summary: summary,
            description: description,
            issuetype: issuetype,
            labels: labels + ["Generated"],
            assignee: .init(id: nil, accountId: "")
        )

        let target = Endpoint(
            method: .POST,
            path: configuration.baseURL + "api/2/issue",
            parameters: [.encodable(.init(object), .body)],
            headers: [
                "Authorization": "Basic \(configuration.token)",
                "Content-Type": "application/json"
            ]
        )

        let data = try await requester.makeRequest(target)
        do {
            return try jsonDecoder().decode(IssueReference.self, from: data)
        } catch {
            print(error)
            try? print(String(data: data, encoding: .utf8).unwrapped())
            throw error
        }
    }

    public func getTransitions(issueKey: String) async throws -> TransitionResponse {
        let target = Endpoint(
            method: .GET,
            path: configuration.baseURL + "api/2/issue/\(issueKey)/transitions",
            headers: [
                "Authorization": "Basic \(configuration.token)",
                "Content-Type": "application/json"
            ]
        )

        let data = try await requester.makeRequest(target)
        do {
            return try jsonDecoder().decode(TransitionResponse.self, from: data)
        } catch {
            print(error)
            try? print(String(data: data, encoding: .utf8).unwrapped())
            throw error
        }
    }

    public func sendTransition(issueKey: String, transitionId: String) async throws {
        let object = TransitionBody(
            comment: "Updated by jira View to a Computed Status",
            resolution: nil,
            transitionId: transitionId
        )

        let target = Endpoint(
            method: .POST,
            path: configuration.baseURL + "api/2/issue/\(issueKey)/transitions",
            parameters: [.encodable(.init(object), .body)],
            headers: [
                "Authorization": "Basic \(configuration.token)",
                "Content-Type": "application/json"
            ]
        )

        let _ = try await requester.makeRequest(target)
    }

    public func updateIssue(issueKey: String, summary: String) async throws -> IssueReference {
        let object = ["fields": ["summary": summary]]
        let target = Endpoint(
            method: .PUT,
            path: configuration.baseURL + "api/2/issue/\(issueKey)",
            parameters: [.encodable(.init(object), .body)],
            headers: [
                "Authorization": "Basic \(configuration.token)",
                "Content-Type": "application/json"
            ]
        )

        let data = try await requester.makeRequest(target)
        do {
            return try jsonDecoder().decode(IssueReference.self, from: data)
        } catch {
            print(error)
            try? print(String(data: data, encoding: .utf8).unwrapped())
            throw error
        }
    }

    public enum IssueTypeSearch: String, CaseIterable {
        case epic = "Epic"
        case chore = "Chore"
        case story = "Story"
        case bug = "Bug"
        case any = "Any Type"

        public init?(rawValue: String) {
            switch rawValue.lowercased() {
            case "epic": self = .epic
            case "chore": self = .chore
            case "story": self = .story
            case "bug": self = .bug
            default: return nil
            }
        }
    }

    public func issues(
        projectKey: String,
        labeled: [String] = [],
        type: IssueTypeSearch? = nil,
        limit: Int? = nil,
        startAt: Int? = nil
    ) async throws -> IssueResponse {
        var jql = """
        project = \(projectKey)
        """

        if let type = type, type != .any {
            jql += """
             AND issuetype = "\(type.rawValue)"
            """
        }

        if !labeled.isEmpty {
            jql += " AND labels = " + labeled.joined(separator: " AND labels = ")
        }

        let maxPerRequest = min(150, limit ?? 150)
        let target = Endpoint(
            method: .GET,
            path: configuration.baseURL + "api/2/search?jql=\(jql.addingPercentEncodingForURLQueryValue())&startAt=\(startAt ?? 0)&maxResults=\(maxPerRequest)",
            headers: [
                "Authorization": "Basic \(configuration.token)",
                "Content-Type": "application/json"
            ]
        )

        let data = try await requester.makeRequest(target)
        do {
            var response = try jsonDecoder().decode(IssueResponse.self, from: data)

            while response.total > response.startAt + response.maxResults {
                if let limit, response.total > limit { break }
                let nextResponse = try await issues(
                    projectKey: projectKey,
                    labeled: labeled,
                    type: type,
                    limit: limit,
                    startAt: response.nextIndex()
                )
                response = nextResponse.append(response.issues)
            }
            return response
        } catch {
            print(error)
            try? print(String(data: data, encoding: .utf8).unwrapped())
            throw error
        }
    }

    public func getEpics(forBoard: Int, startAt: Int? = nil) async throws -> EpicsForBoard {
        let target = Endpoint(
            method: .GET,
            path: configuration.baseURL + "agile/1.0/board/\(forBoard)/epic?startAt=\(startAt ?? 0)&maxResults=50",
            headers: [
                "Authorization": "Basic \(configuration.token)",
                "Content-Type": "application/json"
            ]
        )

        let data = try await requester.makeRequest(target)
        do {
            var response = try jsonDecoder().decode(EpicsForBoard.self, from: data)

            while response.hasMore {
                let nextResponse = try await getEpics(forBoard: forBoard, startAt: response.nextIndex())
                response = nextResponse.append(response.values)
            }
            return response
        } catch {
            print(error)
            try? print(String(data: data, encoding: .utf8).unwrapped())
            throw error
        }

//
//        return request(target)
//            .decode(type: EpicsForBoard.self, decoder: jsonDecoder())
//            .flatMap{ response -> AnyPublisher<EpicsForBoard, Error> in
//
//
//                if response.hasMore {
//                    return self.getEpics(forBoard: forBoard, startAt: response.nextIndex())
//                        .flatMap { nextResponse -> AnyPublisher<EpicsForBoard, Error> in
//                            Just(nextResponse.append(response.values))
//                                .setFailureType(to: Error.self)
//                                .eraseToAnyPublisher()
//                        }
//                        .eraseToAnyPublisher()
//                } else {
//                    return Just(response)
//                        .setFailureType(to: Error.self)
//                        .eraseToAnyPublisher()
//                }
//            }
//            .eraseToAnyPublisher()
    }

    /*
     public func projects(startAt: Int? = nil) -> AnyPublisher<ProjectsResponse, Error> {
         let target = Endpoint(method: .get,
                               path: "api/3/project/search?startAt=\(startAt ?? 0)&orderBy=lastIssueUpdatedTime&maxResults=200",
                               headers: ["Authorization": "Basic \(configuration.token)",
                                         "Content-Type": "application/json"])

         return request(target)
             .decode(type: ProjectsResponse.self, decoder: jsonDecoder())
             .flatMap{ response -> AnyPublisher<ProjectsResponse, Error> in
                 if response.total > response.startAt + response.maxResults {
                    return self.projects(startAt: response.nextIndex())
                         .map{ nextResponse -> ProjectsResponse in
                             response.append(nextResponse.projects)
                         }
                         .eraseToAnyPublisher()
                 } else {
                     return Just(response)
                         .setFailureType(to: Error.self)
                         .eraseToAnyPublisher()
                 }
             }
             .eraseToAnyPublisher()
     }

     public func versions(forProjectKey: String) -> AnyPublisher<[Version], Error> {
         let target = Endpoint(method: .get,
                               path: "api/3/project/\(forProjectKey)/versions",
                               headers: ["Authorization": "Basic \(configuration.token)",
                                         "Content-Type": "application/json"])

         return request(target)
             .decode(type: [Version].self, decoder: jsonDecoder())
             .eraseToAnyPublisher()
     }

     public func board(forProjectKey: String) -> AnyPublisher<BoardsForProjectResponse, Error> {
         let target = Endpoint(method: .get,
                               path: "agile/1.0/board?projectKeyOrId=\(forProjectKey)",
                               headers: ["Authorization": "Basic \(configuration.token)",
                                         "Content-Type": "application/json"])

         return request(target)
             .decode(type: BoardsForProjectResponse.self, decoder: jsonDecoder())
             .eraseToAnyPublisher()
     }

     public func getIssues(forBoard: Int) -> AnyPublisher<IssueResponse, Error> {
         let target = Endpoint(method: .get,
                               path: "agile/1.0/board/\(forBoard)/issue",
                               headers: ["Authorization": "Basic \(configuration.token)",
                                         "Content-Type": "application/json"])

         return request(target)
             .decode(type: IssueResponse.self, decoder: jsonDecoder())
             .eraseToAnyPublisher()
     }

     public func getSprints(forBoard: Int, startAt: Int? = nil) -> AnyPublisher<SprintsForBoard, Error> {
         let target = Endpoint(method: .get,
                               path: "agile/1.0/board/\(forBoard)/sprint?startAt=\(startAt ?? 0)&maxResults=50",
                               headers: ["Authorization": "Basic \(configuration.token)",
                                         "Content-Type": "application/json"])

         return request(target)
             .decode(type: SprintsForBoard.self, decoder: jsonDecoder())
             .flatMap{ response -> AnyPublisher<SprintsForBoard, Error> in
                 if response.hasMore {
                     return self.getSprints(forBoard: forBoard, startAt: response.nextIndex())
                         .flatMap { nextResponse -> AnyPublisher<SprintsForBoard, Error> in
                             Just(nextResponse.append(response.values))
                                 .setFailureType(to: Error.self)
                                 .eraseToAnyPublisher()
                         }
                         .eraseToAnyPublisher()
                 } else {
                     return Just(response)
                         .setFailureType(to: Error.self)
                         .eraseToAnyPublisher()
                 }
             }
             .eraseToAnyPublisher()
     }

     public func getIssues(forSprint: Int, startAt: Int? = nil) -> AnyPublisher<IssueResponse, Error> {
         let target = Endpoint(method: .get,
                               path: "agile/1.0/sprint/\(forSprint)/issue?startAt=\(startAt ?? 0)&maxResults=50",
                               headers: ["Authorization": "Basic \(configuration.token)",
                                         "Content-Type": "application/json"])

         return request(target)
             .decode(type: IssueResponse.self, decoder: jsonDecoder())
             .flatMap{ response -> AnyPublisher<IssueResponse, Error> in
                 if response.hasMore {
                     return self.getIssues(forSprint: forSprint, startAt: response.nextIndex())
                         .flatMap { nextResponse -> AnyPublisher<IssueResponse, Error> in
                             Just(nextResponse.append(response.issues))
                                 .setFailureType(to: Error.self)
                                 .eraseToAnyPublisher()
                         }
                         .eraseToAnyPublisher()
                 } else {
                     return Just(response)
                         .setFailureType(to: Error.self)
                         .eraseToAnyPublisher()
                 }
             }
             .eraseToAnyPublisher()
     }
     public func getIssues(epicKey: String, startAt: Int? = nil) -> AnyPublisher<IssueResponse, Error> {

             let jql =  """
                parentEpic = \(epicKey)
                """

             let target = Endpoint(method: .get,
                                   path: "api/2/search?jql=\(jql.addingPercentEncodingForURLQueryValue())&startAt=\(startAt ?? 0)&maxResults=150",
                                   headers: ["Authorization": "Basic \(configuration.token)",
                                             "Content-Type": "application/json"])

             return request(target)
                 .decode(type: IssueResponse.self, decoder: jsonDecoder())
                 .flatMap{ response -> AnyPublisher<IssueResponse, Error> in
                     if response.total > response.startAt + response.maxResults {
                        return self.getIssues(epicKey: epicKey, startAt: response.nextIndex())
                             .map { nextResponse -> IssueResponse in
                                 response.append(nextResponse.issues)
                             }
                             .eraseToAnyPublisher()

                     } else {
                         return Just(response)
                             .setFailureType(to: Error.self)
                             .eraseToAnyPublisher()

                     }
                 }
                 .eraseToAnyPublisher()
     }
     */
    public func getStatuses(projectKey: String, issueType: IssueTypeSearch) async throws -> StatusByType {
        let target = Endpoint(
            method: .GET,
            path: configuration.baseURL + "api/2/project/\(projectKey)/statuses",
            headers: [
                "Authorization": "Basic \(configuration.token)",
                "Content-Type": "application/json"
            ]
        )

        let data = try await requester.makeRequest(target)
        do {
            let response = try jsonDecoder().decode([StatusByType].self, from: data)
            return response.first(where: { $0.name == issueType.rawValue }) ?? response[0]
        } catch {
            print(error)
            try? print(String(data: data, encoding: .utf8).unwrapped())
            throw error
        }
    }

    func jsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()

        decoder.dateDecodingStrategy = .custom { decoder throws -> Date in
            let container = try decoder.singleValueContainer()
            let dateString: String = try container.decode(String.self)

            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = formatter.date(from: dateString) {
                return date
            }

            let oldFormatter = DateFormatter()
            oldFormatter.calendar = Calendar(identifier: .iso8601)
            oldFormatter.locale = Locale(identifier: "en_US_POSIX")
            oldFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            oldFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ'"
            if let date = oldFormatter.date(from: dateString) {
                return date
            }

            oldFormatter.dateFormat = "yyyy-MM-dd"
            if let date = oldFormatter.date(from: dateString) {
                return date
            }

            if dateString.hasPrefix("1970-01-01T00:00:00") {
                print("⚠️ Invalid ISO8601 date: \(dateString)")
                return Date()
            }

            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(dateString)")
        }
        return decoder
    }
}
