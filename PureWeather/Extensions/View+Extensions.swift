//
//  View+Extensions.swift
//  PureWeather
//
//  Created by Karen Nikoghosyan on 30/09/2021.
//

import Foundation
import SwiftUI

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
