//
//  DocManagerViewModel.swift
//  LameiApp
//
//  Created by Siddharth S on 27/09/24.
//

import Foundation
import SwiftUI
import Combine

class DocSelectorViewModel: ObservableObject {
    private var cancellables   = Set<AnyCancellable>()
    private let networkService = LameiNetworkService()
    
    
    let originalDocString: String
    
    
    init(originalDocString: String) {
        self.originalDocString = originalDocString
    }
    
    // MARK: Methods
    
}
