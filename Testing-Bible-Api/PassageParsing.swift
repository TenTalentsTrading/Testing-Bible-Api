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
    
    @EnvironmentObject var reference : ScriptureReference

    private func splitOnPeriods(textToSplit: String) -> [String]  {
        //var spaceChar: Character = " "
        return textToSplit.components(separatedBy: ".")
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
    
    
    func removeAllButFirstWordofSentence(inboundSentence: String) -> String {
        var convertedWords = [String]()
        var convertedCount = 0
               
        let allWords = splitOnSpaces(inboundSentence)

        for word in allWords {
            
            if convertedCount < 1 {
                for char in word {
                    if char.isLetter {
                        convertedCount += 1
                    }
                }
                convertedWords.append(word)
           }
           
           else{
               let convertedWord = ReplaceAllCharactersWithUnderscore(word: word)
               convertedWords.append(convertedWord)
           }
       }
       
       return convertedWords.joined(separator: " ")
    }
    
    func ReplaceAllCharactersWithUnderscore(word: String) -> String{
        
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
    
    func splitOnSpaces(_ textToSplit: String) -> [String]  {
        //var spaceChar: Character = " "
        return textToSplit.components(separatedBy: " ")
    }
    
    private func leaveOnlyFirstLetter(words: [String]) -> [String] {
        var wordsOut = [String]()
        
        for word in words {
            wordsOut.append(convertAllButFirstLetterToHyphen(word: word))
        }
        
        return wordsOut
    }
    
    private func convertAllButFirstLetterToHyphen(word: String) -> String {
        
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
    
    func writeSpokenWordsToView(dictation: String){
        let lastWordSpoken = getLastWordSpoken(formattedString: dictation)
        checkLastWordSpokenAgainstPassage(lastWordSpoken: lastWordSpoken)
    }
    
    func getLastWordSpoken(formattedString: String) -> String{
        let allWords = splitOnSpaces(formattedString)
        return String(allWords.last ?? "Ready when you are...")
    }
    
    func checkLastWordSpokenAgainstPassage(lastWordSpoken: String){
            
            print(reference.passage)
//            let unSpokenWordsOfPassage = splitOnSpaces(reference.unspokenPortionOfPassage)
//            let nextWordToSpeak = getNextWordtoSpeak(words: unSpokenWordsOfPassage)
//
//            if nextWordToSpeak == lastWordSpoken {
//                print(lastWordSpoken)
//            }
        }
        
    func getNextWordtoSpeak(words: [Substring]) -> String {
        
        var foundWords = 0
        var outWord = "Ready when you are!"
        
        for word in words {
            print(word)
            if foundWords < 1 {
                for char in word {
                    if char.isLetter {
                        foundWords += 1
                        outWord = String(word)
                        print("Outword = \(outWord)")
                    }
                }
           }
        }
        
        return outWord
    }
    
    func setSpokenPortionOfPassage(spokenWords: String, passage: String) -> String {
        let spokenPortionOfPassage = String()
        return spokenPortionOfPassage
    }
    
    func getLastNWordsSpoken(dictation: String, wordsToReturn: Int) -> [String] {
        
        var outWords = [String]()
        
        let allWords = splitOnSpaces(dictation)
        let totalWordCount = allWords.count
        
        if allWords.count > wordsToReturn {
            for n in 0...(wordsToReturn-1) {
                       outWords.append(allWords[totalWordCount - 1 - n])
                   }
        }
        
        else{
            for word in allWords {
                outWords.append(word)
            }
        }
        
        return outWords
    }
    
    func stripWordOfNonLetters(word: String) -> String{
        var outWord = String()
        for char in word {
            if char.isLetter {
                outWord.append(char)
                }
            }
        
        return outWord
    }
    
    func isWord(word: String) -> Bool {
        for char in word {
            if char.isLetter {
                return true
                }
            }
        return false
    }
}

