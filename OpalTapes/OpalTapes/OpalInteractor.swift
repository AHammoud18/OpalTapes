//
//  OpalInteractor.swift
//  OpalTapes
//
//  Created by Ali Hammoud on 3/9/24.
//

import Foundation

class FetchTrack: NetworkRequest, ObservableObject {
    let url = URL(string: "")!
    
    func performRequest(url: String) {
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                assertionFailure("Error fetching URL: \(error)")
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                assertionFailure("Response Failure: \(response)")
            }
            
            let data = data
            print(data)
            
        }
        
    }
    
    
}
