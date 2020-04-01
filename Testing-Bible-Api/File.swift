//
//  File.swift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 3/31/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//


import SwiftUI
import Combine

final class SelectionStore: ObservableObject {
    var selection: SectionType = .top {
        didSet {
            print("Selection changed to \(selection)")
        }
    }

    // @Published var items = ["Jane Doe", "John Doe", "Bob"]
}
