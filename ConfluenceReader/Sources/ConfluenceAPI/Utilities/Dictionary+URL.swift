//
//  NSDictionary+URL.swift
//  FFIOSTools
//
//  Created by Bill Gestrich on 11/1/17.
//  Copyright © 2017 Bill Gestrich. All rights reserved.
//

import Foundation

// swiftlint:disable force_cast
public extension Dictionary {
    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// - returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped
    func stringFromHttpParameters() -> String {
        let parameterArray = map { key, value -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()
            let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }

        return parameterArray.joined(separator: "&")
    }

    func simpleSQLRepresentation() -> String {
        var rawString = ""
        if count > 0 {
            var index = 0
            for (key, value) in self {
                let isLast = (index == count - 1)

                rawString += " \(key)= \"\(value)\""

                if isLast == false {
                    rawString += " AND "
                }

                index += 1
            }
        }

        return rawString
    }
}

public extension String {
    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    ///
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// - returns: Returns percent-escaped string.

    func addingPercentEncodingForURLQueryValue() -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: generalDelimitersToEncode + subDelimitersToEncode)

        return addingPercentEncoding(withAllowedCharacters: allowed) ?? ""
    }
}
