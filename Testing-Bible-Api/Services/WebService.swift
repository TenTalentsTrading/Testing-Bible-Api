//
//  WebService.swift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 3/21/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//

import Foundation

class WebService{
    
    func loadBooksApi() -> [BookRecord] {
    
        var bookRecords = [BookRecord]()
        
        guard let url = URL(string: "https://api.scripture.api.bible/v1/bibles/06125adad2d5898a-01/books") else {
            print("Invalid URL")
            return bookRecords
        }
        
        var request = URLRequest(url: url)
        request.setValue("2616457ad4f50588d80a812cf438c992", forHTTPHeaderField: "api-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(BooksResponse.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        bookRecords = decodedResponse.data
                    }

                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")        }.resume()
        
        return bookRecords
    }
}
