//
//  File.swift
//
//
//  Created by Nicholas Trienens on 6/21/22.
//

import Foundation

public struct Version: Codable {
    public let versionSelf: String
    public let id: String
    public let versionDescription: String?
    public let name: String
    public let archived: Bool
    public let released: Bool
    public let startDate: Date?
    public let releaseDate: Date?
    public let userStartDate: String?
    public let userReleaseDate: String?
    public let projectID: Int
    public let overdue: Bool?

    enum CodingKeys: String, CodingKey {
        case versionSelf = "self"
        case id
        case versionDescription = "description"
        case name
        case archived
        case released
        case startDate
        case releaseDate
        case userStartDate
        case userReleaseDate
        case projectID = "projectId"
        case overdue
    }

    public init(
        versionSelf: String,
        id: String,
        versionDescription: String?,
        name: String,
        archived: Bool,
        released: Bool,
        startDate: Date?,
        releaseDate: Date?,
        userStartDate: String?,
        userReleaseDate: String?,
        projectID: Int,
        overdue: Bool?
    ) {
        self.versionSelf = versionSelf
        self.id = id
        self.versionDescription = versionDescription
        self.name = name
        self.archived = archived
        self.released = released
        self.startDate = startDate
        self.releaseDate = releaseDate
        self.userStartDate = userStartDate
        self.userReleaseDate = userReleaseDate
        self.projectID = projectID
        self.overdue = overdue
    }
}
