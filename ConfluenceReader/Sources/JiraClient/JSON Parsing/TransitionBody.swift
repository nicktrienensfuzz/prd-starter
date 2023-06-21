//
//  File.swift
//
//
//  Created by Nicholas Trienens on 2/1/22.
//

import Foundation

// MARK: - TransitionBody
public struct TransitionBody: Codable {
    public let update: Update?
    public let fields: Fields?
    public let transition: Transition

    enum CodingKeys: String, CodingKey {
        case update
        case fields
        case transition
    }

    public init(comment: String? = nil, resolution: String? = nil, transitionId: String) {
        if let comment = comment {
            update = Update(comment: [.init(add: Add(body: comment))])
        } else {
            update = nil
        }
        if let resolution = resolution {
            fields = Fields(resolution: .init(name: resolution))
        } else {
            fields = nil
        }
        transition = Transition(id: transitionId)
    }

    // MARK: - Fields
    public struct Fields: Codable {
        public let resolution: Resolution

        enum CodingKeys: String, CodingKey {
            case resolution
        }

        public init(resolution: Resolution) {
            self.resolution = resolution
        }
    }

    // MARK: - Resolution
    public struct Resolution: Codable {
        public let name: String

        enum CodingKeys: String, CodingKey {
            case name
        }

        public init(name: String) {
            self.name = name
        }
    }

    // MARK: - Transition
    public struct Transition: Codable {
        public let id: String

        enum CodingKeys: String, CodingKey {
            case id
        }

        public init(id: String) {
            self.id = id
        }
    }

    // MARK: - Update
    public struct Update: Codable {
        public let comment: [Comment]

        enum CodingKeys: String, CodingKey {
            case comment
        }

        public init(comment: [Comment]) {
            self.comment = comment
        }
    }

    // MARK: - Comment
    public struct Comment: Codable {
        public let add: Add

        enum CodingKeys: String, CodingKey {
            case add
        }

        public init(add: Add) {
            self.add = add
        }
    }

    // MARK: - Add
    public struct Add: Codable {
        public let body: String

        enum CodingKeys: String, CodingKey {
            case body
        }

        public init(body: String) {
            self.body = body
        }
    }
}
