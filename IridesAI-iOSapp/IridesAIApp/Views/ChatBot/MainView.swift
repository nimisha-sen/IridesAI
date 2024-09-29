//
//  ContentView.swift
//  LameiApp
//
//  Created by Siddharth S on 07/09/24.
//

import SwiftUI

struct MainView: View {
    @State var text: String = ""
    
    @ObservedObject var model = DataViewModel()
    
    var body: some View {
        VStack {
            Image("llama")
                .resizable()
                .frame(width: 128, height: 128)
                .cornerRadius(16)
                .padding(.top, 64 + 8)
            
//            Button("ViewController") {
//                
//                let navigationController = try! UIApplication.shared.getRootNavigationController()
//                // This presents on top
//                //vc.present(MainViewController(nibName: nil, bundle: nil), animated: true)
//                navigationController?.pushViewController(MainViewController(nibName: nil, bundle: nil), animated: true)
//            }
            
            HStack {
                Text("Chat")
                    .font(.headline)
                    .foregroundStyle(.white.opacity(0.9))
                Image(systemName: "circle.fill")
                    .foregroundStyle(model.isOnline ? .green : .red)
            }
            
            
            Spacer()
            
            HStack(spacing: 16) {
                TextField(" Enter Prompt", text: $text) {
                    UIApplication.shared.endEditing()
                    
                    model.generateMsgFromPrompt(prompt: text)
                    self.text = ""
                }
                    .cornerRadius(8)
                    .padding(.vertical, 8)
                    .background(Color.white.opacity(0.33).cornerRadius(12))
                Button(action: {
                    UIApplication.shared.endEditing()
                    model.generateMsgFromPrompt(prompt: text)
                    self.text = ""
                    
                }, label: {
                    Image(systemName: "chevron.forward")
                        .resizable()
                        .foregroundStyle(.white)
                        .frame(width: 16,height: 32)
                })
            }
            .padding(.horizontal,20)
            
            
            
                ScrollView {
                    ForEach(model.promptResponses, id: \.self) { response in
                        HStack {
                            Text(response.message.content)
                                .foregroundStyle(.black.opacity(0.9))
                            Button("Copy") {
                                //                                copyToClipBoard(textToCopy: response.message.content)
                                
                            }
                        }
                        .padding()
                        
                        Divider()
                            .padding()
                        
                    }
                    if model.promptResponses.isEmpty {
                        Text("No Response")
                            .frame(maxWidth: .infinity)
                            .padding(.top, 128)
                    }
                }
                .background(Color.white.opacity(0.55))
                .cornerRadius(16)
                .edgesIgnoringSafeArea(.bottom)
                
            
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                model.fetchOnlineStatus()
            }
            
        })
        .background(
            AnimatedGradient()
                .ignoresSafeArea(.all)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
        )
        .overlay {
            if model.isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color.black.opacity(0.33))
                .ignoresSafeArea(.all)
            } else {
                EmptyView()
            }
        }
    }
}


