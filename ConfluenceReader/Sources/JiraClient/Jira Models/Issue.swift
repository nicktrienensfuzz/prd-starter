//
//  Issue.swift
//  JiraSwift
//
//  Created by Bill Gestrich on 10/28/17.
//  Copyright © 2017 Bill Gestrich. All rights reserved.
//

import DependencyContainer
import Foundation
import Networker
import Regex

public struct Issue: Codable, Equatable {
    public init(id: String = "", key: String = "", urlString: String = "", fields: Issue.Fields, expandedMarkdown: String = "") {
        self.id = id
        self.key = key
        self.urlString = urlString
        self.fields = fields
        self.expandedMarkdown = expandedMarkdown
    }

    public var linkUrl: String {
        "https://monstarlab.atlassian.net/browse/\(key)"
    }

    public var id: String = ""
    public var key: String = ""
    public var urlString: String = ""
    public var fields: Fields

    enum CodingKeys: String, CodingKey {
        case id
        case key
        case urlString = "self"
        case fields
    }

    public var expandedMarkdown: String = ""
//
//    public func convert() async -> Issue {
//        print("processing: \(key)")
//
//
//        var builtMd = JiraToMarkdown.convert(fields.description ?? "...")
//        var updated = self
    ////        var parser = MarkdownParser()
    ////        let modifier = Modifier(target: .tables) { html, markdown in
    ////            return html
    ////        }
    ////        parser.addModifier(modifier)
    ////
    ////        var html = parser.html(from: built)
    ////        let htmlStart = """
    ////                <html>\(style)
    ////                    <meta name="viewport" content="width=500, initial-scale=1">
    ////                    <body id="com-atlassian-confluence" class="theme-default dashboard aui-layout aui-theme-default" data-aui-version="6.1.0"><div data-testid="grid-main-container" id="AkMainContent" data-ds--page-layout--slot="main" class="css-1f63klf">
    ////                """
    ////        let htmlEnd = "</div></body></html>"
//        updated.expandedMarkdown = builtMd
//
//        let matches = Regex(#"\[https://monstarlab.atlassian.net/wiki/spaces/(.*?)/(\d+)/(.*?)\]"#).allMatches(in: builtMd)
//
//        for g in matches.reversed() {
//            let url = g.value.dropFirst(1).dropLast(1).asString
//            let pageName: String = g.value
//            if pageName.contains("#") {
//                do {
//                    let snippet = try await DependencyContainer.resolve(key: TypedKeys.confluenceClientKey)
//                        .getContentSnippet(link: url).async()
//                    //print(g.range.lowerBound)
//                    if let range: Range<String.Index> = builtMd.range(of: "[\(url)](\(url))") {
//                        builtMd.insert(contentsOf: "\n\n" + snippet, at: range.upperBound)
//                    }
//                } catch {
//                    print(error)
//                }
//            }
//
//        }
//
    ////        html = parser.html(from: built)
//        updated.expandedMarkdown = builtMd
//        //updated.expandedMarkdown = built
//
//
//
//        //        let url = matches.last?.value.dropFirst(1).dropLast(1).asString
//        ////        print(url)
//        //        if let url = url, let pageName: String = matches.last?.groups.last?.value,
//        //                pageName.contains("#") {
//        //
//        //            do {
//        //            let snippet = try await DependencyContainer.resolve(key: TypedKeys.confluenceClientKey)
//        //                .getContentSnippet(link: url).async()
//        //
//        //                //print(snippet)
//        //                updated.expandedMarkdown = expandedMarkdown + "\n" + snippet
//        //
//        //            } catch {
//        //                print(error)
//        //            }
//        //        }
//
//        return updated
//    }

    public class Fields: Codable, Equatable {
        public static func == (lhs: Issue.Fields, rhs: Issue.Fields) -> Bool {
            lhs.updated == rhs.updated &&
                lhs.description == rhs.description &&
                lhs.summary == rhs.summary
        }

        public let epic: String?
        public var storyPoints: Int?
        public var summary: String
        public var fixVersions: [FixVersion]?
        public let assignee: Assignee?
        public var description: String?
        public let status: IssueStatus
        public let created: Date?
        public let updated: Date?
        public let duedate: Date?
        public var parent: Issue?
        public var colorSwatch: String?

        public let sprint: [Sprint]
        public let priority: Priority
        public let issueType: IssueType
        public let issuelinks: [IssueLink]

        enum CodingKeys: String, CodingKey {
            case epic = "customfield_10017"
            case epic2 = "customfield_10010"
            case summary
            case fixVersions
            case assignee
            case description
            case status
            case priority
            case parent
            case colorSwatch = "customfield_10040"
            case sprint = "customfield_10018"
            case issuelinks
            case issueType = "issuetype"
            case created // "created": "2019-08-28T09:42:49.091-0500",
            case updated
            case duedate
            case storyPoints = "customfield_10023"
            case storyPoints2 = "customfield_10032"
        }

        public required init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            var tempEpic = try? values.decodeIfPresent(String.self, forKey: .epic)
            if tempEpic == nil {
                tempEpic = try values.decodeIfPresent(String.self, forKey: .epic2)
            }
            epic = tempEpic

            summary = try values.decode(String.self, forKey: .summary)
            fixVersions = try? values.decodeIfPresent([FixVersion].self, forKey: .fixVersions)

            assignee = try? values.decodeIfPresent(Assignee.self, forKey: .assignee)

            description = try? values.decodeIfPresent(String.self, forKey: .description)

            status = try values.decode(IssueStatus.self, forKey: .status)
            created = try values.decodeIfPresent(Date.self, forKey: .created)
            updated = try values.decodeIfPresent(Date.self, forKey: .updated)
            duedate = try values.decodeIfPresent(Date.self, forKey: .duedate)
            colorSwatch = try values.decodeIfPresent(String.self, forKey: .colorSwatch)

            var storyPoints = try values.decodeIfPresent(Int.self, forKey: .storyPoints)
            if storyPoints == nil {
                storyPoints = try values.decodeIfPresent(Int.self, forKey: .storyPoints2)
            }
            self.storyPoints = storyPoints
            do {
                sprint = try values.decode([Sprint].self, forKey: .sprint)
            } catch {
                sprint = []
            }
            do {
                parent = try values.decode(Issue.self, forKey: .parent)
            } catch {
                parent = nil
            }

            priority = try values.decode(Priority.self, forKey: .priority)
            issueType = try values.decode(IssueType.self, forKey: .issueType)
            do {
                issuelinks = try values.decode([IssueLink].self, forKey: .issuelinks)
            } catch {
                issuelinks = []
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            if let value = epic {
                try container.encode(value, forKey: .epic)
            }
            if let value = storyPoints {
                try container.encode(value, forKey: .storyPoints)
            }
            try container.encode(summary, forKey: .summary)
            if let value = fixVersions {
                try container.encode(value, forKey: .fixVersions)
            }
            if let value = assignee {
                try container.encode(value, forKey: .assignee)
            }
            if let value = description {
                try container.encode(value, forKey: .description)
            }
            try container.encode(status, forKey: .status)
            if let value = created {
                try container.encode(value, forKey: .created)
            }
            if let value = updated {
                try container.encode(value, forKey: .updated)
            }
            if let value = duedate {
                try container.encode(value, forKey: .duedate)
            }
            if let value = colorSwatch {
                try container.encode(value, forKey: .colorSwatch)
            }
            if let value = parent {
                try container.encode(value, forKey: .parent)
            }
            try container.encode(sprint, forKey: .sprint)
            try container.encode(priority, forKey: .priority)
            try container.encode(issueType, forKey: .issueType)
            try container.encode(issuelinks, forKey: .issuelinks)
        }
    }

    public struct FixVersion: Codable {
        public let description: String?
        public let name: String
        enum CodingKeys: String, CodingKey {
            case description
            case name
        }
    }

    public struct IssueStatus: Codable {
        public let description: String?
        public let name: String
        public let iconUrl: String
    }

    public struct Priority: Codable {
        public let iconUrl: String
        public let id: String
        public let name: String
        public let selfref: String

        public init(
            iconUrl: String,
            id: String,
            name: String,
            selfref: String
        ) {
            self.iconUrl = iconUrl
            self.id = id
            self.name = name
            self.selfref = selfref
        }

        enum CodingKeys: String, CodingKey {
            case iconUrl
            case id
            case name
            case selfref = "self"
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            iconUrl = try values.decode(String.self, forKey: .iconUrl)
            id = try values.decode(String.self, forKey: .id)
            name = try values.decode(String.self, forKey: .name)
            selfref = try values.decode(String.self, forKey: .selfref)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(iconUrl, forKey: .iconUrl)
            try container.encode(id, forKey: .id)
            try container.encode(name, forKey: .name)
            try container.encode(selfref, forKey: .selfref)
        }

        public func toSwift() -> String {
            """
            Priority(
                iconUrl: "\(iconUrl)"
                ,
                id: "\(id)"
                ,
                name: "\(name)"
                ,
                selfref: "\(selfref)"
                )
            """
        }
    }

    public struct IssueType: Codable {
        public let description: String
        public let hierarchyLevel: Double
        public let iconUrl: String
        public let id: String
        public let name: String
        public let selfref: String
        public let subtask: Bool

        public init(
            description: String,
            hierarchyLevel: Double,
            iconUrl: String,
            id: String,
            name: String,
            selfref: String,
            subtask: Bool
        ) {
            self.description = description
            self.hierarchyLevel = hierarchyLevel
            self.iconUrl = iconUrl
            self.id = id
            self.name = name
            self.selfref = selfref
            self.subtask = subtask
        }

        enum CodingKeys: String, CodingKey {
            case description
            case hierarchyLevel
            case iconUrl
            case id
            case name
            case selfref = "self"
            case subtask
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            description = try values.decode(String.self, forKey: .description)
            hierarchyLevel = try values.decode(Double.self, forKey: .hierarchyLevel)
            iconUrl = try values.decode(String.self, forKey: .iconUrl)
            id = try values.decode(String.self, forKey: .id)
            name = try values.decode(String.self, forKey: .name)
            selfref = try values.decode(String.self, forKey: .selfref)
            subtask = try values.decode(Bool.self, forKey: .subtask)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(description, forKey: .description)
            try container.encode(hierarchyLevel, forKey: .hierarchyLevel)
            try container.encode(iconUrl, forKey: .iconUrl)
            try container.encode(id, forKey: .id)
            try container.encode(name, forKey: .name)
            try container.encode(selfref, forKey: .selfref)
            try container.encode(subtask, forKey: .subtask)
        }

        public func toSwift() -> String {
            """
            issuetype(
                description: "\(description)"
                ,
                hierarchyLevel: \(hierarchyLevel),
                iconUrl: "\(iconUrl)"
                ,
                id: "\(id)"
                ,
                name: "\(name)"
                ,
                selfref: "\(selfref)"
                ,
                subtask: \(subtask))
            """
        }
    }

    public struct IssueLink: Codable {
        public let id: String
        public let inwardIssue: InwardIssueObject?
        public let outwardIssue: InwardIssueObject?
        public let selfref: String
        public let type: TypeObject

        public init(
            id: String,
            inwardIssue: InwardIssueObject? = nil,
            outwardIssue: InwardIssueObject? = nil,
            selfref: String,
            type: TypeObject
        ) {
            self.id = id
            self.inwardIssue = inwardIssue
            self.outwardIssue = outwardIssue
            self.selfref = selfref
            self.type = type
        }

        enum CodingKeys: String, CodingKey {
            case id
            case inwardIssue
            case outwardIssue
            case selfref = "self"
            case type
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decode(String.self, forKey: .id)
            inwardIssue = try? values.decodeIfPresent(InwardIssueObject.self, forKey: .inwardIssue)

            outwardIssue = try? values.decodeIfPresent(InwardIssueObject.self, forKey: .outwardIssue)

            selfref = try values.decode(String.self, forKey: .selfref)
            type = try values.decode(TypeObject.self, forKey: .type)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(id, forKey: .id)
            if let value = inwardIssue {
                try container.encode(value, forKey: .inwardIssue)
            }
            if let value = outwardIssue {
                try container.encode(value, forKey: .outwardIssue)
            }
            try container.encode(selfref, forKey: .selfref)
            try container.encode(type, forKey: .type)
        }

        public struct TypeObject: Codable {
            public let id: String
            public let inward: String
            public let name: String
            public let outward: String
            public let selfref: String

            public init(
                id: String,
                inward: String,
                name: String,
                outward: String,
                selfref: String
            ) {
                self.id = id
                self.inward = inward
                self.name = name
                self.outward = outward
                self.selfref = selfref
            }

            enum CodingKeys: String, CodingKey {
                case id
                case inward
                case name
                case outward
                case selfref = "self"
            }

            public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decode(String.self, forKey: .id)
                inward = try values.decode(String.self, forKey: .inward)
                name = try values.decode(String.self, forKey: .name)
                outward = try values.decode(String.self, forKey: .outward)
                selfref = try values.decode(String.self, forKey: .selfref)
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(id, forKey: .id)
                try container.encode(inward, forKey: .inward)
                try container.encode(name, forKey: .name)
                try container.encode(outward, forKey: .outward)
                try container.encode(selfref, forKey: .selfref)
            }
        }

        public struct InwardIssueObject: Codable {
            public let id: String
            public let key: String
            public let selfref: String
            public let fields: Fields?

            public init(
                id: String,
                key: String,
                selfref: String,
                fields: Fields? = nil
            ) {
                self.id = id
                self.key = key
                self.selfref = selfref
                self.fields = fields
            }

            enum CodingKeys: String, CodingKey {
                case id
                case key
                case selfref = "self"
                case fields
            }

            public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                id = try values.decode(String.self, forKey: .id)
                key = try values.decode(String.self, forKey: .key)
                selfref = try values.decode(String.self, forKey: .selfref)
                fields = try? values.decodeIfPresent(Fields.self, forKey: .fields)
            }

            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)

                try container.encode(id, forKey: .id)
                try container.encode(key, forKey: .key)
                try container.encode(selfref, forKey: .selfref)
                if let value = fields {
                    try container.encode(value, forKey: .fields)
                }
            }

            public struct Fields: Codable {
                public let epic: String?
                public var summary: String
                public let assignee: Assignee?
                public var description: String?
                public let status: IssueStatus
                public let priority: Priority
                public let issueType: IssueType

                enum CodingKeys: String, CodingKey {
                    case epic = "customfield_10017"
                    case summary
                    case assignee
                    case description
                    case status
                    case priority
                    case issueType = "issuetype"
                }
            }
        }
    }
}
