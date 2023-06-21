//
//  SmartSheetClient.swift
//  
//
//  Created by Nicholas Trienens on 4/7/23.
//

import Foundation
import Networker
import JSON

public class SmartSheetClient {
    public init( requester: Requester = RequestMaker() , token: String ){
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        self.requester = requester
        self.token = token
    }
    
    let requester: Requester
    let decoder: JSONDecoder
    let encoder: JSONEncoder
    let baseURLString =  "https://api.smartsheet.com/2.0/"
    let token: String
    
    
    public func getSheets() async throws -> [Sheet] {
        
        let target = Endpoint(
            method: .GET,
            path: baseURLString + "sheets",
            headers: ["Authorization": "Bearer \(token)"]
        )
        
        let data = try await requester.makeRequest(target)
        
        do {
            return try decoder.decode(SheetsList.self, from: data).data
        } catch {
            print(error)
            try? print(String(data: data, encoding: .utf8).unwrapped())
            print(target.cURLRepresentation())
            throw error
        }
        
    }
    
    public func getSheet(id: SheetId) async throws -> SheetDetails.Sheet {
        let target = Endpoint(
            method: .GET,
            path: baseURLString + "sheets/\(id)",
            headers: ["Authorization": "Bearer \(token)"]
        )
        
        let data = try await requester.makeRequest(target)
        
        do {
            return try decoder.decode(SheetDetails.Sheet.self, from: data)
        } catch {
            print(error)
            try? print(String(data: data, encoding: .utf8).unwrapped())
            print(target.cURLRepresentation())
            throw error
        }
    }
    
    public func listWorkspaces() async throws -> JSON {
        let target = Endpoint(
            method: .GET,
            path: baseURLString + "workspaces",
            headers: ["Authorization": "Bearer \(token)",
                      "Content-Type": "application/json"]
        )
        
        let data = try await requester.makeRequest(target)
        
        do {
            return try decoder.decode(JSON.self, from: data)
        } catch {
            print(error)
            try? print(String(data: data, encoding: .utf8).unwrapped())
            print(target.cURLRepresentation())
            throw error
        }
    }
    
    public func createSheet(name: String, workSpaceId: String) async throws -> JSON {
        
        let target = try Endpoint(
            method: .POST,
            path: baseURLString + "workspaces/\(workSpaceId)/sheets",
            parameters: [.rawBody(#"{"name":"\#(name)", "fromId":2752885028769668}"#.asData.unwrapped())],
            headers: ["Authorization": "Bearer \(token)",
                      "Content-Type": "application/json"]
        )
        
        let data = try await requester.makeRequest(target)
        do {
            return try decoder.decode(JSON.self, from: data)
        } catch {
            print(error)
            try? print(String(data: data, encoding: .utf8).unwrapped())
            print(target.cURLRepresentation())
            throw error
        }
    }
    
    public func deleteRows(sheetId id: SheetId, rows: [Int] ) async throws {
        
        //    curl 'https://api.smartsheet.com/2.0/sheets/{sheetId}/rows?ids={rowId1},{rowId2},{rowId3}&ignoreRowsNotFound=true' \
        //    -H "Authorization: Bearer ll352u9jujauoqz4gstvsae05" \
        //    -X DELETE
        
        let target = Endpoint(
            method: .DELETE,
            path: baseURLString + "sheets/\(id)/rows",
            parameters: [.parameter(["ids": rows.map({"\($0)"}).joined(separator: ",")], .queryString)],
            headers: ["Authorization": "Bearer \(token)",
                      "Content-Type": "application/json"]
        )
        
        let _ = try await requester.makeRequest(target)
    }
    
    public func putRows(sheetId id: SheetId, rows: [AddRow.AddRowElement] ) async throws -> AddRow.Response {
        
        let target = Endpoint(
            method: .POST,
            path: baseURLString + "sheets/\(id)/rows",
            parameters: [.encodableWithCoder(.init(rows), .body, encoder)],
            headers: ["Authorization": "Bearer \(token)",
                      "Content-Type": "application/json"]
        )
        
        let data = try await requester.makeRequest(target)
        
        do {
            return try decoder.decode(AddRow.Response.self, from: data)
        } catch {
            print(error)
            try? print(String(data: data, encoding: .utf8).unwrapped())
            print(target.cURLRepresentation())
            throw error
        }
    }
    
    public func updateRows(sheetId id: SheetId, rows: [AddRow.AddRowElement] ) async throws -> AddRow.Response {
        let target = Endpoint(
            method: .PUT,
            path: baseURLString + "sheets/\(id)/rows",
            parameters: [.encodable(.init(rows), .body)],
            headers: ["Authorization": "Bearer \(token)",
                      "Content-Type": "application/json"]
        )
        
        let data = try await requester.makeRequest(target)
        
        do {
            return try decoder.decode(AddRow.Response.self, from: data)
        } catch {
            print(error)
            try? print(String(data: data, encoding: .utf8).unwrapped())
            throw error
        }
    }
}


internal extension String {
    var asData: Data? {
        data(using: .utf8)
    }
}
