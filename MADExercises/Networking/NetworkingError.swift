//
//  NetworkingError.swift
//  MADExercises
//
//

import Foundation

enum NetworkingError: Error {
    case serializationError
    case invalidEmail
    case emailNotFound
    case wrongPassword
    case invalidCredentials
    case networkUnavailable(String)
    case invalidResponse
    case unsuccessfulStatusCode(Int)
    case unexpectedError
}
