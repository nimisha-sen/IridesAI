//
//  Prompt.swift
//  Lamei
//
//  Created by Siddharth S on 07/09/24.
//

import Foundation

struct Prompt {
    
    struct Response: Codable, Hashable {
        /*
         {
           "model": "llama3",
           "created_at": "2023-08-04T19:22:45.499127Z",
           "response": "The sky is blue because it is the color of the sky.",
           "done": true,
           "context": [1, 2, 3],
           "total_duration": 5043500667,
           "load_duration": 5025959,
           "prompt_eval_count": 26,
           "prompt_eval_duration": 325953000,
           "eval_count": 290,
           "eval_duration": 4709213000
         }
         */
        var model: String
        var createdAt: String
        var message: Content
        var done: Bool
    }
    /*
     curl https://ee77-202-173-124-159.ngrok-free.app/api/chat -d '{
       "model": "llama3.2",
       "messages": [
         { "role": "user", "content": "why is the sky blue?" }
       ],"stream": false
     }'
     */
    struct Request: Codable {
        var model: LLMModel
        var messages : [Content]
        var stream: Bool
        
        public init(model: LLMModel, messages: [Content], stream: Bool) {
            self.model = model
            self.messages = messages
            self.stream = stream
        }
    }
    
    struct Content: Codable, Hashable {
        var role: String
        var content: String
    }
}

public enum LLMModel: String, Codable {
    case llama32 = "llama3.2" // 2B
    case llama31 = "llama3.1" // 8B
}
