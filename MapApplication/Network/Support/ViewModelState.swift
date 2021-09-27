//
//  ViewModelState.swift
//  MapApplication
//
//  Created by Akbar on 27/09/21.
//

import Foundation
public enum ViewModelState: Int {
    case initializing, ready, loading, loadComplete
    
    public var isAvailableForRequest: Bool {
        switch self {
        case .ready, .loadComplete:
            return true
        default:
            return false
        }
    }
}
