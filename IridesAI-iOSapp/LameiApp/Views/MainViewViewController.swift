//
//  MainViewViewController.swift
//  LameiApp
//
//  Created by Siddharth S on 25/09/24.
//

import Foundation
import UIKit
import SwiftUI

struct MainViewViewControllerX: UIViewControllerRepresentable {
    typealias UIViewControllerType = MainViewController
    
    
    func makeUIViewController(context: Context) -> MainViewController {
        let view = MainViewController(nibName: nil, bundle: nil)
        return view
    }
    
    func updateUIViewController(_ uiViewController: MainViewController, context: Context) {
        
    }
     
}

class MainViewController: UIViewController {
    
    var textField: UITextField!
    var sendButton: UIButton!
    var llamaImageView: UIImageView!
    var statusLabel: UILabel!
    var statusIcon: UIImageView!
    var scrollView: UIScrollView!
    var stackView: UIStackView!
    
    var model = DataViewModel()  // Your ViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
        model.fetchOnlineStatus()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.red
        
        // Llama Image
        llamaImageView = UIImageView(image: UIImage(named: "llama"))
        llamaImageView.contentMode = .scaleAspectFit
        llamaImageView.layer.cornerRadius = 16
        llamaImageView.clipsToBounds = true
        view.addSubview(llamaImageView)
        llamaImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            llamaImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 72),
            llamaImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            llamaImageView.widthAnchor.constraint(equalToConstant: 128),
            llamaImageView.heightAnchor.constraint(equalToConstant: 128)
        ])
        
        // Status HStack
        let statusStackView = UIStackView()
        statusStackView.axis = .horizontal
        statusStackView.alignment = .center
        statusStackView.spacing = 8
        view.addSubview(statusStackView)
        statusStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statusStackView.topAnchor.constraint(equalTo: llamaImageView.bottomAnchor, constant: 16),
            statusStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        statusLabel = UILabel()
        statusLabel.text = "Llama LLM Local"
        statusLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        statusLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        statusStackView.addArrangedSubview(statusLabel)
        
        statusIcon = UIImageView(image: UIImage(systemName: "circle.fill"))
        statusIcon.tintColor = model.isOnline ? .green : .red
        statusStackView.addArrangedSubview(statusIcon)
        
        // TextField and Button
        textField = UITextField()
        textField.placeholder = "Enter Prompt"
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.33)
        textField.layer.cornerRadius = 12
        
        sendButton = UIButton(type: .system)
        sendButton.setImage(UIImage(systemName: "chevron.forward"), for: .normal)
        sendButton.tintColor = .white
        
        let inputStackView = UIStackView(arrangedSubviews: [textField, sendButton])
        inputStackView.axis = .horizontal
        inputStackView.spacing = 16
        view.addSubview(inputStackView)
        inputStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            inputStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            inputStackView.topAnchor.constraint(equalTo: statusStackView.bottomAnchor, constant: 16)
        ])
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 44),
            sendButton.widthAnchor.constraint(equalToConstant: 44),
            sendButton.heightAnchor.constraint(equalTo: textField.heightAnchor)
        ])
        
        // ScrollView for the messages
        scrollView = UIScrollView()
        print(scrollView.contentOffset)
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: inputStackView.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        scrollView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupActions() {
        sendButton.addTarget(self, action: #selector(sendPrompt), for: .touchUpInside)
    }
    
    @objc func sendPrompt() {
        guard let prompt = textField.text, !prompt.isEmpty else { return }
        model.generateMsgFromPrompt(prompt: prompt)
        textField.text = ""
        UIApplication.shared.endEditing()  // Hide the keyboard
    }
    
    func addResponse(_ response: String) {
        let responseLabel = UILabel()
        responseLabel.text = response
        responseLabel.textColor = UIColor.black.withAlphaComponent(0.9)
        
        let copyButton = UIButton(type: .system)
        copyButton.setTitle("Copy", for: .normal)
        copyButton.addTarget(self, action: #selector(copyResponse(_:)), for: .touchUpInside)
        
        let responseStackView = UIStackView(arrangedSubviews: [responseLabel, copyButton])
        responseStackView.axis = .horizontal
        responseStackView.spacing = 8
        
        stackView.addArrangedSubview(responseStackView)
    }
    
    @objc func copyResponse(_ sender: UIButton) {
        // Implement copy to clipboard functionality here
    }
}

extension UIApplication {
    func getTopMostViewController() throws -> UIViewController {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedVC = topController.presentedViewController {
                topController = presentedVC
            }
            
            return topController
        } else {
            throw NSError(domain: "Failed to get top VC", code: -1)
        }
    }
    
    func getRootNavigationController() throws -> UINavigationController? {
        if var topMostVC = try? getTopMostViewController() {
            return topMostVC.navigationController
        } else {
            throw NSError(domain: "Failed to get top VC", code: -1)
        }
    }
}
