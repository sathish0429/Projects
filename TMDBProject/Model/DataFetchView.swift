//
//  DataFetchView.swift
//  TMDBProject
//
//  Created by SATHISH KUMAR on 09/01/24.
//

import SwiftUI

enum DataFetchPhase<V> {
    
    case empty
    case success(V)
    case failure(Error)
    
    var value: V? {
        if case .success(let value) = self {
            return value
        }
        return nil
    }
    
}
