//
//  ContentView.swift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 3/21/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var passages = [String]()
    
    @State private var bookId = "GEN"
    @State private var books = BibleBookList().getBooks()
//    @State private var selectedBook = 0

    @State private var chapters = [Int]()
    @State private var apiChapters = [ChapterRecord]()
    @State private var selectedChapter = 1
    
    @State private var verses = [Int]()
    @State private var apiVerses = [VerseRecord]()
    @State private var selectedStartVerse = 1
    @State private var selectedEndVerse = 1
    
    @ObservedObject var reference = ScriptureReference()

    var body: some View {
        NavigationView{
            Form {
                Section {
                    Picker("Book Selector", selection: $reference.selectedBook){
                        ForEach(0 ..< books.count){
                            Text("\(self.books[$0])")
                        }
                    }
                    .onReceive([reference.selectedBook].publisher.first()){
                        (value) in
                        print("Book Selector Received Input")
                        if reference.apiBooks.count > 0 {
                            self.setChapters()
                        }
                    }

                    Picker("Chapter Selector", selection: $selectedChapter){
                        ForEach(chapters, id: \.self) { chapter in
                            Text("\(chapter)")
                        }
                    }
                    .onReceive([self.selectedChapter].publisher.first()){
                        (value) in
                        print("Chapter Selector Received Input")
                        if self.apiChapters.count > 0 {
                            self.getVersesApi()
                        }
                    }

                    Picker("Start Verse", selection: $selectedStartVerse){
                        ForEach(verses, id: \.self) { verse in
                            Text("\(verse)")
                        }
                    }

                    Picker("End Verse", selection: $selectedEndVerse){
                        if (verses.count > 0 ){
                            ForEach(selectedStartVerse...verses.count, id: \.self) { verse in
                            Text("\(verse)")}
                        }
                    }
                                    
                if passages.count > 0 {
                    Text("\(passages[0])")
                    }
                }
                
                Spacer()
                
                Section{
                    Button(action: {
                        self.loadPassages(reference: self.assembleRef())
                    }) {
                        Text("Load Passage")

                    }
                }
            }
        }
        .onAppear(perform: setChapters)
    }
    
    func assembleRef() -> String {
        
        if books.count > 0 {
            return "\(books[reference.selectedBook])+\(selectedChapter):\(selectedStartVerse)-\(selectedEndVerse)!!"
        }
        
        else {
            return ""
        }
    }
    
    
    func loadPassages(reference: String) {
        guard let url = URL(string: "https://api.esv.org/v3/passage/text/?q=\(reference)") else {
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
                        self.passages = decodedResponse.passages
                    }

                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")        }.resume()
    }
    
//    func loadBooksApi() {
//        guard let url = URL(string: "https://api.scripture.api.bible/v1/bibles/06125adad2d5898a-01/books") else {
//            print("Invalid URL")
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.setValue("2616457ad4f50588d80a812cf438c992", forHTTPHeaderField: "api-key")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data {
//                let str = String(decoding: data, as: UTF8.self)
//                if let decodedResponse = try? JSONDecoder().decode(BooksResponse.self, from: data) {
//                    // we have good data – go back to the main thread
//                    DispatchQueue.main.async {
//                        // update our UI
//                        self.apiBooks = decodedResponse.data
//                    }
//
//                    // everything is good, so we can exit
//                    return
//                }
//            }
//
//            // if we're still here it means there was a problem
//            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")        }.resume()
//    }
    
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
                            let chapterCount = self.apiChapters.count - 1
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
                            let verseCount = self.apiVerses.count - 1
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
    
    func setChapters() {
        //get current book id
        if apiBooks.count > 0 {
            let record: BookRecord = apiBooks.filter{ $0.name == books[reference.selectedBook]}.first!
            bookId = record.id
        }
        //get Chapters from api
        getChapterApi()
    }
}


struct ContentView_Previews: PreviewProvider {
    
    static let reference = ScriptureReference()
    
    static var previews: some View {
        ContentView().environmentObject(reference)
    }
}
