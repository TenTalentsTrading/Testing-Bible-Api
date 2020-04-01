//
//  BibleBooks.swift
//  Testing-Bible-Api
//
//  Created by Brittany Turner on 3/25/20.
//  Copyright © 2020 Ten Talents Trading. All rights reserved.
//

import Foundation

struct BooksResponse: Codable {
    var data: [BookRecord]
}

struct BookRecord: Codable {
   var id: String
    var name: String
}

struct ChaptersResponse: Codable {
    var data: [ChapterRecord]
}

struct ChapterRecord: Codable {
   var id: String
    var number: String
}

struct VersesResponse: Codable {
    var data: [VerseRecord]
}

struct VerseRecord: Codable {
   var id: String
}


struct Response: Codable {
    var query: String
    var passages: [String]
}

struct passage_meta: Codable {
   var canonical: String
    var chapter_start: [Int]
    var chapter_end: [Int]
    var prev_verse: Int
    var next_verse: Int
    var prev_chapter: [Int]
    var next_chapter: [Int]
}

struct BibleBookList {
    
    func getBooks() -> [String] {
        let bibleBooks = ["Genesis",
        "Exodus",
        "Leviticus",
        "Numbers",
        "Deuteronomy",
        "Joshua",
        "Judges",
        "Ruth",
        "1 Samuel",
        "2 Samuel",
        "1 Kings",
        "2 Kings",
        "1 Chronicles",
        "2 Chronicles",
        "Ezra",
        "Nehemiah",
        "Esther",
        "Job",
        "Psalm",
        "Proverbs",
        "Ecclesiastes",
        "Song of Solomon",
        "Isaiah",
        "Jeremiah",
        "Lamentations",
        "Ezekiel",
        "Daniel",
        "Hosea",
        "Joel",
        "Amos",
        "Obadiah",
        "Jonah",
        "Micah",
        "Nahum",
        "Habakkuk",
        "Zephaniah",
        "Haggai",
        "Zechariah",
        "Malachi",
        "Matthew",
        "Mark",
        "Luke",
        "John",
        "Acts",
        "Romans",
        "1 Corinthians",
        "2 Corinthians",
        "Galatians",
        "Ephesians",
        "Philippians",
        "Colossians",
        "1 Thessalonians",
        "2 Thessalonians",
        "1 Timothy",
        "2 Timothy",
        "Titus",
        "Philemon",
        "Hebrews",
        "James",
        "1 Peter",
        "2 Peter",
        "1 John",
        "2 John",
        "3 John",
        "Jude",
        "Revelation"]
        
        return bibleBooks
    }
}
