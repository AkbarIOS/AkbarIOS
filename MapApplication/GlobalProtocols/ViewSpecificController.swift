//
//  ViewSpecificController.swift
//  MapApplication
//
//  Created by Akbar on 27/09/21.
//

import UIKit

protocol ViewSpecificController {
    associatedtype RootView: UIView
}

extension ViewSpecificController where Self: UIViewController {
    func view() -> RootView {
        return self.view as! RootView
    }
}
