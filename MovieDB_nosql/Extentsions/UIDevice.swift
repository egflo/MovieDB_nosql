//
//  UIDevice.swift
//  MovieDB_nosql
//
//

import Foundation
import UIKit

extension UIDevice {
    static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    static var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}
