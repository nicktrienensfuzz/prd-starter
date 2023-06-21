//
//  ChatRequest.swift
//  GPT Client
//
//  Created by Nicholas Trienens on 3/2/23.
//

import Foundation

// MARK: - RequestDTO
public class ChatRequestDTO: Codable, Equatable {
    public static func == (lhs: ChatRequestDTO, rhs: ChatRequestDTO) -> Bool {
        lhs.messages == rhs.messages
    }
    
    public let model: String
    public var messages: [Message]
    
    enum CodingKeys: String, CodingKey {
        case model
        case messages
    }
    
    public init(model: String = "gpt-4", messages: [Message] = []) {
        self.model = model
        self.messages = messages
    }
    
    public init(model: String = "gpt-3.5-turbo", message: String) {
        self.model = model
        messages = [.init(content: message)]
    }
    
    func copy() -> ChatRequestDTO {
        ChatRequestDTO(messages: messages)
    }
    
    func addResponseMessage(message: Message) {
        messages.append(message)
    }
    
    func addUserMessage(message: String) {
        messages.append(.init(content: message))
    }
    
    func addErrorMessage(message: String) {
        messages.append(.init(role: "Error", content: message))
    }
    
    //
    // Hashable or Equatable:
    // The compiler will not be able to synthesize the implementation of Hashable or Equatable
    // for types that require the use of JSONAny, nor will the implementation of Hashable be
    // synthesized for types that have collections (such as arrays or dictionaries).
    
    
    // MARK: - Input
    /*
     public struct Message: Codable,  Hashable,  Equatable,  Identifiable {
     public let id: String = UUID().uuidString
     public let role: String = "user"
     public let content: String
     }
     */
    // MARK: - EndInput
    
    public struct Message: Codable, Hashable, Equatable, Identifiable {
        public let id: String
        public let role: String
        public let content: String
        
        public init(
            id: String = UUID().uuidString,
            role: String = "user",
            content: String
        ) {
            self.id = id
            self.role = role
            self.content = content
        }
        
        enum CodingKeys: String, CodingKey {
            case id
            case role
            case content
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = (try? values.decode(String.self, forKey: .id)) ?? UUID().uuidString
            role = (try? values.decode(String.self, forKey: .role)) ?? "user"
            content = try values.decode(String.self, forKey: .content)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            // try container.encode(id, forKey: .id)
            try container.encode(role, forKey: .role)
            try container.encode(content, forKey: .content)
        }
        
        public func toSwift() -> String {
        """
        Message(
            id: "\(id)",
            role: "\(role)",
            content: "\(content)"
            )
        """
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(role)
            hasher.combine(content)
        }
        
        public static func == (lhs: Message, rhs: Message) -> Bool {
            lhs.id == rhs.id &&
            lhs.role == rhs.role &&
            lhs.content == rhs.content
        }
    }
}
