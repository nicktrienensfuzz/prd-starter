//
//  File.swift
//
//
//  Created by Nicholas Trienens on 2/1/22.
//

import Foundation

public struct Resolution: Codable {
    public let resolutionSelf: String
    public let id: String
    public let resolutionDescription: String
    public let name: String

    enum CodingKeys: String, CodingKey {
        case resolutionSelf = "self"
        case id
        case resolutionDescription = "description"
        case name
    }

    public init(resolutionSelf: String, id: String, resolutionDescription: String, name: String) {
        self.resolutionSelf = resolutionSelf
        self.id = id
        self.resolutionDescription = resolutionDescription
        self.name = name
    }
}
