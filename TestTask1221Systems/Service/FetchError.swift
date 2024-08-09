//
//  FetchError.swift
//  TestTask1221Systems
//
//  Created by Zorin Dmitrii on 08.08.2024.
//

import Foundation

enum FetchProductsError: Error {
    case wrongURL
}

extension FetchProductsError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
            case .wrongURL: return "An error occurred while accessing the server"
        }
    }
}
