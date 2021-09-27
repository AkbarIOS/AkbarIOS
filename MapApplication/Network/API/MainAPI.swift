//
//  MainAPI.swift
//  MapApplication
//
//  Created by Akbar on 27/09/21.
//

import Foundation
import Moya

enum MainAPI {
    case getPopularVenues(parameters: [String: Any])
}
extension MainAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string:APIConfig.base.rawValue ) else { fatalError("baseURL could not be configured") }
        return url
    }
    
    var path: String {
        switch self {
        case .getPopularVenues:
            return "venues/search"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case let .getPopularVenues(parameters):
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        let header: [String: String] = ["Accept": "application/json",
                                        "Content-Type": "application/json"]
        return header
    }
    
    
}
