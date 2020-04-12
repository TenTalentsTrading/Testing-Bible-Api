//
//  SpokenView.swift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 4/12/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//

import SwiftUI

struct SpokenView: View {
    @EnvironmentObject var reference : ScriptureReference

    var body: some View {
        ScrollView(.vertical) {
            Text(assembleSpokenPassage()).foregroundColor(Color.green)
                + Text(assembleWrongWord()).foregroundColor(Color.red)
                + Text(assembleHintWord()).foregroundColor(Color.gray.opacity(0.75))
                + Text(assembleUnspokenPassage()).foregroundColor(Color.primary.opacity(0))
        }
    }
    
    func assembleHintWord() -> String {
        if self.reference.shouldShowNextWord {
            let nextWord = self.reference.unspokenPortionOfPassage.first ?? "nil"
            return nextWord + " "
        }
        
        else {
            return ""
        }
    }
    
    func assembleSpokenPassage() -> String {
        
        if self.reference.spokenPortionOfPassage.count > 0 {
            let spokenWords = self.reference.spokenPortionOfPassage.joined(separator: " ")
            return spokenWords + " "
        }
        else {
            return ""
        }
    }
    
    func assembleUnspokenPassage() -> String {
        let unspokenWords = self.reference.unspokenPortionOfPassage.joined(separator: " ")
        return unspokenWords
    }
    
    func assembleWrongWord() -> String {
        if !self.reference.wrongWord.isEmpty {
            return self.reference.wrongWord + " "
        }
        else{
            return ""
        }
    }
}

struct SpokenView_Previews: PreviewProvider {
    static var previews: some View {
        SpokenView()
    }
}
