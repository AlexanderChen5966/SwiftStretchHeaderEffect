//
//  ViewController.swift
//  SwiftStretchHeaderEffect
//
//  Created by AlexanderChen on 2019/8/7.
//  Copyright © 2019 AlexanderChen. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {
    
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var headerView:UIView!
    @IBOutlet var avatarImage:UIImageView!
    private var offsetHeaderStop:CGFloat = 0 //Header上推到多少高度停止

    override func viewDidLoad() {
        super.viewDidLoad()

        if navigationController != nil {
            let offsetGap = (navigationController?.navigationBar.frame.height)! + (UIApplication.shared.statusBarFrame.height) // navigationBar高度 (44或66)+ statusBar高度(22)
            offsetHeaderStop = headerView.frame.height - offsetGap

        }else {
            offsetHeaderStop = headerView.frame.height - 64 // 64為HeaderView上推後的高度
//        offsetHeaderStop = headerView.frame.height - 88 //如果是XS等有瀏海的機種改用88
        }

                

        navBarBgAlpha = 0
        navBarTitleColor = .clear
        navBarBgColor = .clear
        isHiddenShadowImage = true
        
        avatarImage.layer.cornerRadius = 10.0
        avatarImage.layer.borderColor = UIColor.white.cgColor
        avatarImage.layer.borderWidth = 3.0

    }

    
}

extension ScrollViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        debugPrint("scrollView.contentOffset.y: \(scrollView.contentOffset.y)")

//        let offset = scrollView.contentOffset.y + headerView.frame.height
        let offset = scrollView.contentOffset.y

        var headerTransform = CATransform3DIdentity
        var avatarTransform = CATransform3DIdentity

//        debugPrint("scrollView.contentOffset.y: \(scrollView.contentOffset.y)")

        // PULL DOWN
        if offset < 0 {
            
            let headerScaleFactor:CGFloat = -(offset) / headerView.bounds.height
//            debugPrint("headerScaleFactor:\(headerScaleFactor))")

            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height)/2.0

//            debugPrint("headerSizevariation:\(headerSizevariation))")

            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)
//            debugPrint("scrollView headerTransform:\(headerTransform))")
            
            
        } else { // SCROLL UP/DOWN ------------
            
            
            // Header View -----------
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offsetHeaderStop, -offset), 0)
            
            //大頭照 -----------
            let avatarScaleFactor = (min(offsetHeaderStop, offset)) / avatarImage.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((avatarImage.bounds.height * (1.0 + avatarScaleFactor)) - avatarImage.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)

            // headerView 和 avatarImage 的 z-position 位置調動
            if offset <= offsetHeaderStop {
                if avatarImage.layer.zPosition < headerView.layer.zPosition{
                    headerView.layer.zPosition = 0
                }

            }else if avatarImage.layer.zPosition >= headerView.layer.zPosition {
                headerView.layer.zPosition = 2
            }

        }
        
        // Apply Transformations
        headerView.layer.transform = headerTransform
        avatarImage.layer.transform = avatarTransform

    }
}
