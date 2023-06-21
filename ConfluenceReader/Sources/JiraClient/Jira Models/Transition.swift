//
//  File.swift
//
//
//  Created by Nicholas Trienens on 2/1/22.
//

import Foundation

public struct TransitionResponse: Codable {
    public let expand: String
    public let transitions: [Transition]

    enum CodingKeys: String, CodingKey {
        case expand
        case transitions
    }

    public init(expand: String, transitions: [Transition]) {
        self.expand = expand
        self.transitions = transitions
    }
}

// MARK: - Transition
public struct Transition: Codable {
    public let id: String
    public let name: String
    public let to: To
    public let hasScreen: Bool
    public let isGlobal: Bool
    public let isInitial: Bool
    public let isAvailable: Bool
    public let isConditional: Bool
    public let isLooped: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case to
        case hasScreen
        case isGlobal
        case isInitial
        case isAvailable
        case isConditional
        case isLooped
    }

    public init(id: String, name: String, to: To, hasScreen: Bool, isGlobal: Bool, isInitial: Bool, isAvailable: Bool, isConditional: Bool, isLooped: Bool) {
        self.id = id
        self.name = name
        self.to = to
        self.hasScreen = hasScreen
        self.isGlobal = isGlobal
        self.isInitial = isInitial
        self.isAvailable = isAvailable
        self.isConditional = isConditional
        self.isLooped = isLooped
    }
}

// MARK: - To
public struct To: Codable {
    public let toSelf: String
    public let toDescription: String
    public let iconUrl: String
    public let name: String
    public let id: String
    public let statusCategory: StatusCategory

    enum CodingKeys: String, CodingKey {
        case toSelf = "self"
        case toDescription = "description"
        case iconUrl
        case name
        case id
        case statusCategory
    }

    public init(toSelf: String, toDescription: String, iconUrl: String, name: String, id: String, statusCategory: StatusCategory) {
        self.toSelf = toSelf
        self.toDescription = toDescription
        self.iconUrl = iconUrl
        self.name = name
        self.id = id
        self.statusCategory = statusCategory
    }
}

// MARK: - StatusCategory
public struct StatusCategory: Codable {
    public let statusCategorySelf: String
    public let id: Int
    public let key: String
    public let colorName: String
    public let name: String

    enum CodingKeys: String, CodingKey {
        case statusCategorySelf = "self"
        case id
        case key
        case colorName
        case name
    }

    public init(statusCategorySelf: String, id: Int, key: String, colorName: String, name: String) {
        self.statusCategorySelf = statusCategorySelf
        self.id = id
        self.key = key
        self.colorName = colorName
        self.name = name
    }
}
