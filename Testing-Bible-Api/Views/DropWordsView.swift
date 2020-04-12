//
//  DropWordsView.swift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 4/12/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//

import SwiftUI

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

struct DropWordsView: View {
    
    @EnvironmentObject var reference : ScriptureReference

    var body: some View {
        Button(action: {
            self.reference.areWordsDropped.toggle()
        }) {
            VStack{
            Text("Cat").strikethrough(true).modifier(ButtonStylerLarge())
                Text("Drop Words").modifier(ButtonStyler())
            }.foregroundColor(self.reference.areWordsDroppedColor)
        }
    }
}

struct DropWordsView_Previews: PreviewProvider {
    static var previews: some View {
        DropWordsView()
    }
}
