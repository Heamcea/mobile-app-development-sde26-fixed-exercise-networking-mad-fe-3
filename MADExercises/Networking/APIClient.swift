//
//  APIClient.swift
//  MADExercises
//
//

import Foundation

class APIClient {
    
    private let urlSession = URLSession(configuration: .default)
    
    private let apiKey = "AIzaSyDeLs8S6Hpy642JUPC3Pft-xVx8Ocs-uXY"
    
    func login(
        email: String,
        password: String,
        completionHandler: @escaping (User?, NetworkingError?) -> Void
    ) {
        let endpoint = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=" + apiKey
        
        guard let url = URL(string: endpoint) else {
            completionHandler(nil, .unexpectedError)
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = ["email": email, "password": password, "returnSecureToken": true]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            completionHandler(nil, .serializationError)
            return
        }
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                DispatchQueue.main.async {
                    completionHandler(nil, .networkUnavailable(error?.localizedDescription ?? "Unknown network error"))
                }
                return
            }
            
            guard let data else {
                DispatchQueue.main.async {
                    completionHandler(nil, .invalidResponse)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completionHandler(nil, .invalidResponse)
                }
                return
            }
            
            if httpResponse.statusCode == 200 {
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    
                    DispatchQueue.main.async {
                        completionHandler(user, nil)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completionHandler(nil, .invalidResponse)
                    }
                }
                return
            }
             
            do {
                let responseError = try JSONDecoder().decode(ResponseError.self, from: data)
                
                let networkingError = responseError.getNetworkingError()
                
                DispatchQueue.main.async {
                    completionHandler(nil, networkingError)
                }
            } catch {
                DispatchQueue.main.async {
                    completionHandler(nil, .unsuccessfulStatusCode(httpResponse.statusCode))
                }
            }
        }
        task.resume()
    }
}
