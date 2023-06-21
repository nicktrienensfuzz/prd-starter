//
//  Configuration.swift
//
//
//  Created by Nicholas Trienens on 10/7/21.
//

import Foundation

public protocol JiraConfigurationInterface {
    var email: String { get }
    var token: String { get }
    var projectKey: String { get }
    var baseURL: String { get }
}

struct MockConfiguration: JiraConfigurationInterface {
    let email = ""
    let token = ""
    let projectKey = "red"
    let baseURL: String = "https://monstarlab.atlassian.net/rest/"
}
