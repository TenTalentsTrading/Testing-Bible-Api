//
//  DropLettersView.swift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 4/12/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//

import SwiftUI

struct DropLettersView: View {
    
    @EnvironmentObject var reference : ScriptureReference
    
    struct ButtonStylerLarge: ViewModifier {
        func body(content: Content) -> some View {
            return content
            .font(Font.custom("Arial Rounded MT Bold", size: 30))
        }
    }
    
    struct ButtonStyler: ViewModifier {
           func body(content: Content) -> some View {
               return content
               .font(Font.custom("Arial Rounded MT", size: 16))
           }
       }

    var body: some View {
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
    }
}

struct DropLettersView_Previews: PreviewProvider {
    static var previews: some View {
        DropLettersView()
    }
}
