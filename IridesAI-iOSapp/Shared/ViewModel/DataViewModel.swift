//
//  DataViewModel.swift
//  Lamei
//
//  Created by Siddharth S on 07/09/24.
//

import Foundation
import Combine
import SwiftUI

class DataViewModel: ObservableObject {
    @Published var promptResponses = [Prompt.Response]()
    @Published var isOnline: Bool  = false
    
    @Published var isLoading: Bool = false
    
    private var cancellables   = Set<AnyCancellable>()
    private let networkService = LameiNetworkService()

    
    func fetchOnlineStatus() {
        networkService.getStatus()
            .receive(on: DispatchQueue.main)
            .mapError({ error -> Error in
                print(error)
                self.isOnline = false
                return error
            })
            .sink { [weak self] status in
                switch status {
                case .finished:
                    
                    break
                case .failure(let error):
                    print(error)
                    self?.isOnline = false
                }
            } receiveValue: { [weak self] fetchedStatus in
                print(fetchedStatus)
                if fetchedStatus == "Ollama is running" {
                    self?.isOnline = true
                }
                
            }
            .store(in: &cancellables)

    }
    
    func generateMsgFromPrompt(prompt: String) {
        let request = Prompt.Request(model: .llama31, messages: [.init(role: "User", content: prompt)], stream: false)
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
                }
            } receiveValue: { [weak self] fetchedMsg in
                print(fetchedMsg)
                self?.promptResponses.append(fetchedMsg)
                withAnimation {
                    self?.isLoading = false
                }
            }
            .store(in: &cancellables)

    }
}


