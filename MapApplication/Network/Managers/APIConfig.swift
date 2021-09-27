//
//  APIConfig.swift
//  MapApplication
//
//  Created by Akbar on 27/09/21.
//

import Foundation

//MARK: Development and Production APIS
public enum APIBase:String {
    case debug = "https://api.foursquare.com/v2/"
}

//MARK: Change API Here
public struct APIConfig {
    public static let base: APIBase = .debug
}
