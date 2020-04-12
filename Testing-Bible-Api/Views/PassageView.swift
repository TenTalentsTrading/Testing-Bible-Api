//
//  PassageView.swift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 4/6/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//

import SwiftUI

struct PassageView: View {
    @EnvironmentObject var reference : ScriptureReference
    
    var body: some View {
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
        }
    }
}

struct PassageView_Previews: PreviewProvider {
    static var previews: some View {
        PassageView()
    }
}
