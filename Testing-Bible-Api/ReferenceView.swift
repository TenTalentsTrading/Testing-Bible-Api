//
//  ReferenceView.swift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 4/1/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//

import SwiftUI


struct ReferenceView: View {
    
    @EnvironmentObject var reference : ScriptureReference
    @Binding var shouldPopToRootView : Bool
    
    var body: some View {
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

                        }
                    
                    Button (action: {
                        self.reference.assembleRef()
                        self.reference.loadPassages()
                        self.shouldPopToRootView = false
                        
                    } ){
                        Text("Load Passage")
                    }
                    
//                    Button(action: {
//                        self.reference.assembleRef()
//                        self.shouldPopToRootView = false
//                    }){
//                        Text("Load Passage")
//                    }
//                    NavigationLink(destination: ContentView()) {
//                        Text("Load Passage")
//                    }.onTapGesture {
//                        self.reference.assembleRef()
//                    }
            }.navigationBarTitle("Select Passage")
                    .padding(.top, 0.0)
    }
}

