//
//  File.swift
//
//
//  Created by Nicholas Trienens on 6/17/22.
//

import Foundation

public extension Confluence {
    // MARK: - ContentUpdateResponse
    struct ContentUpdateResponse: Codable {
        public let id: String
        public let type: String
        public let status: String
        public let title: String
        public let space: Space
        public let version: Version
        public let ancestors: [Ancestor]
        public let body: Body

        enum CodingKeys: String, CodingKey {
            case id
            case type
            case status
            case title
            case space
            case version
            case ancestors
            case body
        }

        public init(id: String, type: String, status: String, title: String, space: Space, version: Version, ancestors: [Ancestor], body: Body) {
            self.id = id
            self.type = type
            self.status = status
            self.title = title
            self.space = space
            self.version = version
            self.ancestors = ancestors
            self.body = body
        }

        // MARK: - Body
        public struct Body: Codable {
            public let storage: Storage

            enum CodingKeys: String, CodingKey {
                case storage
            }

            public init(storage: Storage) {
                self.storage = storage
            }
        }

        // MARK: - Storage
        public struct Storage: Codable {
            public let value: String
            public let representation: String

            enum CodingKeys: String, CodingKey {
                case value
                case representation
            }

            public init(value: String, representation: String) {
                self.value = value
                self.representation = representation
            }
        }
    }

    // MARK: - Ancestor
    struct Ancestor: Codable {
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

    // MARK: - Space
    struct Space: Codable {
        public let id: Int
        public let key: String
        public let name: String
        public let type: String
        public let status: String

        enum CodingKeys: String, CodingKey {
            case id
            case key
            case name
            case type
            case status
        }

        public init(id: Int, key: String, name: String, type: String, status: String) {
            self.id = id
            self.key = key
            self.name = name
            self.type = type
            self.status = status
        }
    }
}
