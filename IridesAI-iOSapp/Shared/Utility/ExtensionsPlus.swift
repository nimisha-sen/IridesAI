//
//  ExtensionsPlus.swift
//  Lamei
//
//  Created by Siddharth S on 07/09/24.
//

import Foundation

#if os(iOS)
import UIKit
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
