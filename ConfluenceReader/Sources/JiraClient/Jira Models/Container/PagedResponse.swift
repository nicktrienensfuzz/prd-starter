//
//  File.swift
//
//
//  Created by Nicholas Trienens on 6/17/22.
//

import Foundation

// MARK: - PagedResponse
public struct PagedResponse<T: Codable>: Codable {
    public let maxResults: Int
    public let startAt: Int
    public let total: Int?
    public let isLast: Bool?
    public var values: [T]

    enum CodingKeys: String, CodingKey {
        case maxResults
        case startAt
        case total
        case isLast
        case values
    }

    public init(maxResults: Int, startAt: Int, total: Int?, isLast: Bool?, values: [T]) {
        self.maxResults = maxResults
        self.startAt = startAt
        self.total = total
        self.isLast = isLast
        self.values = values
    }

    var hasMore: Bool {
        if let isLast = isLast {
            return !isLast
        }
        if let total = total, total > startAt + maxResults {
            return true
        }
        return false
    }

    func nextIndex() -> Int {
        let lastIndexFetched = startAt + (maxResults - 1)
        // let lastIndexAvailable = (total ?? 0) - 1
        // if lastIndexFetched < lastIndexAvailable {
        return lastIndexFetched + 1
        // }
    }

    func append(_ values: [T]) -> PagedResponse {
        PagedResponse(
            maxResults: maxResults,
            startAt: startAt,
            total: total,
            isLast: isLast,
            values: values + self.values
        )
    }
}
