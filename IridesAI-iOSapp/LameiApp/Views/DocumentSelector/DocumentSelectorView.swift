//
//  DocumentSelector.swift
//  LameiApp
//
//  Created by Siddharth S on 27/09/24.
//

import SwiftUI
import Combine

struct DocumentSelector: View {
    @StateObject var docDetailsViewModel = DocDetailsViewModel(originalDocString: "nil")
    
    // Capture the passed router
    @EnvironmentObject var router: Router
    
    @State var presentDocSelectorVC: Bool = false
    
    var body: some View {
            VStack {
//                HStack {
//                    Spacer()
//                    Button {
//                        router.navigate(to: .lLMChatView)
//                    } label: {
//                        Image(systemName: "bubble")
//                            .foregroundStyle(.black)
//                            
//                    }
//                    .padding(.horizontal,20)
//                    .padding(.vertical, 20)
//                }
                
                    
                Spacer()

                SelectCellView(onTapAction: {
                    selectorTapped()
                })
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.26)
                Spacer()
            }
            .popover(isPresented: $presentDocSelectorVC) {
                DocViewControllerX { txtStr in
                    print(txtStr)
                    docDetailsViewModel.originalDocString = txtStr
                    presentDocSelectorVC = false  // Dismiss the popover after selection
                    
                    router.navigate(to: .docDetailsView(txtStr))
                }
                                    
            }
            .navigationTitle("Select your input")
        
    }
    
    // MARK: Actions
    private func selectorTapped() -> Void {
        presentDocSelectorVC = true
        //router.navigate(to: .docDetailsView)
    }
    
}

struct SelectCellView: View {
    let onTapAction: (()->())?
    
    var body: some View {
        VStack {
            AnimatedGradient()
                .background(Color.blue.opacity(0.2))
                .clipShape(Circle())
                .overlay {
                    HStack {
                        Spacer()
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundStyle(Color.white)
                        Spacer()
                    }
                }
                
                
                .onTapGesture {
                    onTapAction?()
                }
        }
        
    }
}

#Preview {
    DocumentSelector()
}
