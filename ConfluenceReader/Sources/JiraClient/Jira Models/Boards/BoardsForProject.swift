//
//  BoardsForProject.swift
//
//
//  Created by Nicholas Trienens on 6/17/22.
//

import Foundation

// MARK: - BoardsForProject
public struct BoardsForProjectResponse: Codable {
    public let maxResults: Int
    public let startAt: Int
    public let total: Int
    public let isLast: Bool
    public let values: [Value]

    enum CodingKeys: String, CodingKey {
        case maxResults
        case startAt
        case total
        case isLast
        case values
    }

    public init(maxResults: Int, startAt: Int, total: Int, isLast: Bool, values: [Value]) {
        self.maxResults = maxResults
        self.startAt = startAt
        self.total = total
        self.isLast = isLast
        self.values = values
    }

    // MARK: - Value
    public struct Value: Codable {
        public let id: Int
        public let valueSelf: String
        public let name: String
        public let type: String
        public let location: Location

        enum CodingKeys: String, CodingKey {
            case id
            case valueSelf = "self"
            case name
            case type
            case location
        }

        public init(id: Int, valueSelf: String, name: String, type: String, location: Location) {
            self.id = id
            self.valueSelf = valueSelf
            self.name = name
            self.type = type
            self.location = location
        }
    }

    // MARK: - Location
    public struct Location: Codable {
        public let projectID: Int
        public let displayName: String
        public let projectName: String
        public let projectKey: String
        public let projectTypeKey: String
        public let avatarURI: String
        public let name: String

        enum CodingKeys: String, CodingKey {
            case projectID = "projectId"
            case displayName
            case projectName
            case projectKey
            case projectTypeKey
            case avatarURI
            case name
        }

        public init(projectID: Int, displayName: String, projectName: String, projectKey: String, projectTypeKey: String, avatarURI: String, name: String) {
            self.projectID = projectID
            self.displayName = displayName
            self.projectName = projectName
            self.projectKey = projectKey
            self.projectTypeKey = projectTypeKey
            self.avatarURI = avatarURI
            self.name = name
        }
    }
}
