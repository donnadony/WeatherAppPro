import Foundation

//
//  DomainError.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


/// Domain-level errors - independent of any framework or external service
enum DomainError: Error, Equatable {
    case networkUnavailable
    case invalidLocation
    case invalidDate
    case locationNotFound
    case cacheMiss
    case unknown(String)
    
    var localizedDescription: String {
        switch self {
        case .networkUnavailable:
            return "No internet connection. Showing cached data."
        case .invalidLocation:
            return "The location provided is invalid."
        case .invalidDate:
            return "The date provided is invalid."
        case .locationNotFound:
            return "Location not found."
        case .cacheMiss:
            return "No cached data available."
        case .unknown(let message):
            return message
        }
    }
}

/// Result wrapper for domain operations
enum Result<T> {
    case success(T)
    case failure(DomainError)
    
    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
    
    var value: T? {
        if case .success(let v) = self { return v }
        return nil
    }
    
    var error: DomainError? {
        if case .failure(let e) = self { return e }
        return nil
    }
}