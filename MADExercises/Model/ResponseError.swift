//
//  ResponseError.swift
//  MADExercises
//
//

import Foundation

struct ResponseError: Codable {
    let error: InlineError
    
    struct InlineError: Codable {
        let code: Int
        let message: String
        let errors: [ErrorItem]
    }
    
    struct ErrorItem: Codable {
        let message: String
        let domain: String
        let reason: String
    }
    
    func getNetworkingError() -> NetworkingError {
        switch error.message {
        case "INVALID_EMAIL": return .invalidEmail
        case "EMAIL_NOT_FOUND": return .emailNotFound
        case "INVALID_PASSWORD": return .wrongPassword
        case "INVALID_LOGIN_CREDENTIALS": return .invalidCredentials
        default: return .unexpectedError
        }
    }
}
