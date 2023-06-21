//
//  File.swift
//  
//
//  Created by Nicholas Trienens on 6/1/22.
//

import Foundation

public enum ColumnName: String {
    case taskName = "Task Name"
    case duration = "Duration"
    case start = "Start"
    case finish = "Finish"
    case predecessors = "Predecessors"
    case assignedTo = "Assigned To"
    case percentComplete = "% Complete"
    case status = "Status"
    case comments = "Comments"
}


extension Array where Element == SheetDetails.Column {
    public func findId(for columnName: ColumnName) -> Int? {
        first(where: { $0.title == columnName.rawValue})?.id
    }
    public func first(for columnName: ColumnName) -> SheetDetails.Column? {
        first(where: { $0.title == columnName.rawValue})
    }
}
