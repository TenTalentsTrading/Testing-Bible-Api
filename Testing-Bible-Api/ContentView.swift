//
//  ContentView.swift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 3/21/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var reference : ScriptureReference
    @ObservedObject var closedCap = ClosedCaptioning()

    @State var isActive : Bool = false
    @State var showReference = false
    @State var shouldShowPassage = true

    struct ReferenceStyler: ViewModifier {
           func body(content: Content) -> some View {
               return content
               .font(Font.custom("Arial Rounded MT Bold", size: 18))
           }
       }
    
    struct ButtonStyler: ViewModifier {
           func body(content: Content) -> some View {
               return content
               .font(Font.custom("Arial Rounded MT", size: 16))
           }
       }
    
    struct ButtonStylerLarge: ViewModifier {
        func body(content: Content) -> some View {
            return content
            .font(Font.custom("Arial Rounded MT Bold", size: 30))
        }
    }
    
    struct PassageTextStyler: ViewModifier {
        func body(content: Content) -> some View {
            return content
            .font(Font.custom("Arial Rounded MT", size: 20))
        }
    }
    
    var body: some View {
        
        VStack{
        Spacer()
        Divider()
        NavigationLink(
            destination: ReferenceView(shouldPopToRootView: self.$isActive),
            isActive: self.$isActive) {
                Text(reference.beautifyReference())
            }
            .isDetailLink(false)
        .modifier(ReferenceStyler())
        Divider()

        Spacer()
//                    HStack {
//                        Text(self.closedCap.captioning)
//                            .font(.body)
//                            .truncationMode(.head)
//                            .lineLimit(4)
//                            .padding()
//                    }
//                    .frame(width: 350, height: 200)
//                    .background(Color.red.opacity(0.25))
//                    .padding()
    
    if shouldShowPassage {
                ScrollView(.vertical) {
                    if self.reference.areWordsDropped == true {
                        Text("\(reference.firstWordPassage)")
                    }
                    else if self.reference.isOnlyFirstLetterShown == true {
                        Text("\(reference.firstLetterPassage)")
                    }
                    else{
                        Text("\(reference.passage)")
                    }
                }.padding()
                .modifier(PassageTextStyler())
            }
            
        Spacer()
        
        HStack{
            Spacer()
            
            Button(action: {
                self.reference.isOnlyFirstLetterShown.toggle()

            }) {
                VStack{
                    HStack{
                        Text("C").padding(-4)
                        Text("at").strikethrough(true).padding(-4)
                    }.modifier(ButtonStylerLarge())
                    Text("Drop Letters").modifier(ButtonStyler())
                }.foregroundColor(self.reference.isFirstLetterDroppedColor)
            }
            .padding()
            
            Spacer()
            
            Button(action: {
                self.closedCap.micButtonTapped()
//                self.shouldShowPassage.toggle()
            }) {
                Image(systemName: !self.closedCap.micEnabled ? "mic.slash" : (self.closedCap.isPlaying ? "mic.circle.fill" : "mic.circle"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 75)
                }
                .onAppear {
                    self.closedCap.getPermission()}
                .padding()
//                .foregroundColor(self.closedCap.isRecordingColor)
            
            Spacer()

            Button(action: {
                self.reference.areWordsDropped.toggle()
            }) {
                VStack{
                Text("Cat").strikethrough(true).modifier(ButtonStylerLarge())
                    Text("Drop Words").modifier(ButtonStyler())
                }.foregroundColor(self.reference.areWordsDroppedColor)
            }
            .padding()
            
            Spacer()

            }
            .onAppear(perform: reference.loadPassages)
            .navigationBarTitle("Bible By Heart")
        }
    }
    
    func removeAllButFirstLettersFromPassage() {
        let newText = PassageParsing().DropAllButFirstLetters(text: reference.passage)
        reference.passage = newText
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ScriptureReference())
    }
}

