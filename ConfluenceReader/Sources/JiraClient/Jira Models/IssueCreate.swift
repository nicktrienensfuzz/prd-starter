//
//  File.swift
//
//
//  Created by Nicholas Trienens on 10/7/21.
//

import Foundation

public struct IssueCreate: Codable {
    init(
        projectKey: String,
        summary: String,
        description: String,
        issuetype: IssueCreate.Issuetype.Kind,
        labels: [String],
        assignee: IssueCreate.Assignee? = nil
    ) {
        fields = .init(
            project: Project.init(key: projectKey),
            summary: summary,
            fieldsDescription: description,
            issuetype: .init(name: issuetype),
            labels: labels,
            assignee: nil
        )
    }

    let fields: Fields

    enum CodingKeys: String, CodingKey {
        case fields
    }

    // MARK: - Fields
    struct Fields: Codable {
        let project: Project
        let summary: String
        let fieldsDescription: String
        let issuetype: Issuetype
        let labels: [String]
        let assignee: Assignee?

        enum CodingKeys: String, CodingKey {
            case project
            case summary
            case fieldsDescription = "description"
            case issuetype
            case labels
            case assignee
        }
    }

    struct Assignee: Codable {
        let id: String?
        let accountId: String?
    }

    // MARK: - Issuetype
    public struct Issuetype: Codable {
        public let name: Kind

        public enum CodingKeys: String, CodingKey {
            case name
        }

        public enum Kind: String, Codable {
            case bug = "Bug"
            case story = "Story"
            case chore = "Chore"
        }
    }

    // MARK: - Project
    struct Project: Codable {
        let key: String

        enum CodingKeys: String, CodingKey {
            case key
        }
    }
}

// { "fields": {"project": {"key": "BLJY" },
//           "summary": "Nick is testing",
//           "description": "Kiosk Bug
// test
// Build
// - device: kiosk 1231
// - build version: 234",
//           "issuetype": { "name":"Bug" } } }
