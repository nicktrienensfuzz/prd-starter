//
//  File.swift
//
//
//  Created by Nicholas Trienens on 6/17/22.
//

import Foundation

// MARK: - EpicsForBoard
public typealias EpicsForBoard = PagedResponse<Epic>
public typealias SprintsForBoard = PagedResponse<Sprint>
public typealias PagedIssues = PagedResponse<Issue>
// MARK: - Value
public struct Epic: Codable, Equatable, Hashable {
    public let id: Int
    public let key: String
    public let valueSelf: String
    public let name: String
    public let summary: String
    public let color: Color
    public let done: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case key
        case valueSelf = "self"
        case name
        case summary
        case color
        case done
    }

    public init(id: Int, key: String, valueSelf: String, name: String, summary: String, color: Color, done: Bool) {
        self.id = id
        self.key = key
        self.valueSelf = valueSelf
        self.name = name
        self.summary = summary
        self.color = color
        self.done = done
    }

    // MARK: - Color
    public struct Color: Codable, Equatable, Hashable {
        public let key: String

        enum CodingKeys: String, CodingKey {
            case key
        }

        public init(key: String) {
            self.key = key
        }
    }
}
