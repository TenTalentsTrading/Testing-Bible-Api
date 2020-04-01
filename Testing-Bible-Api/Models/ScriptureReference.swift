//
//  ScriptureReference.swift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 3/31/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//

import Foundation

class ScriptureReference: ObservableObject {
    @Published var bookId = "GEN"
    @Published var selectedBook = 0

    @Published var chapters = [Int]()
    @Published var apiChapters = [ChapterRecord]()
    @Published var selectedChapter = 1
    
    @Published var verses = [Int]()
    @Published var apiVerses = [VerseRecord]()
    @Published var selectedStartVerse = 1
    @Published var selectedEndVerse = 1
    
    @Published var passages = [String]()
    
    let apiBooks = WebService().loadBooksApi()
}
