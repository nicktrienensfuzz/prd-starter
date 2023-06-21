//
//  SheetsList.swift
//  
//
//  Created by Nicholas Trienens on 6/1/22.
//

import Foundation

// MARK: - Sheet
public struct SheetsList: Codable {
    public let pageNumber: Int
    public let pageSize: Int
    public let totalPages: Int
    public let totalCount: Int
    public let data: [Sheet]

    enum CodingKeys: String, CodingKey {
        case pageNumber = "pageNumber"
        case pageSize = "pageSize"
        case totalPages = "totalPages"
        case totalCount = "totalCount"
        case data = "data"
    }

    public init(pageNumber: Int, pageSize: Int, totalPages: Int, totalCount: Int, data: [Sheet]) {
        self.pageNumber = pageNumber
        self.pageSize = pageSize
        self.totalPages = totalPages
        self.totalCount = totalCount
        self.data = data
    }
}

import Foundation

// MARK: - Input
/*
public struct Sheet: Codable {
    public let id: SheetId
    public let name: String
    public let accessLevel: String
    public let permalink: String
    public let createdAt: Date = .now
    public let modifiedAt: Date = .now
}
*/
// MARK: - EndInput

public struct Sheet: Codable {
    public let id: SheetId
    public let name: String
    public let accessLevel: String
    public let permalink: String
    public let createdAt: Date
    public let modifiedAt: Date

    public init(
        id: SheetId,
        name: String,
        accessLevel: String,
        permalink: String,
        createdAt: Date = .now,
        modifiedAt: Date = .now
    ){
        self.id = id
        self.name = name
        self.accessLevel = accessLevel
        self.permalink = permalink
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case accessLevel = "accessLevel"
        case permalink = "permalink"
        case createdAt = "createdAt"
        case modifiedAt = "modifiedAt"
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(SheetId.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        accessLevel = try values.decode(String.self, forKey: .accessLevel)
        permalink = try values.decode(String.self, forKey: .permalink)
        createdAt = (try? values.decode(Date.self, forKey: .createdAt)) ?? .now
        modifiedAt = (try? values.decode(Date.self, forKey: .modifiedAt)) ?? .now
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(accessLevel, forKey: .accessLevel)
        try container.encode(permalink, forKey: .permalink)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(modifiedAt, forKey: .modifiedAt)
    }

    public func toSwift() -> String {
            """
            Sheet(
                id: \(id),
                name: "\(name)",
                accessLevel: "\(accessLevel)",
                permalink: "\(permalink)",
                createdAt:  Date(timeIntervalSince1970: \(createdAt.timeIntervalSince1970)),
                modifiedAt:  Date(timeIntervalSince1970: \(modifiedAt.timeIntervalSince1970))
                )
            """
    }
 }
