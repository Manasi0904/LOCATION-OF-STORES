//
//  ApiServices.swift
//  NearByCoffeeShop
//
//  Created by Kumari Mansi on 20/01/25.
//


import Foundation

class ApiService {
    static let shared = ApiService()
    private init() {}
    
    
    func fetchData<T: Decodable>(urlString: String, parameters: [String: String]?, headers: [String: String]?, completion: @escaping (Result<T, Error>) -> Void) {
        
        
        guard var urlComponents = URLComponents(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 400, userInfo: nil)))
            return
        }
        
        
        if let parameters = parameters {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(NSError(domain: "URL Construction Failed", code: 400, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = "GET"
        
        
        if let headers = headers {
            headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        }
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No Data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
