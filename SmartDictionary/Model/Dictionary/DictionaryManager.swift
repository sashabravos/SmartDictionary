//
//  DictionaryManager.swift
//  SmartDictionary
//
//  Created by Александра Кострова on 22.05.2023.
//

import Foundation

protocol DictionaryManagerDelegate {
    func didUpdateData(_ dictionaryManager: DictionaryManager, dictionary: DictionaryModel)
    func didFailWithError(error: Error)
}

struct DictionaryManager {
    
    var delegate: DictionaryManagerDelegate?

    let baseURL = "https://dictionary.yandex.net/api/v1/dicservice.json/lookup?lang=en-ru&key="
    let apiKey = "ADD_YOUR_API_KEY"
    
    func getWordInfo(word: String) {
        let urlString = "\(baseURL)\(apiKey)&text=\(word)"
        self.performRequest(with: urlString, word: word)
    }
    
    func performRequest(with urlString: String, word: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, _, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let dictionary = self.parseJSON(safeData, word: word) {
                        self.delegate?.didUpdateData(self, dictionary: dictionary[0])
                    }
                }
            }
            task.resume()
        }
    }

    func parseJSON(_ dictionaryData: Data, word: String) -> [DictionaryModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(DictionaryAPIData.self, from: dictionaryData)
            let word = word
            let translation = decodedData.def[0].tr[0].text
            let transcription = "[ \(decodedData.def[0].ts) ]"
            
            let wordData = DictionaryModel(currentWord: word, translation: translation, transcription: transcription)
            return [wordData]
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
