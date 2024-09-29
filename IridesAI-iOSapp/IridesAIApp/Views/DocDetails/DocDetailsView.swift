//
//  DocDetailsView.swift
//  Lamei
//
//  Created by Siddharth S on 27/09/24.
//
import SwiftUI

struct DocDetailsView: View {
    
    @ObservedObject var docDetailsViewModel: DocDetailsViewModel
    @State var appeared: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Document details at the top
                DocDetailsCellView(docString: docDetailsViewModel.originalDocString)
                    .frame(height: 250)
                    .padding(.horizontal, 20)
                    .shadow(radius: 10, x: 0, y: 5)
                
                Spacer()
                
                // Diversity analysis options
                ForEach(docDetailsViewModel.diversityAnalysis ?? [], id: \.id) { res in
                    DocOptionSelector(originalTextSnipt: res.originalTextSnippet, alternativesArr: res.alternativesOfThis)
                        .padding(.horizontal, 20)
                        .transition(.slide)
                }
                
                Spacer()
            }
        }
        
        .background(
            AnimatedGradient()
                .ignoresSafeArea(.all)
                .opacity(0.15)
        )
        .onAppear {
            if !appeared {
                appeared = true
                docDetailsViewModel.generateMsgFromPrompt(prompt: docDetailsViewModel.originalDocString)
            }
        }
    }
}

// Rounded document detail cell
struct DocDetailsCellView: View {
    let docString: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 15)
            .foregroundStyle(Color.white.opacity(0.3))
            .shadow(color: .gray.opacity(0.5), radius: 10, x: 0, y: 5)
            .overlay {
                VStack(alignment: .leading) {
                    ScrollView {
                        Text(docString)
                            .font(.body)
                            .foregroundStyle(.black)
                            .multilineTextAlignment(.leading)
                            .padding()
                            .lineSpacing(6)
                    }
                }
                .padding()
            }
    }
}

// Option selector with alternatives
struct DocOptionSelector: View {
    let originalTextSnipt: String
    let alternativesArr: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Original snippet
            Text(originalTextSnipt)
                .font(.headline)
                .foregroundStyle(.black)
                .underline()
                .padding(.bottom, 5)
            
            // Alternative options
                ForEach(alternativesArr, id: \.self) { str in
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundStyle(.blue.opacity(0.7))
                        .frame(height: 50)
                        .overlay(
                            Text(str)
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .multilineTextAlignment(.leading)
                        )
                        .padding(.vertical, 4)
                        .shadow(radius: 5, x: 0, y: 2)
                        .onTapGesture {
                            print("Selected: ", str)
                        }
                }
            
            .padding(.vertical)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(Color.white.opacity(0.2))
                .shadow(color: .gray.opacity(0.5), radius: 5, x: 0, y: 3)
        )
    }
}

#Preview {
    DocDetailsView(docDetailsViewModel: .init(originalDocString: "This is a sample text snippet for the document."))
}
