//
//  ImageAPIData.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 06.06.2023.
//

import Foundation

final class ImageResponse {
    
    var imageRequestManager = ImageRequestManager()
    
    func fetchImages(for searchQuery: String, completion: @escaping (ImageAPIData?) -> Void) {
        imageRequestManager.request(for: searchQuery) { data, error in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
            
            let decode = self.decodeJSON(type: ImageAPIData.self, from: data)
            completion(decode)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
