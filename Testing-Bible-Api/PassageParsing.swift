//
//  PassageParsing.swift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 4/3/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//

import Foundation
import SwiftUI

extension String: Identifiable {
    public var id: String {
        return self
    }
}

class PassageParsing {
    
    private func splitOnPeriods(textToSplit: String) -> [Substring]  {
        //var spaceChar: Character = " "
        return textToSplit.split(separator: Character("."))
    }
    
    func DropAllButFirstWord(text: String) -> String {
        
        let allSentences = splitOnPeriods(textToSplit: text)
        var convertedSentences = [String]()
        
        for sentence in allSentences {
            let convertedSentence = removeAllButFirstWordofSentence(inboundSentence: sentence)
            convertedSentences.append(convertedSentence)
        }
        
        return convertedSentences.joined(separator: " ")
    }
    
    
    func removeAllButFirstWordofSentence(inboundSentence: Substring) -> String {
        var convertedWords = [String]()
        var convertedCount = 0
               
        let allWords = splitOnSpaces(String(inboundSentence))

        for word in allWords {
            
            if convertedCount < 1 {
                for char in word {
                    if char.isLetter {
                        convertedCount += 1
                    }
                }
                convertedWords.append(String(word))
           }
           
           else{
               let convertedWord = ReplaceAllCharactersWithUnderscore(word: word)
               convertedWords.append(convertedWord)
           }
       }
       
       return convertedWords.joined(separator: " ")
    }
    
    func ReplaceAllCharactersWithUnderscore(word: Substring) -> String{
        
        var outWord = String()
        for char in word {
            if char.isLetter == true {
                outWord.append("_")
            }
            else{
                outWord.append(char)
            }
        }
        
        return outWord
    }
    
    func DropAllButFirstLetters(text: String) -> String {
        
        let allWords = splitOnSpaces(text)
        let allWordsConverted = leaveOnlyFirstLetter(words: allWords)
        
        return allWordsConverted.joined(separator: " ")
    }
    
    private func splitOnSpaces(_ textToSplit: String) -> [Substring]  {
        //var spaceChar: Character = " "
        return textToSplit.split(separator: Character(" "))
    }
    
    private func leaveOnlyFirstLetter(words: [Substring]) -> [String] {
        var wordsOut = [String]()
        
        for word in words {
            wordsOut.append(convertAllButFirstLetterToHyphen(word: word))
        }
        
        return wordsOut
    }
    
    private func convertAllButFirstLetterToHyphen(word: Substring) -> String {
        
        var count = 1
        var outString = String()
        for char in word {
            if count == 1 {
                outString.append(char)
            }
            else if char.isLetter == true {
                outString.append("_")
            }
            else{
                outString.append(char)
            }
        count += 1
        }
        
        return outString
    }
}

