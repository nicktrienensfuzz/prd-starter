//
//  IssueResponse.swift
//  JiraSwift
//
//  Created by Bill Gestrich on 10/28/17.
//  Copyright © 2017 Bill Gestrich. All rights reserved.
//

import Foundation

public struct IssueResponse: Codable {
    public var maxResults: Int = 0
    public var startAt: Int = 0
    public var total: Int = 0
    public var issues: [Issue]

    var hasMore: Bool {
        if total > startAt + maxResults {
            return true
        }
        return false
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

    func append(_ issues: [Issue]) -> IssueResponse {
        IssueResponse(maxResults: maxResults, startAt: startAt, total: total, issues: issues + self.issues)
    }
}
