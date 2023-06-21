//
//  File 2.swift
//  
//
//  Created by Nicholas Trienens on 6/21/23.
//

import Foundation

// MARK: - FormData
public struct FormData: Codable {
    public let title: String
    public let description: String
    public let acceptanceCriteria: String
    public let menu: String
    public let kiosk: String
    public let kds: String
    public let analytics: String

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "description"
        case acceptanceCriteria = "acceptanceCriteria"
        case menu = "menu"
        case kiosk = "kiosk"
        case kds = "kds"
        case analytics = "analytics"
    }

    public init(title: String, description: String, acceptanceCriteria: String, menu: String, kiosk: String, kds: String, analytics: String) {
        self.title = title
        self.description = description
        self.acceptanceCriteria = acceptanceCriteria
        self.menu = menu
        self.kiosk = kiosk
        self.kds = kds
        self.analytics = analytics
    }
}
