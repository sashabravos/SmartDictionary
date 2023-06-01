//
//  DictionaryAPIData.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 22.05.2023.
//

import Foundation

struct DictionaryAPIData: Codable {
    let def: [Definition]
}

struct Definition: Codable {
    let text: String
    let ts: String
    let tr: [Translation]
}

struct Translation: Codable {
    let text: String
    let syn: [Synonym]?
}

struct Synonym: Codable {
    let text: String
}
