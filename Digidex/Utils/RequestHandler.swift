//
//  RequestHandler.swift
//  Digidex
//
//  Created by riswan ardiansah on 18/10/24.
//

import UIKit

struct RequestHandler {
  
  func fetchData<T: Decodable>(modelType: T.Type, parameters: String, completion : @escaping (Result<T, Error>) -> Void) {
    guard let url = URL(string: parameters) else {return}
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
      let session = URLSession.shared
      session.dataTask(with: request) { (data, response, error) in
        if let error = error {
          completion(.failure(error))
        } else {
          completion( Result { try JSONDecoder().decode(T.self, from: data!)})
        }
      }.resume()
  }
}
