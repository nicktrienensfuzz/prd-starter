//
//  Provider.swift
//  JiraView
//
//  Created by Nicholas Trienens on 2/1/22.
//

import DependencyContainer
import Foundation

public extension ContainerKeys {
    static var jiraClientKey = KeyedDependency("jiraClient", type: JiraAPIClient.self)
}

public enum Provider {
    public static func start() {
        DependencyContainer.register(JiraAPIClient(configuration: JiraConfiguration()), key: ContainerKeys.jiraClientKey)
    }
}

public struct JiraConfiguration: JiraClient.JiraConfigurationInterface {
    public init(projectKey: String = "BJKDS") {
        self.projectKey = projectKey
    }

    public let email = ""
    public let token = ""
    public var projectKey = "BJKDS"
    public let baseURL: String = "https://monstarlab.atlassian.net/rest/"
}
