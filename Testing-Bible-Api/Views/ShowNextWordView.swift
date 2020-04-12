//
//  ShowNextWordView.swift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 4/12/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//

import SwiftUI

struct ShowNextWordView: View {
    
    @EnvironmentObject var reference : ScriptureReference

    var body: some View {
          Button(action: {
            self.reference.shouldShowNextWord.toggle()
            self.reference.clearWrongWord()
           }) {
              VStack{
                  Image(systemName: "eye")
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   .frame(height: 40)
                  Text("Show Next").modifier(ButtonStyler())
               }
          }
    }
}

struct ShowNextWordView_Previews: PreviewProvider {
    static var previews: some View {
        ShowNextWordView()
    }
}
