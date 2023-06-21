//
//  IssueReference.swift
//
//
//  Created by Nicholas Trienens on 10/7/21.
//

import Foundation
// MARK: - IssueReference
public struct IssueReference: Codable {
    public let id: String
    public let issueKey: String
    public let issueReferenceSelf: String

    enum CodingKeys: String, CodingKey {
        case id
        case issueKey = "key"
        case issueReferenceSelf = "self"
    }
}
