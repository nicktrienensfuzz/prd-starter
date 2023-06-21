//
//  EmbeddingsBody.swift
//  
//
//  Created by Nicholas Trienens on 5/8/23.
//

import Foundation
public struct EmbeddingsBody: Codable, Equatable {
    public let input: String
    public let model: String

    enum CodingKeys: String, CodingKey {
        case input
        case model
    }

    public init(input: String, model: String = "text-embedding-ada-002") {
        self.input = input
        self.model = model
    }
}


// MARK: - EmbeddingsResponse
public struct EmbeddingsResponse: Codable, Equatable {
    public let object: String
    public let data: [Datum]
    public let model: String
    public let usage: Usage
    
    enum CodingKeys: String, CodingKey {
        case object
        case data
        case model
        case usage
    }
    
    public init(object: String, data: [Datum], model: String, usage: Usage) {
        self.object = object
        self.data = data
        self.model = model
        self.usage = usage
    }
    
    
    //
    // Hashable or Equatable:
    // The compiler will not be able to synthesize the implementation of Hashable or Equatable
    // for types that require the use of JSONAny, nor will the implementation of Hashable be
    // synthesized for types that have collections (such as arrays or dictionaries).
    
    // MARK: - Datum
    public struct Datum: Codable, Equatable {
        public let object: String
        public let embedding: [Double]
        public let index: Int
        
        enum CodingKeys: String, CodingKey {
            case object
            case embedding
            case index
        }
        
        public init(object: String, embedding: [Double], index: Int) {
            self.object = object
            self.embedding = embedding
            self.index = index
        }
    }
    
    //
    // Hashable or Equatable:
    // The compiler will not be able to synthesize the implementation of Hashable or Equatable
    // for types that require the use of JSONAny, nor will the implementation of Hashable be
    // synthesized for types that have collections (such as arrays or dictionaries).
    
    // MARK: - Usage
    public struct Usage: Codable, Equatable {
        public let promptTokens: Int
        public let totalTokens: Int
        
        enum CodingKeys: String, CodingKey {
              case promptTokens = "prompt_tokens"
              case totalTokens = "total_tokens"
          }
        
        public init(promptTokens: Int, totalTokens: Int) {
            self.promptTokens = promptTokens
            self.totalTokens = totalTokens
        }
    }
}
