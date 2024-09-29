//
//  DocDetailsViewModel.swift
//  Lamei
//
//  Created by Siddharth S on 27/09/24.
//

import Foundation
import SwiftUI
import Combine
import llmfarm_core
import Toaster
typealias DiversityTextList = [DiversityText]


class DocDetailsViewModel: ObservableObject {
    private var cancellables   = Set<AnyCancellable>()
    private let networkService = LameiNetworkService()
    
    
   public var originalDocString: String
    
    
    @Published var diversityAnalysis: DiversityTextList? = nil
    
    //Variables
    var isLoading: Bool = false
    
    init(originalDocString: String) {
        self.originalDocString = originalDocString
    }
    
    // MARK: Methods
    
    
    
    
    // LLM Server Methods
    public func generateMsgFromPrompt(prompt: String) -> Void {
        
        /// Function to extract JSON and parse LLM's response into Swift models
        func parseLLMResponse(llmResponse: String) -> DiversityTextList? {
            // Remove backticks and any non-JSON text before the JSON array
            let cleanedResponse = llmResponse
                .replacingOccurrences(of: "```", with: "")  // Remove backticks
                .components(separatedBy: "```").last ?? ""  // Get the last component (the JSON part)
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            // Ensure the cleaned string is valid JSON data
            guard let jsonData = cleanedResponse.data(using: .utf8) else {
                print("Failed to convert JSON part to Data")
                return nil
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(DiversityTextList.self, from: jsonData)
                return response
            } catch {
                print("Failed to decode JSON: \(error)")
                return nil
            }
        }


        
        
        let jsonEx = """
            [
                {
                    "id": 1,
                    "originalTextSnippet": "In this story, Aladdin encounters an African magician.",
                    "alternativesOfThis": [
                        "In the tale, Aladdin meets a powerful magician from Africa.",
                        "An African magician plays a key role in Aladdin's story."
                    ]
                },
                {
                    "id": 2,
                    "originalTextSnippet": "Aladdin was a poor boy.",
                    "alternativesOfThis": [
                        "Aladdin came from a humble background.",
                        "The story describes Aladdin's impoverished life."
                    ]
                }
            ]
"""
        
        let systemContent = Prompt.Content.init(role: "system", content: "Analyze the following text for mentions of diversity and give alternatives considering diversity. and give response in JSON only with structure also do not add any text before json give raw: " + jsonEx)
        
        let systemContent2 = Prompt.Content.init(role: "system", content: "Do not use \\n")
        let userContent = Prompt.Content.init(role: "user", content: "text: " + prompt)
        
        let request = Prompt.Request(model: .llama31, messages: [systemContent,systemContent2,userContent], stream: false)
        withAnimation {
            isLoading = true
        }
        networkService.getMessageResponse(request: request)
            .receive(on: DispatchQueue.main)
            .sink { status in
                switch status {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                    withAnimation {
                        self.isLoading = false
                    }
                }
            } receiveValue: { [weak self] fetchedMsg in
                print(fetchedMsg)
                
                withAnimation {
                    self?.isLoading = false
                }
                self?.diversityAnalysis = parseLLMResponse(llmResponse: fetchedMsg.message.content)
                
                
            }
            .store(in: &cancellables)
    }
    
}



//class LLMHelper {
//    // MARK: llmfarm
//    let maxOutputLength = 100
//    var total_output = 0
//
//    func mainCallback(_ str: String, _ time: Double) -> Bool {
//        print("\(str)",terminator: "")
//        total_output += str.count
//        if(total_output>maxOutputLength){
//            return true
//        }
//        return false
//    }
//
//    init(total_output: Int = 0, input_text: String = "State the meaning of life") {
//        self.total_output = total_output
////        self.input_text = input_text
//    }
//    
//    
//    func loadModel() {
//        //load model
//        
//        guard let modelPath = Bundle.main.path(forResource: "model", ofType: "gguf") else {
//            print("File not found")
//            return
//        }
//        
//        let ai = AI(_modelPath: modelPath,_chatName: "chat")
//        var params:ModelAndContextParams = .default
//        
//        
//        //set custom prompt format
//        params.promptFormat = .Custom
//        
//        params.custom_prompt_format = """
//        SYSTEM: You are a helpful, respectful and honest assistant.
//        USER: {prompt}
//        ASSISTANT:
//        """
//        let input_text = "State the meaning of life"
//
//        params.use_metal = true
//
//        //Uncomment this line to add lora adapter
//        //params.lora_adapters.append(("lora-open-llama-3b-v2-q8_0-shakespeare-LATEST.bin",1.0 ))
//
//        //_ = try? ai.loadModel_sync(ModelInference.LLama_gguf,contextParams: params)
//        
//        try! _ = ai.loadModel(.LLama_bin, contextParams: params)
//
//        if ai.model == nil{
//            print( "Model load eror.")
//            exit(2)
//        }
//        // to use other inference like RWKV set ModelInference.RWKV
//        // to use old ggjt_v3 llama models use ModelInference.LLama_bin
//
//        // Set mirostat_v2 sampling method
//        ai.model?.sampleParams.mirostat = 2
//        ai.model?.sampleParams.mirostat_eta = 0.1
//        ai.model?.sampleParams.mirostat_tau = 5.0
//
////        try ai.loadModel_sync()
//        //eval with callback
//        let output = try? ai.model?.predict(input_text, mainCallback)
//        let toast = Toast(text: output)
//        toast.show()
//        
//        
//    }
//    
//
//    
//}
struct DiversityText: Codable {
    let id: Int
    let originalTextSnippet: String
    let alternativesOfThis: [String]
}
