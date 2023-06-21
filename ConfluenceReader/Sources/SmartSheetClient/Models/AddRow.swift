//
//  File.swift
//  
//
//  Created by Nicholas Trienens on 6/1/22.
//

import Foundation
import Networker

public  enum AddRow {
    // MARK: - AddRowElement
    public struct AddRowElement: Encodable {
        public let id: Int?
        public let toTop: Bool
        public let toBottom: Bool
        public let parentId: Int?
        public var cells: [AnyEncodable]
        
        enum CodingKeys: String, CodingKey {
            case id
            case toTop = "toTop"
            case toBottom = "toBottom"
            case parentId = "parentId"
            case cells = "cells"
        }
        
        public init(id: Int? = nil, toTop: Bool = false, toBottom: Bool = true, parentId: Int? = nil, cells: [AnyEncodable]) {
            self.id = id
            self.toTop = toTop
            self.toBottom = toBottom
            self.cells = cells
            self.parentId = parentId
        }
    }
    
    // MARK: - Cell
    public struct CellObject<T: Encodable>: Encodable {
        public let columnID: Int
        public let objectValue: T
        public let strict: Bool?
        
        enum CodingKeys: String, CodingKey {
            case columnID = "columnId"
            case objectValue = "objectValue"
            case strict = "strict"
        }
        
        public init(columnID: Int, objectValue: T, strict: Bool?) {
            self.columnID = columnID
            self.objectValue = objectValue
            self.strict = strict
        }
        public var asAnyEncodable: AnyEncodable {
            AnyEncodable(self)
        }
    }
    
    
    // MARK: - Cell
    public struct Cell: Encodable {
        public let columnID: Int
        public let value: Value
        public let strict: Bool?
        
        enum CodingKeys: String, CodingKey {
            case columnID = "columnId"
            case value = "value"
            case strict = "strict"
        }
        
        public init(columnID: Int, value: Value, strict: Bool? = true) {
            self.columnID = columnID
            self.value = value
            self.strict = strict
        }
        public var asAnyEncodable: AnyEncodable {
            AnyEncodable(self)
        }
    }
    
    public enum Value: Codable {
        case bool(Bool)
        case string(String)
        case date(Date)
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if let x = try? container.decode(Bool.self) {
                self = .bool(x)
                return
            }
            if let x = try? container.decode(String.self) {
                self = .string(x)
                return
            }
            if let x = try? container.decode(Date.self) {
                self = .date(x)
                return
            }
            throw DecodingError.typeMismatch(Value.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Value"))
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .bool(let x):
                try container.encode(x)
            case .string(let x):
                try container.encode(x)
            case .date(let x):
                try container.encode(x)
            }
        }
    }
    
    // MARK: - AddRowResult
    public struct Response: Codable {
        public let message: String
        public let resultCode: Int
        public let result: [Result]
        public let version: Int
        
        enum CodingKeys: String, CodingKey {
            case message = "message"
            case resultCode = "resultCode"
            case result = "result"
            case version = "version"
        }
        
        public init(message: String, resultCode: Int, result: [Result], version: Int) {
            self.message = message
            self.resultCode = resultCode
            self.result = result
            self.version = version
        }
    }
    
    // MARK: - Result
    public struct Result: Codable {
        public let id: Int
        public let sheetID: Int?
        public let rowNumber: Int
        public let expanded: Bool
        public let createdAt: Date
        public let modifiedAt: Date
        public let cells: [SheetDetails.Cell]
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case sheetID = "sheetId"
            case rowNumber = "rowNumber"
            case expanded = "expanded"
            case createdAt = "createdAt"
            case modifiedAt = "modifiedAt"
            case cells = "cells"
        }
        
        public init(id: Int, sheetID: Int?, rowNumber: Int, expanded: Bool, createdAt: Date, modifiedAt: Date, cells: [SheetDetails.Cell]) {
            self.id = id
            self.sheetID = sheetID
            self.rowNumber = rowNumber
            self.expanded = expanded
            self.createdAt = createdAt
            self.modifiedAt = modifiedAt
            self.cells = cells
        }
    }
    
    
    
    // MARK: - PredecessorListObjectValue
    public struct PredecessorListObjectValue: Codable {
        public let objectType: String
        public let predecessors: [Predecessor]

        enum CodingKeys: String, CodingKey {
            case objectType = "objectType"
            case predecessors = "predecessors"
        }

        public init(objectType: String = "PREDECESSOR_LIST", predecessors: [Predecessor]) {
            self.objectType = objectType
            self.predecessors = predecessors
        }
    }

    // MARK: - Predecessor
    public struct Predecessor: Codable {
        public let rowID: Int
        public let type: String
        public let lag: Lag

        enum CodingKeys: String, CodingKey {
            case rowID = "rowId"
            case type = "type"
            case lag = "lag"
        }

        public init(rowID: Int, type: String, lag: Lag) {
            self.rowID = rowID
            self.type = type
            self.lag = lag
        }
    }

    // MARK: - Lag
    public struct Lag: Codable {
        public let objectType: String
        public let days: Int
        public let hours: Double
        public let negative: Bool

        enum CodingKeys: String, CodingKey {
            case objectType = "objectType"
            case days = "days"
            case hours = "hours"
            case negative
        }

        public init(objectType: String  = "DURATION", days: Int, hours: Double, negative: Bool = false) {
            self.objectType = objectType
            self.days = days
            self.hours = hours
            self.negative = negative
        }
    }

}
