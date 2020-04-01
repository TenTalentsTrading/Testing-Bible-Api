//
//  ContentView.swift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 3/21/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var reference = ScriptureReference()

    var body: some View {
        NavigationView{
            Form {
                Section {
                    Picker("Book Selector", selection: $reference.selectedBook){
                        ForEach(0 ..< reference.books.count){
                            Text("\(self.reference.books[$0])")
                        }
                    }

                    Picker("Chapter Selector", selection: $reference.selectedChapter){
                        ForEach(reference.chapters, id: \.self) { chapter in
                            Text("\(chapter)")
                        }
                    }
                    

                    Picker("Start Verse", selection: $reference.selectedStartVerse){
                       ForEach(reference.verses, id: \.self) { verse in
                           Text("\(verse)")
                       }
                   }
                    
                    Picker("Start Verse", selection: $reference.selectedEndVerse){
                        ForEach(reference.remainingVerses, id: \.self) { verse in
                            Text("\(verse)")
                        }
                    }
                    
                    Button(action: {
                        self.reference.loadPassages(reference: self.assembleRef())
                    }) {
                        Text("Load Passage")
                    }
                }

            
                Section{
                    List {
                        VStack{
                          if reference.passages.count > 0 {
                                    ScrollView(.vertical) {
                                    Text("\(reference.passages[0])")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func assembleRef() -> String {
        
        if reference.selectedStartVerse != 0 {
            if reference.selectedEndVerse != 0 {
                return "\(reference.books[reference.selectedBook])+\(reference.selectedChapter):\(reference.selectedStartVerse)-\(reference.selectedEndVerse)"
            }
            else{
                return "\(reference.books[reference.selectedBook])+\(reference.selectedChapter):\(reference.selectedStartVerse)-\(reference.verses.count)"
            }
        }
            
        else{
            return "\(reference.books[reference.selectedBook])+\(reference.selectedChapter)"
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    
    static let reference = ScriptureReference()
    
    static var previews: some View {
        ContentView().environmentObject(reference)
    }
}
