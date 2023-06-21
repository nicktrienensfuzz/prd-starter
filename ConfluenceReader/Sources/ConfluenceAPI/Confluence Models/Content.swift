//
//  Confluence Content.swift
//
//
//  Created by Nicholas Trienens on 2/8/22.
//

import Foundation

public enum Confluence {
    // MARK: - Content
    public struct ContentListResponse: Codable, Equatable {
        public let results: [Content]
        public let start: Int
        public let limit: Int
        public let size: Int
        public let links: ContentLinks

        enum CodingKeys: String, CodingKey {
            case results
            case start
            case limit
            case size
            case links = "_links"
        }

        public init(results: [Content], start: Int, limit: Int, size: Int, links: ContentLinks) {
            self.results = results
            self.start = start
            self.limit = limit
            self.size = size
            self.links = links
        }
    }

    // MARK: - ContentLinks
    public struct ContentLinks: Codable, Equatable {
        public let base: String
        public let context: String
        public let next: String?
        public let linksSelf: String

        enum CodingKeys: String, CodingKey {
            case base
            case context
            case next
            case linksSelf = "self"
        }

        public init(base: String, context: String, next: String?, linksSelf: String) {
            self.base = base
            self.context = context
            self.next = next
            self.linksSelf = linksSelf
        }
    }

    //
    // Hashable or Equatable:
    // The compiler will not be able to synthesize the implementation of Hashable or Equatable
    // for types that require the use of JSONAny, nor will the implementation of Hashable be
    // synthesized for types that have collections (such as arrays or dictionaries).

    // MARK: - Result
    public struct Content: Codable, Equatable {
        public let id: String
        public let type: TypeEnum
        public let status: Status
        public let title: String
        public var body: Body
        public let children: Children
        public let version: VersionElement

        enum CodingKeys: String, CodingKey {
            case id
            case type
            case status
            case title
            case body
            case version
            case children
        }
    }

    // MARK: - Body
    public struct Body: Codable, Equatable {
        public var view: View

        enum CodingKeys: String, CodingKey {
            case view
        }

        public init(view: View) {
            self.view = view
        }
    }

    // MARK: - View
    public struct View: Codable, Equatable {
        public var value: String
        public let representation: Representation

        enum CodingKeys: String, CodingKey {
            case value
            case representation
        }

        public init(value: String, representation: Representation) {
            self.value = value
            self.representation = representation
        }
    }

    public enum Representation: String, Codable, Equatable {
        case view
    }

    public enum Status: String, Codable, Equatable {
        case archived
        case current
    }

    public enum TypeEnum: String, Codable, Equatable {
        case page
    }

    // MARK: - Children
    public struct Children: Codable, Equatable {
        public let attachment: Attachment
        public let comment: Attachment
        public let page: Attachment

        enum CodingKeys: String, CodingKey {
            case attachment
            case comment
            case page
        }

        public init(attachment: Attachment, comment: Attachment, page: Attachment) {
            self.attachment = attachment
            self.comment = comment
            self.page = page
        }
    }

    // MARK: - Attachment
    public struct Attachment: Codable, Equatable {
        public let results: [ChildPage]
        public let start: Int
        public let limit: Int
        public let size: Int

        enum CodingKeys: String, CodingKey {
            case results
            case start
            case limit
            case size
        }

        public init(results: [ChildPage], start: Int, limit: Int, size: Int) {
            self.results = results
            self.start = start
            self.limit = limit
            self.size = size
        }
    }

    // MARK: - Result
    public struct ChildPage: Codable, Equatable {
        public let id: String
        public let type: String
        public let status: String
        public let title: String

        enum CodingKeys: String, CodingKey {
            case id
            case type
            case status
            case title
        }

        public init(id: String, type: String, status: String, title: String) {
            self.id = id
            self.type = type
            self.status = status
            self.title = title
        }
    }
}
