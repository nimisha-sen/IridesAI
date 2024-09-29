//
//  ContentView.swift
//  Lamei
//
//  Created by Siddharth S on 07/09/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var text: String = ""
    let a = CGRect(x: 1, y: 1, width: 10, height: 10)
    @ObservedObject var model = DataViewModel()
    
    @State var isSettingsPresented: Bool = false
    
    var body: some View {
        VStack {
            Image("llama")
                .resizable()
                .frame(width: 128, height: 128)
                .cornerRadius(16)
                .padding(.top, 64 + 8)
            
            HStack {
                Text("Lamma LLM Local")
                    .font(.headline)
                Image(systemName: "circle.fill")
                    .foregroundStyle(model.isOnline ? .green : .red)
            }
            
            
            Spacer()
            
            HStack {
                TextField(" Enter Prompt", text: $text)
                    .cornerRadius(8)
                Button(action: {
                    model.generateMsgFromPrompt(prompt: text)
                    
                    
                }, label: {
                    Text("Send")
                })
            }
            
            
            VStack {
                List {
                    ForEach(model.promptResponses, id: \.self) { response in
                        HStack {
                            Text(response.message.content)
                            Button("Copy") {
                                
//                                copyToClipBoard(textToCopy: response.message.content)
                                        
                            }
                        }
                        
                        Divider()
                            .padding()
                        
                    }
                    
                    
                                    }
                .frame(height: 400)
                .overlay {
                    if model.promptResponses.isEmpty {
                        Text("No Response")
                    }
                }
            }
        }
        .onAppear(perform: {
            model.fetchOnlineStatus()
        })
    }
}

#Preview {
    ContentView()
}


#if os(macOS)
func copyToClipBoard(textToCopy: String) {
    let pasteBoard = NSPasteboard.general
    pasteBoard.clearContents()
    pasteBoard.setString(textToCopy, forType: .string)

}
#endif


