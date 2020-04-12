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

    @State var isActive : Bool = false
    @State var showReference = false
    @State var isRecordingColor = Color.red
    @State var unspokenPassageOpacity = 0

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
            
            if self.reference.shouldShowPassage == true {
                PassageView().environmentObject(reference)
               .padding()
               .modifier(PassageTextStyler())
            }
            
            else {
                SpokenView().environmentObject(reference)
               .modifier(PassageTextStyler())
               .padding()
            }
            
            Spacer()
        
            HStack{
                
                Spacer()
            
                if self.reference.shouldShowPassage == true {
                    DropLettersView().environmentObject(reference)
                    .padding()
                }
                
                else {
                    ShowNextWordView().environmentObject(reference)
                     .padding()
                }
                
                Spacer()
                
                RecordButtonView().environmentObject(reference)
                .onAppear {
                    self.reference.getPermission()
                }
                .padding()
                .foregroundColor(self.reference.isRecording ? Color.red : Color.blue)
            
                Spacer()

                 if self.reference.shouldShowPassage == true {
                    DropWordsView().environmentObject(reference)
                    .padding()
                }
                    
                else {
                    SkipWordView().environmentObject(reference)
                    .padding()
                }
            
                Spacer()

                }
                .onAppear(perform: reference.loadPassages)
                .navigationBarTitle("Bible By Heart")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ScriptureReference())
    }
}

