//
//  ErrorType.swift
//  picsum-photos
//
//  Created by Andrii Ponomarov on 08.12.2022.
//

import Foundation

enum ErrorType: Error {
    case missingData
    case networkError
}

extension ErrorType: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .missingData:
            return String(localized: "Missing a valid data")
        case .networkError:
            return String(localized: "Error fetching data over the network.")
        }
    }
    
}
