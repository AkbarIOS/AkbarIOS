//
//  ErrorResponsing.swift
//  MapApplication
//
//  Created by Akbar on 27/09/21.
//

import Foundation

public protocol ErrorResponsing {
    var meta:Meta? { get }
}

public struct Meta: Codable {
    var code: Int?
    var requestId: String?
}
