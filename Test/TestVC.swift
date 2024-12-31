//
//  TestVC.swift
//  Test
//
//  Created by E35 PTW on 2024/3/28.
//

import UIKit

class TestVC: UIViewController {
   
    let dot1 = UIView()
    let dot2 = UIView()
    let dot3 = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupDots()
        startAnimatingDots()
    }
    
    func setupDots() {
        // 設置圓點的初始屬性
        let dotSize: CGFloat = 20.0
        let spacing: CGFloat = 30.0
        
        dot1.frame = CGRect(x: (view.frame.size.width - dotSize) / 2 - spacing, y: (view.frame.size.height - dotSize) / 2, width: dotSize, height: dotSize)
        dot2.frame = CGRect(x: (view.frame.size.width - dotSize) / 2, y: (view.frame.size.height - dotSize) / 2, width: dotSize, height: dotSize)
        dot3.frame = CGRect(x: (view.frame.size.width - dotSize) / 2 + spacing, y: (view.frame.size.height - dotSize) / 2, width: dotSize, height: dotSize)
        
        dot1.backgroundColor = .gray
        dot2.backgroundColor = .gray
        dot3.backgroundColor = .gray
        
        dot1.layer.cornerRadius = dotSize / 2
        dot2.layer.cornerRadius = dotSize / 2
        dot3.layer.cornerRadius = dotSize / 2
        
        view.addSubview(dot1)
        view.addSubview(dot2)
        view.addSubview(dot3)
    }
    
    func startAnimatingDots() {
        let duration: TimeInterval = 2
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.repeat, .autoreverse]) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/3) {
                self.dot1.alpha = 1.0
                self.dot2.alpha = 0.6
                self.dot3.alpha = 0.2
            }
            UIView.addKeyframe(withRelativeStartTime: 1/3, relativeDuration: 1/3) {
                self.dot1.alpha = 0.2
                self.dot2.alpha = 1.0
                self.dot3.alpha = 0.6
            }
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3) {
                self.dot1.alpha = 0.6
                self.dot2.alpha = 0.2
                self.dot3.alpha = 1.0
            }
        }
    }
}

#Preview {
    let vc = TestVC()
    return vc
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
