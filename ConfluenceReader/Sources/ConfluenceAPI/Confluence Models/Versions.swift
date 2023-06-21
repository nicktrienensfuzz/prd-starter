//
//  File.swift
//
//
//  Created by Nicholas Trienens on 6/15/22.
//

import Foundation
public extension Confluence {
    struct VersionResponse: Codable {
        public let results: [VersionElement]
        public init(
            results: [VersionElement]
        ) {
            self.results = results
        }

        enum CodingKeys: String, CodingKey {
            case results
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            do {
                results = try values.decode([VersionElement].self, forKey: .results)
            } catch {
                results = []
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(results, forKey: .results)
        }

        public func toSwift() -> String {
            """
            VersionResponse(
                results: \(results))
            """
        }
    }

    struct VersionElement: Codable, Hashable, Equatable {
        public let by: ByObject
        public let friendlyWhen: String
        public let message: String
        public let minorEdit: Bool
        public let number: Double
        public let when: String

        public init(
            by: ByObject,
            friendlyWhen: String,
            message: String,
            minorEdit: Bool,
            number: Double,
            when: String
        ) {
            self.by = by
            self.friendlyWhen = friendlyWhen
            self.message = message
            self.minorEdit = minorEdit
            self.number = number
            self.when = when
        }

        enum CodingKeys: String, CodingKey {
            case by
            case friendlyWhen
            case message
            case minorEdit
            case number
            case when
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            by = try values.decode(ByObject.self, forKey: .by)
            friendlyWhen = try values.decode(String.self, forKey: .friendlyWhen)
            message = try values.decode(String.self, forKey: .message)
            minorEdit = try values.decode(Bool.self, forKey: .minorEdit)
            number = try values.decode(Double.self, forKey: .number)
            when = try values.decode(String.self, forKey: .when)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(by, forKey: .by)
            try container.encode(friendlyWhen, forKey: .friendlyWhen)
            try container.encode(message, forKey: .message)
            try container.encode(minorEdit, forKey: .minorEdit)
            try container.encode(number, forKey: .number)
            try container.encode(when, forKey: .when)
        }

        public func toSwift() -> String {
            """
            ResultsElement(
                by: \(by),
                friendlyWhen: "\(friendlyWhen)"
                ,
                message: "\(message)"
                ,
                minorEdit: \(minorEdit),
                number: \(number),
                when: "\(when)"
                )
            """
        }
    }

    struct ByObject: Codable, Hashable, Equatable {
        public let displayName: String
        public let email: String
        public let isExternalCollaborator: Bool
        public let publicName: String
        public let type: String

        public init(
            displayName: String,
            email: String,
            isExternalCollaborator: Bool,
            publicName: String,
            type: String
        ) {
            self.displayName = displayName
            self.email = email
            self.isExternalCollaborator = isExternalCollaborator
            self.publicName = publicName
            self.type = type
        }

        enum CodingKeys: String, CodingKey {
            case displayName
            case email
            case isExternalCollaborator
            case publicName
            case type
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            displayName = try values.decode(String.self, forKey: .displayName)
            email = try values.decode(String.self, forKey: .email)
            isExternalCollaborator = try values.decode(Bool.self, forKey: .isExternalCollaborator)
            publicName = try values.decode(String.self, forKey: .publicName)
            type = try values.decode(String.self, forKey: .type)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(displayName, forKey: .displayName)
            try container.encode(email, forKey: .email)
            try container.encode(isExternalCollaborator, forKey: .isExternalCollaborator)
            try container.encode(publicName, forKey: .publicName)
            try container.encode(type, forKey: .type)
        }

        public func toSwift() -> String {
            """
            ByObject(
                displayName: "\(displayName)"
                ,
                email: "\(email)"
                ,
                isExternalCollaborator: \(isExternalCollaborator),
                publicName: "\(publicName)"
                ,
                type: "\(type)"
                )
            """
        }
    }
}
