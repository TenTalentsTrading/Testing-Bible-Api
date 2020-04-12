//
//  PassageViewModel.swift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 4/6/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//

import Foundation
import SwiftUI

class PassageViewModel: ObservableObject {

@Published var books = BibleBookList().getBooks()
@Published var apiBooks = [BookRecord]()
@Published var bookId = "GEN"
@Published var selectedBook = 0

}
