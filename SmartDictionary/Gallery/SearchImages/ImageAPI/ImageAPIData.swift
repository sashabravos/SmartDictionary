//
//  ImageModel.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 06.06.2023.
//

import Foundation

struct ImageAPIData: Decodable {
    
    let total: Int
    let results: [UnsplashPhoto]
}

struct UnsplashPhoto: Decodable {
    let width: Int
    let height: Int
    let urls: [URLTypes.RawValue: String]
    
    enum URLTypes: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}
