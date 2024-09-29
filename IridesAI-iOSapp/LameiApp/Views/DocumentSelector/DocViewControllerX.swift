//
//  DocViewControllerX.swift
//  LameiApp
//
//  Created by Siddharth S on 27/09/24.
//

import Foundation
import SwiftUI
import UIKit

struct DocViewControllerX: UIViewControllerRepresentable {
    // Completion handler to return picked document content
    var onDocumentPicked: (String) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        context.coordinator.docVc.modalPresentationStyle = .fullScreen
        return context.coordinator.docVc
    }
    
    func makeCoordinator() -> DocCoordinator {
        return DocCoordinator(onDocumentPicked: onDocumentPicked)
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
        // Not needed in this case
    }
    
    typealias UIViewControllerType = UIDocumentPickerViewController
}

class DocCoordinator: NSObject, UIDocumentPickerDelegate {
    var onDocumentPicked: (String) -> Void
    
    init(onDocumentPicked: @escaping (String) -> Void) {
        self.onDocumentPicked = onDocumentPicked
    }
    
    lazy var docVc: UIDocumentPickerViewController = {
        let vc = UIDocumentPickerViewController(forOpeningContentTypes: [.text], asCopy: true)
        vc.delegate = self
        return vc
    }()
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        
        do {
            // Read the content of the file at the picked URL
            let textContent = try String(contentsOf: url, encoding: .utf8)
            // Call the completion handler with the picked document content
            onDocumentPicked(textContent)
        } catch {
            print("Failed to read the file: \(error)")
        }
    }
}
