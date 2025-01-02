//
//  UIcolor+Ext.swift
//  Test
//
//  Created by E35 PTW on 2025/1/2.
//

import Foundation
import UIKit

extension UIColor {
    static var random: UIColor {
        return UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1.0)
    }
}
