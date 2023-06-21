//
//  ProjectsResponse.swift
//
//
//  Created by Nicholas Trienens on 6/9/22.
//

import Foundation

// MARK: - ProjectsResponse
public struct ProjectsResponse: Codable {
    public let projectsResponseSelf: String?
    public let nextPage: String?
    public let maxResults: Int
    public let startAt: Int
    public let total: Int
    public let isLast: Bool
    public var projects: [Project]

    enum CodingKeys: String, CodingKey {
        case projectsResponseSelf = "self"
        case nextPage
        case maxResults
        case startAt
        case total
        case isLast
        case projects = "values"
    }

    public init(projectsResponseSelf: String?, nextPage: String?, maxResults: Int, startAt: Int, total: Int, isLast: Bool, projects: [Project]) {
        self.projectsResponseSelf = projectsResponseSelf
        self.nextPage = nextPage
        self.maxResults = maxResults
        self.startAt = startAt
        self.total = total
        self.isLast = isLast
        self.projects = projects
    }

    func nextIndex() -> Int {
        let lastIndexFetched = startAt + (maxResults - 1)
        let lastIndexAvailable = total - 1
        if lastIndexFetched < lastIndexAvailable {
            return lastIndexFetched + 1
        } else {
            return -1
        }
    }

    func append(_ projects: [Project]) -> ProjectsResponse {
        ProjectsResponse(
            projectsResponseSelf: projectsResponseSelf,
            nextPage: nextPage,
            maxResults: maxResults,
            startAt: startAt,
            total: total,
            isLast: isLast,
            projects: self.projects + projects
        )
    }
}

// MARK: - Value
public struct Project: Codable {
    public let expand: Expand
    public let valueSelf: String
    public let id: String
    public let key: String
    public let name: String
    public let avatarUrls: AvatarUrls
    public let projectTypeKey: String
    public let simplified: Bool
    public let style: Style
    public let isPrivate: Bool
    public let properties: Properties
    public let entityID: String?
    public let uuid: String?
    public let projectCategory: ProjectCategory?

    enum CodingKeys: String, CodingKey {
        case expand
        case valueSelf = "self"
        case id
        case key
        case name
        case avatarUrls
        case projectTypeKey
        case simplified
        case style
        case isPrivate
        case properties
        case entityID = "entityId"
        case uuid
        case projectCategory
    }

    public init(
        expand: Expand,
        valueSelf: String,
        id: String,
        key: String,
        name: String,
        avatarUrls: AvatarUrls,
        projectTypeKey: String,
        simplified: Bool,
        style: Style,
        isPrivate: Bool,
        properties: Properties,
        entityID: String?,
        uuid: String?,
        projectCategory: ProjectCategory?
    ) {
        self.expand = expand
        self.valueSelf = valueSelf
        self.id = id
        self.key = key
        self.name = name
        self.avatarUrls = avatarUrls
        self.projectTypeKey = projectTypeKey
        self.simplified = simplified
        self.style = style
        self.isPrivate = isPrivate
        self.properties = properties
        self.entityID = entityID
        self.uuid = uuid
        self.projectCategory = projectCategory
    }
}

// MARK: - AvatarUrls
public struct AvatarUrls: Codable {
    public let the48X48: String
    public let the24X24: String
    public let the16X16: String
    public let the32X32: String

    enum CodingKeys: String, CodingKey {
        case the48X48 = "48x48"
        case the24X24 = "24x24"
        case the16X16 = "16x16"
        case the32X32 = "32x32"
    }

    public init(the48X48: String, the24X24: String, the16X16: String, the32X32: String) {
        self.the48X48 = the48X48
        self.the24X24 = the24X24
        self.the16X16 = the16X16
        self.the32X32 = the32X32
    }
}

public enum Expand: String, Codable {
    case descriptionLeadIssueTypesURLProjectKeysPermissionsInsight = "description,lead,issueTypes,url,projectKeys,permissions,insight"
}

// MARK: - ProjectCategory
public struct ProjectCategory: Codable {
    public let projectCategorySelf: String
    public let id: String
    public let name: Name
    public let projectCategoryDescription: Description

    enum CodingKeys: String, CodingKey {
        case projectCategorySelf = "self"
        case id
        case name
        case projectCategoryDescription = "description"
    }

    public init(projectCategorySelf: String, id: String, name: Name, projectCategoryDescription: Description) {
        self.projectCategorySelf = projectCategorySelf
        self.id = id
        self.name = name
        self.projectCategoryDescription = projectCategoryDescription
    }
}

public enum Name: String, Codable {
    case activeProjects = "Active Projects"
    case fuzzHROps = "Fuzz HR/Ops"
    case nameInternal = "Internal"
}

public enum Description: String, Codable {
    case activeProjects = "Active Projects"
    case anInternalProjectThatSOnlyUsedByNodesEmployees = "An internal project that's only used by Nodes employees"
    case empty = ""
}

// MARK: - Properties
public struct Properties: Codable {
    public init() {}
}

public enum Style: String, Codable {
    case classic
    case nextGen = "next-gen"
}
