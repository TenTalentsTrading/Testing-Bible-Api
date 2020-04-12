//
//  SkipWordView.swift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 4/12/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//

import SwiftUI

struct SkipWordView: View {
    
    @EnvironmentObject var reference : ScriptureReference
    
    var body: some View {
          Button(action: {
            self.reference.skipWord()
            self.reference.clearPeekedWord()
           }) {
              VStack{
                  Image(systemName: "arrow.right")
                   .resizable()
                   .aspectRatio(contentMode: .fit)
                   .frame(height: 40)
                  Text("Skip Word").modifier(ButtonStyler())
               }
          }
    }
}

struct SkipWordView_Previews: PreviewProvider {
    static var previews: some View {
        SkipWordView()
    }
}
