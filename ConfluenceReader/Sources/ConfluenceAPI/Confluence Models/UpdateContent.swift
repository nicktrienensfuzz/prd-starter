//
//  File.swift
//
//
//  Created by Nicholas Trienens on 6/15/22.
//

import Foundation

public extension Confluence {
    // MARK: - ContentUpdateElement
    struct ContentCreate: Codable {
        public init(spaceId: String, title: String, ancestors: [Confluence.AncestorId]? = nil, body: String) {
            self.title = title
            type = "page"
            status = "current"
            self.ancestors = ancestors
            self.body = PostBody(content: body)
            space = SpaceKey(key: spaceId)
        }

        public let title: String
        public let type: String
        public let status: String
        public let ancestors: [AncestorId]?
        public let body: PostBody
        public let space: SpaceKey
    }

    // MARK: - ContentUpdateElement
    struct ContentUpdate: Codable {
        public let version: Version
        public let title: String
        public let type: String
        public let status: String
        public let ancestors: [AncestorId]?
        public let body: PostBody

        enum CodingKeys: String, CodingKey {
            case version
            case title
            case type
            case status
            case ancestors
            case body
        }

        public init(content: Confluence.Content, title: String? = nil, body: String? = nil) {
            version = .init(content.version.number + 1)
            self.title = title ?? content.title
            type = content.type.rawValue
            status = content.status.rawValue
            ancestors = nil
            self.body = PostBody(content:
                body ?? content.body.view.value
            )
        }

        public init(version: Version, title: String, type: String = "page", status: String = "current", ancestors: [AncestorId]? = nil, body: PostBody) {
            self.version = version
            self.title = title
            self.type = type
            self.status = status
            self.ancestors = ancestors
            self.body = body
        }
    }

    // MARK: - Ancestor
    struct AncestorId: Codable {
        public let id: String

        enum CodingKeys: String, CodingKey {
            case id
        }

        public init(id: String) {
            self.id = id
        }
    }

    // MARK: - Space
    struct SpaceKey: Codable {
        public let key: String

        public init(key: String) {
            self.key = key
        }
    }

    // MARK: - Body
    struct PostBody: Codable {
        // public let view: View
        public let storage: PostView

        enum CodingKeys: String, CodingKey {
            //  case view = "view"
            case storage
        }

        public init(content: String) {
            // view = .init(value: content, representation: "view")
            storage = .init(value: content, representation: "storage")
        }
    }

    // MARK: - View
    struct PostView: Codable {
        public let value: String
        public let representation: String

        enum CodingKeys: String, CodingKey {
            case value
            case representation
        }

        public init(value: String, representation: String = "storage") {
            self.value = value
            self.representation = representation
        }
    }

    // MARK: - Version
    struct Version: Codable, Equatable, Hashable {
        public let number: Double

        enum CodingKeys: String, CodingKey {
            case number
        }

        public init(_ number: Double) {
            self.number = number
        }
    }
}
