//
//  Sprint.swift
//
//
//  Created by Nicholas Trienens on 2/1/22.
//

import Foundation

public struct Sprint: Codable {
    public let boardId: Int
    public let endDate: Date
    public let goal: String
    public let id: Int
    public let name: String
    public let startDate: Date
    public let state: String

    public init(
        boardId: Int,
        endDate: Date,
        goal: String,
        id: Int,
        name: String,
        startDate: Date,
        state: String
    ) {
        self.boardId = boardId
        self.endDate = endDate
        self.goal = goal
        self.id = id
        self.name = name
        self.startDate = startDate
        self.state = state
    }

    enum CodingKeys: String, CodingKey {
        case boardId
        case originBoardId
        case endDate
        case goal
        case id
        case name
        case startDate
        case state
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            boardId = try values.decode(Int.self, forKey: .boardId)
        } catch {
            boardId = try values.decode(Int.self, forKey: .originBoardId)
        }

        let oldFormatter = DateFormatter()
        oldFormatter.calendar = Calendar(identifier: .iso8601)
        oldFormatter.dateFormat = "yyyy-MM-dd"
        do {
            var endDateStr = try values.decode(String.self, forKey: .endDate)
            endDateStr = try endDateStr.prefix(upTo: endDateStr.firstIndex(of: "T").unwrapped()).asString
            endDate = try oldFormatter.date(from: endDateStr).unwrapped()
        } catch {
            endDate = .distantPast
        }
        do {
            var startDateStr = try values.decode(String.self, forKey: .startDate)
            startDateStr = try startDateStr.prefix(upTo: startDateStr.firstIndex(of: "T").unwrapped()).asString
            startDate = try oldFormatter.date(from: startDateStr).unwrapped()
        } catch {
            startDate = .distantPast
        }

        goal = try values.decode(String.self, forKey: .goal)
        id = try values.decode(Int.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)

        state = try values.decode(String.self, forKey: .state)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(boardId, forKey: .boardId)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(goal, forKey: .goal)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(state, forKey: .state)
    }

    public func toSwift() -> String {
        """
        Sprint(
            boardId: \(boardId),
            endDate: "\(endDate)",
            goal: "\(goal)",
            id: \(id),
            name: "\(name)",
            startDate: "\(startDate)",
            state: "\(state)"
            )
        """
    }
}
