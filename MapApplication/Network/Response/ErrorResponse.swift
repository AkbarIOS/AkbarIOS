//
//  ErrorResponse.swift
//  MapApplication
//
//  Created by Akbar on 27/09/21.
//

import Foundation
public struct ErrorResponse {
    
    public var reason: String
    public var errorType: ErrorResponseType?
    public var statusCode:Int
    public var code:Int
    
    public var name: String {
        switch self.errorType {
        case .internalServerError?:
            return "Ошибка подключения"
        default:
            return "Ошибка"
        }
    }
    
    public init (reason: String?, statusCode: Int?,code:Int?) {
        self.reason = reason ?? ""
        self.statusCode = statusCode ?? 400
        self.code = code ?? 0
        switch statusCode {
        case 500:
            self.errorType = .internalServerError(reason: "Произошла ошибка при подключении к серверу. Повторите попытку позже.")
        case 401:
            self.errorType = .defaultServerError(reason: "Token ustarel")
        default:
            self.errorType = .defaultServerError(reason: reason ?? "")
        }
    }
    
}

public enum ErrorResponseType: Error {
    case defaultServerError(reason: String?)
    case internalServerError(reason: String)
}
