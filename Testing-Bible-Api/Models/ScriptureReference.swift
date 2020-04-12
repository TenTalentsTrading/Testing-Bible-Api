//
//  Scriptureswift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 3/31/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//

import Foundation
import SwiftUI
import Speech

class ScriptureReference: ObservableObject {
    
    var passageParsing = PassageParsing()
    
    @Published var books = BibleBookList().getBooks()
    @Published var apiBooks = [BookRecord]()
    @Published var bookId = "GEN"
    @Published var selectedBook = 0 {
    didSet {
            if (apiBooks.count > 0) {
                let record: BookRecord = apiBooks.filter{$0.name == books[selectedBook]}.first!
                bookId = record.id
            }
            else {
                print("Could not change book id...")
            }
            
            getChapterApi()
        }
    }
    
    //Chapter Variables///////////////////////////////////////////////////////////////
    @Published var chapters = [Int]()
    @Published var apiChapters = [ChapterRecord]()
    @Published var selectedChapter = 1 {
    didSet {
        getVersesApi()
        }
    }
    
    
    //Verse Variables//////////////////////////////////////////////////////////////////////
    @Published var verses = [Int]()
    @Published var apiVerses = [VerseRecord]()
    @Published var selectedStartVerse = Int() {
    didSet {
        remainingVerses = Array(selectedStartVerse...verses.count)
        }
    }
    @Published var selectedEndVerse = Int()
    @Published var remainingVerses = [Int]()
    
    
    //Main Passage Variables////////////////////////////////////////////////////////////////////////
    @Published var assembledReference = String()
    @Published var passage = String() {
        didSet{
            self.setAlternatePassages()
            unspokenPortionOfPassage = passageParsing.splitOnSpaces(passage)
            spokenPortionOfPassage = [String]()
        }
    }
    @Published var firstLetterPassage = String()
    @Published var firstWordPassage = String ()
    
    
    //Variables for Dropping First letter////////////////////////////////////////////////////////////
    @Published var isFirstLetterDroppedColor: Color = Color.blue
    @Published var isOnlyFirstLetterShown = false {
        didSet {
            if isOnlyFirstLetterShown == true {
                areWordsDropped = false
                isFirstLetterDroppedColor = Color.red
            }
            else{
                isFirstLetterDroppedColor = Color.blue
            }
        }
    }
    
    //Variables for Dropping All But First Word/////////////////////////////////////////////////////
    @Published var areWordsDroppedColor: Color = Color.blue
    @Published var areWordsDropped = false {
        didSet {
            if areWordsDropped == true {
                isOnlyFirstLetterShown = false
                areWordsDroppedColor = Color.red
            }
            else{
                areWordsDroppedColor = Color.blue
            }
        }
    }
    
    //Variables for dictation/////////////////////////////////////////////////////////////////////////
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @Published var captioning: String = "Waiting to Start!" {
        didSet{
            updatePassageDictationTextHolders()
            clearPeekedWord()
        }
    }
    
    @Published var isRecording = false
    @Published var micEnabled = false
    @Published var isRecordingColor = Color.red
    @Published var isRecordingSessionActive = false {
        didSet{
            if spokenPortionOfPassage.count == 0 {
            unspokenPortionOfPassage = passageParsing.splitOnSpaces(passage)
            }
            moveNonWordsToSpokenPortionOfPassage()
        }
    }
    
    //Variables for Spoken and Unspoken portions of passage////////////////////////////////////////////
    @Published var shouldShowPassage = true
    @Published var spokenPortionOfPassage = [String]()
    @Published var unspokenPortionOfPassage = [String]()
    @Published var nextWordInPassage = String()
    @Published var shouldShowNextWord = false
    @Published var wrongWord = String()
        
    
    
    //END VARIABLES/////////////////////////////////////////////////////////////////////////////////////
    
    //Running these functions upon initialization to prepare the object
    init() {
        getChapterApi()
        getVersesApi()
        loadBooksApi()
        assembleRef()
        loadPassages()
    }

    //object functions to get stuff done!
    
    func setAlternatePassages(){
        firstLetterPassage = PassageParsing().DropAllButFirstLetters(text: passage)
        firstWordPassage = PassageParsing().DropAllButFirstWord(text: passage)
    }
    
    func loadPassages() {
        guard let url = URL(string: "https://api.esv.org/v3/passage/text/?q=\(assembledReference)&include-passage-references=false&include-headings=false") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.setValue("Token a2e16e4aa6e439cc1478cdbf057411d633375cf5", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(Response.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.passage = decodedResponse.passages[0]
                    }

                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")        }.resume()
    }
    
    func getChapterApi() {

        guard let url = URL(string: "https://api.scripture.api.bible/v1/bibles/06125adad2d5898a-01/books/\(self.bookId)/chapters") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("2616457ad4f50588d80a812cf438c992", forHTTPHeaderField: "api-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(ChaptersResponse.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.apiChapters = decodedResponse.data
                        if (self.apiChapters.count > 0){
                            let chapterCount = self.apiChapters.count-1
                            let chapterArray = Array(1...chapterCount)
                            self.chapters = chapterArray
                        }
                    }

                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")        }.resume()
    }
    
    func getVersesApi() {

        guard let url = URL(string: "https://api.scripture.api.bible/v1/bibles/06125adad2d5898a-01/chapters/\(self.bookId).\(self.selectedChapter)/verses") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("2616457ad4f50588d80a812cf438c992", forHTTPHeaderField: "api-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(VersesResponse.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.apiVerses = decodedResponse.data
                        if (self.apiVerses.count > 0){
                            let verseCount = self.apiVerses.count
                            let verseArray = Array(1...verseCount)
                            self.verses = verseArray
                        }
                    }

                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")        }.resume()
    }
    
    func loadBooksApi() {
            
        guard let url = URL(string: "https://api.scripture.api.bible/v1/bibles/06125adad2d5898a-01/books") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("2616457ad4f50588d80a812cf438c992", forHTTPHeaderField: "api-key")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(BooksResponse.self, from: data) {
                    // we have good data – go back to the main thread
                    DispatchQueue.main.async {
                        // update our UI
                        self.apiBooks = decodedResponse.data
                    }

                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")        }.resume()
    }
    
    func assembleRef() {
        if selectedStartVerse != 0 {
            if selectedEndVerse != 0 {
                assembledReference =  "\(books[selectedBook])+\(selectedChapter):\(selectedStartVerse)-\(selectedEndVerse)"
            }
            else{
                assembledReference = "\(books[selectedBook])+\(selectedChapter):\(selectedStartVerse)-\(verses.count)"
            }
        }
            
        else{
            assembledReference = "\(books[selectedBook])+\(selectedChapter)"
        }
    }
    
    func beautifyReference() -> String{
        return assembledReference.replacingOccurrences(of: "+", with: " ")
    }
        
    //Thanks to https://developer.apple.com/documentation/speech/recognizing_speech_in_live_audio
    func startRecording() throws {
        
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode

        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        // Keep speech recognition data on device
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = false
        }
        
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                // Update the text view with the results.
                self.captioning = result.bestTranscription.formattedString
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.recognitionRequest = nil
                self.recognitionTask = nil

                self.isRecording = false
            }
        }

        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    
    
    func micButtonTapped(){
        if audioEngine.isRunning {
            
            recognitionRequest?.endAudio()
            audioEngine.stop()
            isRecording = false
        } else {
            do {
                try startRecording()
                isRecording = true
            } catch {
                isRecording = false
            }
        }
    }
    
    
    func getPermission(){
        // Asynchronously make the authorization request.
        SFSpeechRecognizer.requestAuthorization { authStatus in

            // Divert to the app's main thread so that the UI
            // can be updated.
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.micEnabled = true
                    
                case .denied, .restricted, .notDetermined:
                    self.micEnabled = false
                    
                default:
                    self.micEnabled = false
                }
            }
        }
    }
    
    
    func updatePassageDictationTextHolders(){
        let lastTwoWordsSpoken = passageParsing.getLastNWordsSpoken(dictation: captioning, wordsToReturn: 2)
        
        if passageParsing.isWord(word: nextWordInPassage) {
            let nextWordInPassageStripped = passageParsing.stripWordOfNonLetters(word: nextWordInPassage)
            let nextWordInPassageFrozen = nextWordInPassage

            for lastWord in lastTwoWordsSpoken.reversed() {
                if lastWord.lowercased() == nextWordInPassageStripped.lowercased() {
                    unspokenPortionOfPassage.removeFirst()
                    spokenPortionOfPassage.append(nextWordInPassageFrozen)
                    clearWrongWord()
                }
            }
            
            checkForWrongWord(lastWords: lastTwoWordsSpoken)
        }
            
        else{
             unspokenPortionOfPassage.removeFirst()
             spokenPortionOfPassage.append(nextWordInPassage)
        }
        
        moveNonWordsToSpokenPortionOfPassage()
        
    }
    
    func skipWord() {
        spokenPortionOfPassage.append(nextWordInPassage)
        unspokenPortionOfPassage.removeFirst()
        moveNonWordsToSpokenPortionOfPassage()
        clearWrongWord()
    }
    
    func clearWrongWord() {
        wrongWord = String()
    }
    
    func clearPeekedWord() {
        shouldShowNextWord = false
    }
    
    func checkForWrongWord(lastWords: [String]) {
        let lastWordSpokenCorrectly = spokenPortionOfPassage.last ?? "nil"
        let lastWordSpokenCorrectlyStripped = passageParsing.stripWordOfNonLetters(word: lastWordSpokenCorrectly)
        let lastWordSpoken = passageParsing.getLastWordSpoken(formattedString: captioning)
        
        if lastWordSpoken.lowercased() != lastWordSpokenCorrectlyStripped.lowercased() {
           wrongWord = lastWordSpoken
        }
    }

    
    func moveNonWordsToSpokenPortionOfPassage(){
        var nextWordIsNotReallyAWord = true
        while nextWordIsNotReallyAWord {
            let nextWordInList = unspokenPortionOfPassage.first ?? "Nil"
            
            if passageParsing.isWord(word: nextWordInList) {
                nextWordInPassage = nextWordInList
                nextWordIsNotReallyAWord = false
            }
            
            else{
                spokenPortionOfPassage.append(nextWordInList)
                unspokenPortionOfPassage.removeFirst()
            }
            
        }
    }
}
