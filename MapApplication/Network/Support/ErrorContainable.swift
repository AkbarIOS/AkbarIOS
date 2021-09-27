//
//  ErrorContainable.swift
//  MapApplication
//
//  Created by Akbar on 27/09/21.
//

import Foundation
import RxSwift

public protocol ErrorContainable {
    var error: PublishSubject<ErrorResponse> { get }
}
