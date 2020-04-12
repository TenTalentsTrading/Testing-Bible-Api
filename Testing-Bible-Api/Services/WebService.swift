//
//  WebService.swift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 3/21/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//

import Foundation

class WebService{
    
    func loadPassages(assembledReference: String) -> String {
    
        var passage = String()
    
        guard let url = URL(string: "https://api.esv.org/v3/passage/text/?q=\(assembledReference)&include-passage-references=false&include-headings=false") else {
            print("Invalid URL")
            return "Passage Could Not be Loaded..."
        }
        var request = URLRequest(url: url)
        request.setValue("Token a2e16e4aa6e439cc1478cdbf057411d633375cf5", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        passage = decodedResponse.passages[0]
                    }

                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")        }.resume()
    
        return passage
    }
    
    func getChapterApi(bookId: String) -> [ChapterRecord] {
        
        var chapters = [ChapterRecord]()
        print(bookId)
        guard let url = URL(string: "https://api.scripture.api.bible/v1/bibles/06125adad2d5898a-01/books/\(bookId)/chapters") else {
            print("Invalid URL")
            return chapters
        }
        
        var request = URLRequest(url: url)
        request.setValue("2616457ad4f50588d80a812cf438c992", forHTTPHeaderField: "api-key")
        print("I'm setting the request for chapters...")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(ChaptersResponse.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        print("I'm converting chapters...")
                        chapters = decodedResponse.data
                        print(chapters)
                    }

                    // everything is good, so we can exit
                    return
                }
                
                print("there was an issue...")
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")        }.resume()
        
        print("i'm going to return \(chapters.count) chapters")
        return chapters
    }
    
    func getVersesApi(bookId: String, selectedChapter: Int) -> [VerseRecord]{

        var verses = [VerseRecord]()
        
        guard let url = URL(string: "https://api.scripture.api.bible/v1/bibles/06125adad2d5898a-01/chapters/\(bookId).\(selectedChapter)/verses") else {
            print("Invalid URL")
            return verses
        }
        
        var request = URLRequest(url: url)
        request.setValue("2616457ad4f50588d80a812cf438c992", forHTTPHeaderField: "api-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(VersesResponse.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        verses = decodedResponse.data
                    }

                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")        }.resume()
        
        return verses
    }
    
    func loadBooksApi() -> [BookRecord] {
            
        var books = [BookRecord]()
        
        guard let url = URL(string: "https://api.scripture.api.bible/v1/bibles/06125adad2d5898a-01/books") else {
            print("Invalid URL")
            return books
        }
        
        var request = URLRequest(url: url)
        request.setValue("2616457ad4f50588d80a812cf438c992", forHTTPHeaderField: "api-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(BooksResponse.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        books = decodedResponse.data
                    }

                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")        }.resume()
        
        return books
    }
}
