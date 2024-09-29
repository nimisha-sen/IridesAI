//
//  RootView.swift
//  LameiApp
//
//  Created by Siddharth S on 28/09/24.
//

import SwiftUI


final class Router: ObservableObject {
    
    public enum Destination: Codable, Hashable {
        case documentSelectorView
        case lLMChatView
        case docDetailsView(String)
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}

struct RootView: View {
    
    @ObservedObject var router = Router()
    
    var body: some View {
        TabView {
            NavigationStack(path: $router.navPath) {
                // Initial View
                DocumentSelector()
                    .navigationDestination(for: Router.Destination.self) {
                                switch $0 {
                                case .documentSelectorView:
                                    DocumentSelector()
                                case .lLMChatView:
                                    MainView()
                                case .docDetailsView(let txtStr):
                                    DocDetailsView(docDetailsViewModel: .init(originalDocString: txtStr))
                                    
                                }
                            }
            }
            .tabItem {
                Text("Analyze")
                Image(systemName: "house.fill")
                    .renderingMode(.template)
            }
            .tag(0)
            
            MainView()
                .tabItem {
                                Label("Chat", systemImage: "person.fill")
                            }
                            .tag(1)
            
        }
        
        
        
        .environmentObject(router)
    }
}

