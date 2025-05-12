//
//  ApiManager.swift
//  SwiftUI_mgr
//
//  Created by Łukasz Czapkowski on 19/01/2025.
//

import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    private init() {}
    
    func performRequest<T: Codable, U:Codable>(
        url: String,
        method: HTTPMethod,
        parameters: U? = nil,
        query: [URLQueryItem]? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        guard var urlComponents = URLComponents(string: url) else {
            throw APIError.invalidURL
        }
        
        var _query: [URLQueryItem] = [
            .init(name: "key", value: ProcessInfo.processInfo.environment["API_KEY"])
        ]
        
        if let query = query {
            _query.append(contentsOf: query)
        }
        
        urlComponents.queryItems = _query
        
        guard let finalURL = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: finalURL)
        request.method = method
        
        if let headers = headers {
            request.headers = headers
        }
        
        if let parameters = parameters, method != .get {
            do {
                let encodedParameters = try JSONEncoder().encode(parameters)
                request.httpBody = encodedParameters
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw error
            }
        }
        
        let response = await AF.request(request).validate().serializingDecodable(T.self).response
        
        switch response.result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
    
    func performRequest<T: Codable>(
        url: String,
        method: HTTPMethod,
        query: [URLQueryItem]? = nil,
        headers: HTTPHeaders? = nil
    ) async throws -> T {
        guard var urlComponents = URLComponents(string: url) else {
            throw APIError.invalidURL
        }
        
        var _query: [URLQueryItem] = [
            .init(name: "key", value: ProcessInfo.processInfo.environment["API_KEY"])
        ]
        
        if let query = query {
            _query.append(contentsOf: query)
        }
        
        urlComponents.queryItems = _query
        
        guard let finalURL = urlComponents.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: finalURL)
        request.method = method
        
        if let headers = headers {
            request.headers = headers
        }
        
        let response = await AF.request(request).validate().serializingDecodable(T.self).response
        
        switch response.result {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}

// MARK: - APIError
enum APIError: Error {
    case invalidURL
}
