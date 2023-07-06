//
//  PictureDictionaryTestModel.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 06.07.2023.
//

import UIKit

final class TestModel {
    
    static let shared = TestModel()
    
    private init() {}
    
    public let imageNames = ["Apple", "Cookie", "Dinosaur", "Elmo", "Forest",
                             "Killer Whale", "Sun", "Sunset", "Waterfall"]
    public let images = [
        UIImage(named: "apple"),
        UIImage(named: "cookieMonster"),
        UIImage(named: "dinosaur"),
        UIImage(named: "elmo"),
        UIImage(named: "forest"),
        UIImage(named: "killerWhale"),
        UIImage(named: "sun"),
        UIImage(named: "sunset"),
        UIImage(named: "waterfall")
    ]
}
