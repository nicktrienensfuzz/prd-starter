//
//  ChatResponseDTO.swift
//  GPT Client
//
//  Created by Nicholas Trienens on 3/2/23.
//

import Foundation
// MARK: - ChatResponseDTO
public struct ChatResponseDTO: Codable {
    public let id: String
    public let object: String
    public let created: Int
    public let model: String
    public let usage: Usage
    public let choices: [Choice]

    static var empty: ChatResponseDTO = ChatResponseDTO(id: "", object: "", created: 0, model: "", usage: .empty, choices: [])
    enum CodingKeys: String, CodingKey {
        case id
        case object
        case created
        case model
        case usage
        case choices
    }

    public init(id: String, object: String, created: Int, model: String, usage: Usage, choices: [Choice]) {
        self.id = id
        self.object = object
        self.created = created
        self.model = model
        self.usage = usage
        self.choices = choices
    }

    //
    // Hashable or Equatable:
    // The compiler will not be able to synthesize the implementation of Hashable or Equatable
    // for types that require the use of JSONAny, nor will the implementation of Hashable be
    // synthesized for types that have collections (such as arrays or dictionaries).

    // MARK: - Choice
    public struct Choice: Codable {
        public let message: ChatRequestDTO.Message
        public let finishReason: String
        public let index: Int

        enum CodingKeys: String, CodingKey {
            case message
            case finishReason = "finish_reason"
            case index
        }

        public init(message: ChatRequestDTO.Message, finishReason: String, index: Int) {
            self.message = message
            self.finishReason = finishReason
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
        public let completionTokens: Int
        public let totalTokens: Int
        
        static var empty: Usage = Usage(promptTokens: 0, completionTokens: 0, totalTokens: 0 )

        enum CodingKeys: String, CodingKey {
            case promptTokens = "prompt_tokens"
            case completionTokens = "completion_tokens"
            case totalTokens = "total_tokens"
        }

        public init(promptTokens: Int, completionTokens: Int, totalTokens: Int) {
            self.promptTokens = promptTokens
            self.completionTokens = completionTokens
            self.totalTokens = totalTokens
        }
    }
}
