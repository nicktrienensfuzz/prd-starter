//
//  File.swift
//
//
//  Created by Nicholas Trienens on 2/1/22.
//

import Foundation

// MARK: - StatusBytTypeElement
public struct StatusByType: Codable {
    public let statusByTypeSelf: String
    public let id: String
    public let name: String
    public let subtask: Bool
    public let statuses: [Status]

    enum CodingKeys: String, CodingKey {
        case statusByTypeSelf = "self"
        case id
        case name
        case subtask
        case statuses
    }

    public init(statusBytTypeSelf: String, id: String, name: String, subtask: Bool, statuses: [Status]) {
        statusByTypeSelf = statusBytTypeSelf
        self.id = id
        self.name = name
        self.subtask = subtask
        self.statuses = statuses
    }

    // MARK: - Status
    public struct Status: Codable {
        public let statusSelf: String
        public let statusDescription: String
        public let iconUrl: String
        public let name: String
        public let untranslatedName: String
        public let id: String
        public let statusCategory: StatusCategory

        enum CodingKeys: String, CodingKey {
            case statusSelf = "self"
            case statusDescription = "description"
            case iconUrl
            case name
            case untranslatedName
            case id
            case statusCategory
        }

        public init(statusSelf: String, statusDescription: String, iconUrl: String, name: String, untranslatedName: String, id: String, statusCategory: StatusCategory) {
            self.statusSelf = statusSelf
            self.statusDescription = statusDescription
            self.iconUrl = iconUrl
            self.name = name
            self.untranslatedName = untranslatedName
            self.id = id
            self.statusCategory = statusCategory
        }
    }

    // MARK: - StatusCategory
    public struct StatusCategory: Codable {
        public let statusCategorySelf: String
        public let id: Int
        public let key: Key
        public let colorName: ColorName
        public let name: Name

        enum CodingKeys: String, CodingKey {
            case statusCategorySelf = "self"
            case id
            case key
            case colorName
            case name
        }

        public init(statusCategorySelf: String, id: Int, key: Key, colorName: ColorName, name: Name) {
            self.statusCategorySelf = statusCategorySelf
            self.id = id
            self.key = key
            self.colorName = colorName
            self.name = name
        }
    }

    public enum ColorName: String, Codable {
        case blueGray = "blue-gray"
        case green
        case yellow
    }

    public enum Key: String, Codable {
        case done
        case indeterminate
        case new
    }

    public enum Name: String, Codable {
        case done = "Done"
        case inProgress = "In Progress"
        case toDo = "To Do"
    }
}
