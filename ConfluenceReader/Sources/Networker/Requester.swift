//
//  Requester.swift
//
//
//  Created by Nicholas Trienens on 11/24/22.
//

import Foundation
import Atomics

public protocol Requester {
    func makeRequest(_ endpoint: EndpointRequest) async throws -> Data
}
