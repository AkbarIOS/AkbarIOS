//
//  APIData.swift
//  MapApplication
//
//  Created by Akbar on 27/09/21.
//

import Foundation

public typealias APIData = (Codable & ErrorResponsing)
public enum APIResponse<Value> {
    case success(Value?), failure(ErrorResponse)
}
