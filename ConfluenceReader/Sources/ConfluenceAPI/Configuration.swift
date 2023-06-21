//
//  Configuration.swift
//
//
//  Created by Nicholas Trienens on 10/7/21.
//

import Foundation

/// Protocol that defines the structure for configuration details, such as email address, authentication token, baseURL, and project key.
public protocol ConfigurationInterface {
    var token: String { get }
    var baseURL: String { get }
}

/// A struct conforming to ConfigurationInterface, used for mocking purposes. Predefined values are
/// set for the email, token, projectKey, and baseURL properties.
struct MockConfiguration: ConfigurationInterface {   
    let token = ""
    let baseURL = "https://monstarlab.atlassian.net/wiki/rest/api/"
}
