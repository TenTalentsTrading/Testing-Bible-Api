//
//  Scriptureswift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 3/31/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//

import Foundation
import SwiftUI


class ScriptureReference: ObservableObject {
    
    @Published var books = BibleBookList().getBooks()
    @Published var apiBooks = [BookRecord]()
    @Published var bookId = "GEN"
    @Published var selectedBook = 0 {
    didSet {
            if (apiBooks.count > 0) {
                let record: BookRecord = apiBooks.filter{$0.name == books[selectedBook]}.first!
                bookId = record.id
            }
            else {
                print("Could not change book id...")
            }
            
            getChapterApi()
        }
    }
    
    
    //Chapter Variables
    @Published var chapters = [Int]()
    @Published var apiChapters = [ChapterRecord]()
    @Published var selectedChapter = 1 {
    didSet {
        getVersesApi()
        }
    }
    
    
    //Verse Variables
    @Published var verses = [Int]()
    @Published var apiVerses = [VerseRecord]()
    @Published var selectedStartVerse = Int() {
    didSet {
        remainingVerses = Array(selectedStartVerse...verses.count)
        }
    }
    @Published var selectedEndVerse = Int()
    @Published var remainingVerses = [Int]()
    
    
    //Main Passage Variables
    @Published var assembledReference = String()
    @Published var passage = String()
    @Published var firstLetterPassage = String()
    @Published var firstWordPassage = String ()
    
    
    //Variables for Dropping First letter
    @Published var isFirstLetterDroppedColor: Color = Color.blue
    @Published var isOnlyFirstLetterShown = false {
        didSet {
            if isOnlyFirstLetterShown == true {
                areWordsDropped = false
                isFirstLetterDroppedColor = Color.red
            }
            else{
                isFirstLetterDroppedColor = Color.blue
            }
        }
    }
    
    //Variables for Dropping All But First Word
    @Published var areWordsDroppedColor: Color = Color.blue
    @Published var areWordsDropped = false {
        didSet {
            if areWordsDropped == true {
                isOnlyFirstLetterShown = false
                areWordsDroppedColor = Color.red
            }
            else{
                areWordsDroppedColor = Color.blue
            }
        }
    }
    
    //Variables for dictation
    @Published var spokenPortionOfPassage = String()
    @Published var unspokenPortionOfPassage = String()
    
        
    //Running these functions upon initialization to prepare the object
    init() {
        getChapterApi()
        getVersesApi()
        loadBooksApi()
        assembleRef()
        loadPassages()
    }
    
    
    //object functions to get stuff done!
    
    func setAlternatePassages(){
        firstLetterPassage = PassageParsing().DropAllButFirstLetters(text: passage)
        firstWordPassage = PassageParsing().DropAllButFirstWord(text: passage)
    }
    
    func loadPassages() {
        guard let url = URL(string: "https://api.esv.org/v3/passage/text/?q=\(assembledReference)&include-passage-references=false&include-headings=false") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.setValue("Token a2e16e4aa6e439cc1478cdbf057411d633375cf5", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.passage = decodedResponse.passages[0]
                        self.setAlternatePassages()
                    }

                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")        }.resume()
    }
    
    func getChapterApi() {

        guard let url = URL(string: "https://api.scripture.api.bible/v1/bibles/06125adad2d5898a-01/books/\(self.bookId)/chapters") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("2616457ad4f50588d80a812cf438c992", forHTTPHeaderField: "api-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(ChaptersResponse.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.apiChapters = decodedResponse.data
                        if (self.apiChapters.count > 0){
                            let chapterCount = self.apiChapters.count-1
                            let chapterArray = Array(1...chapterCount)
                            self.chapters = chapterArray
                        }
                    }

                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")        }.resume()
    }
    
    func getVersesApi() {

        guard let url = URL(string: "https://api.scripture.api.bible/v1/bibles/06125adad2d5898a-01/chapters/\(self.bookId).\(self.selectedChapter)/verses") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("2616457ad4f50588d80a812cf438c992", forHTTPHeaderField: "api-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(VersesResponse.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.apiVerses = decodedResponse.data
                        if (self.apiVerses.count > 0){
                            let verseCount = self.apiVerses.count
                            let verseArray = Array(1...verseCount)
                            self.verses = verseArray
                        }
                    }

                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")        }.resume()
    }
    
    func loadBooksApi() {
            
        guard let url = URL(string: "https://api.scripture.api.bible/v1/bibles/06125adad2d5898a-01/books") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("2616457ad4f50588d80a812cf438c992", forHTTPHeaderField: "api-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(BooksResponse.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.apiBooks = decodedResponse.data
                    }

                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")        }.resume()
    }
    
    func assembleRef() {
        if selectedStartVerse != 0 {
            if selectedEndVerse != 0 {
                assembledReference =  "\(books[selectedBook])+\(selectedChapter):\(selectedStartVerse)-\(selectedEndVerse)"
            }
            else{
                assembledReference = "\(books[selectedBook])+\(selectedChapter):\(selectedStartVerse)-\(verses.count)"
            }
        }
            
        else{
            assembledReference = "\(books[selectedBook])+\(selectedChapter)"
        }
    }
    
    func beautifyReference() -> String{
        return assembledReference.replacingOccurrences(of: "+", with: " ")
    }
}
