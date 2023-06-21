//
//  SheetDetails.swift
//  
//
//  Created by Nicholas Trienens on 6/1/22.
//

import Foundation
//import Tagged

//public enum _SheetIdTag {}
public typealias SheetId =  Int

public enum SheetDetails {
    // MARK: - SheetResponse
    public struct Sheet: Codable {
        public let id: SheetId
        public let name: String
        public let version: Int
        public let totalRowCount: Int
        public let accessLevel: String
        public let effectiveAttachmentOptions: [String]
        public let ganttEnabled: Bool
        public let dependenciesEnabled: Bool
        public let resourceManagementEnabled: Bool
        public let resourceManagementType: String
        public let cellImageUploadEnabled: Bool
        public let userSettings: UserSettings
        public let projectSettings: ProjectSettings
        public let permalink: String
        public let createdAt: Date
        public let modifiedAt: Date
        public let isMultiPicklistEnabled: Bool
        public let columns: [Column]
        public let rows: [Row]
                
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case version = "version"
            case totalRowCount = "totalRowCount"
            case accessLevel = "accessLevel"
            case effectiveAttachmentOptions = "effectiveAttachmentOptions"
            case ganttEnabled = "ganttEnabled"
            case dependenciesEnabled = "dependenciesEnabled"
            case resourceManagementEnabled = "resourceManagementEnabled"
            case resourceManagementType = "resourceManagementType"
            case cellImageUploadEnabled = "cellImageUploadEnabled"
            case userSettings = "userSettings"
            case projectSettings = "projectSettings"
            case permalink = "permalink"
            case createdAt = "createdAt"
            case modifiedAt = "modifiedAt"
            case isMultiPicklistEnabled = "isMultiPicklistEnabled"
            case columns = "columns"
            case rows = "rows"
        }
        
        public init(id: SheetId, name: String, version: Int, totalRowCount: Int, accessLevel: String, effectiveAttachmentOptions: [String], ganttEnabled: Bool, dependenciesEnabled: Bool, resourceManagementEnabled: Bool, resourceManagementType: String, cellImageUploadEnabled: Bool, userSettings: UserSettings, projectSettings: ProjectSettings, permalink: String, createdAt: Date, modifiedAt: Date, isMultiPicklistEnabled: Bool, columns: [Column], rows: [Row]) {
            self.id = id
            self.name = name
            self.version = version
            self.totalRowCount = totalRowCount
            self.accessLevel = accessLevel
            self.effectiveAttachmentOptions = effectiveAttachmentOptions
            self.ganttEnabled = ganttEnabled
            self.dependenciesEnabled = dependenciesEnabled
            self.resourceManagementEnabled = resourceManagementEnabled
            self.resourceManagementType = resourceManagementType
            self.cellImageUploadEnabled = cellImageUploadEnabled
            self.userSettings = userSettings
            self.projectSettings = projectSettings
            self.permalink = permalink
            self.createdAt = createdAt
            self.modifiedAt = modifiedAt
            self.isMultiPicklistEnabled = isMultiPicklistEnabled
            self.columns = columns
            self.rows = rows
        }
    }
    
    // MARK: - Column
    public struct Column: Codable {
        public let id: Int
        public let version: Int
        public let index: Int
        public let title: String
        public let type: String
        public let primary: Bool?
        public let validation: Bool
        public let width: Int
        public let tags: [String]?
        public let options: [String]?
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case version = "version"
            case index = "index"
            case title = "title"
            case type = "type"
            case primary = "primary"
            case validation = "validation"
            case width = "width"
            case tags = "tags"
            case options = "options"
        }
        
        public init(id: Int, version: Int, index: Int, title: String, type: String, primary: Bool?, validation: Bool, width: Int, tags: [String]?, options: [String]?) {
            self.id = id
            self.version = version
            self.index = index
            self.title = title
            self.type = type
            self.primary = primary
            self.validation = validation
            self.width = width
            self.tags = tags
            self.options = options
        }
    }
    
    // MARK: - ProjectSettings
    public struct ProjectSettings: Codable {
        public let workingDays: [String]
        public let nonWorkingDays: [String]
        public let lengthOfDay: Int
        
        enum CodingKeys: String, CodingKey {
            case workingDays = "workingDays"
            case nonWorkingDays = "nonWorkingDays"
            case lengthOfDay = "lengthOfDay"
        }
        
        public init(workingDays: [String], nonWorkingDays: [String], lengthOfDay: Int) {
            self.workingDays = workingDays
            self.nonWorkingDays = nonWorkingDays
            self.lengthOfDay = lengthOfDay
        }
    }
    
    // MARK: - Row
    public struct Row: Codable {
        public let id: Int
        public let rowNumber: Int
        public let expanded: Bool
        public let createdAt: Date
        public let modifiedAt: Date
        public let cells: [Cell]
        public let parentID: Int?
        public let siblingID: Int?
        public let inCriticalPath: Bool?
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case rowNumber = "rowNumber"
            case expanded = "expanded"
            case createdAt = "createdAt"
            case modifiedAt = "modifiedAt"
            case cells = "cells"
            case parentID = "parentId"
            case siblingID = "siblingId"
            case inCriticalPath = "inCriticalPath"
        }
        
        public init(id: Int, rowNumber: Int, expanded: Bool, createdAt: Date, modifiedAt: Date, cells: [Cell], parentID: Int?, siblingID: Int?, inCriticalPath: Bool?) {
            self.id = id
            self.rowNumber = rowNumber
            self.expanded = expanded
            self.createdAt = createdAt
            self.modifiedAt = modifiedAt
            self.cells = cells
            self.parentID = parentID
            self.siblingID = siblingID
            self.inCriticalPath = inCriticalPath
        }
    }
    
    // MARK: - Cell
    public struct Cell: Codable {
        public let columnID: Int
        public let value: Value?
        public let displayValue: String?
        public let formula: String?
        
        enum CodingKeys: String, CodingKey {
            case columnID = "columnId"
            case value = "value"
            case displayValue = "displayValue"
            case formula = "formula"
        }
        
        public init(columnID: Int, value: Value?, displayValue: String?, formula: String?) {
            self.columnID = columnID
            self.value = value
            self.displayValue = displayValue
            self.formula = formula
        }
    }
    
    public enum Value: Codable, Equatable {
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
    
    // MARK: - UserSettings
    public struct UserSettings: Codable {
        public let criticalPathEnabled: Bool
        public let displaySummaryTasks: Bool
        
        enum CodingKeys: String, CodingKey {
            case criticalPathEnabled = "criticalPathEnabled"
            case displaySummaryTasks = "displaySummaryTasks"
        }
        
        public init(criticalPathEnabled: Bool, displaySummaryTasks: Bool) {
            self.criticalPathEnabled = criticalPathEnabled
            self.displaySummaryTasks = displaySummaryTasks
        }
    }
}
