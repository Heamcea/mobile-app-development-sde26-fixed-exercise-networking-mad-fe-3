//
//  User.swift
//  MADExercises
//
//

import Foundation

struct User: Codable {
    let kind: String
    let localId: String
    let email: String
    let displayName: String
    let idToken: String
    let registered: Bool
    let refreshToken: String
    let expiresIn: String
}
