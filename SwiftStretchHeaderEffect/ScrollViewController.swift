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
    @IBOutlet var avatarImage:UIImageView!
    
    var offsetHeaderStop:CGFloat = 0 //Header上推到多少高度停止

    
    @IBOutlet var headerView:UIView!
    @IBOutlet var headerImageView:UIImageView!
    @IBOutlet var headerColorView:UIView!
    var headerColorViewAlpha: CGFloat? = 0.0
    
    @IBOutlet var closeButton:UIButton!
    var hasNavigationController: Bool? = false

    

    override func viewDidLoad() {
        super.viewDidLoad()

        offsetHeaderStop = headerView.frame.height - 64 // 64為HeaderView上推後的高度
        
        avatarImage.layer.cornerRadius = 10.0
        avatarImage.layer.borderColor = UIColor.white.cgColor
        avatarImage.layer.borderWidth = 3.0
        
//        if let viewControllers = self.navigationController?.viewControllers {
//            debugPrint("is navigationController")
//            closeButton.isHidden = true
//            hasNavigationController = true
//
//
//            navBarBgAlpha = 0
//            navBarTitleColor = .clear
//            isHiddenShadowImage = true
//        } else {
//            debugPrint("not navigationController")
//        }


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let viewControllers = self.navigationController?.viewControllers {
            debugPrint("is navigationController")
//            hasNavigationController = true
            closeButton.isHidden = true


            navBarBgAlpha = 1
            navBarTitleColor = .clear
            isHiddenShadowImage = true
//            navBarBgColor = .orange


        } else {
            debugPrint("not navigationController")
            hasNavigationController = false

        }


    }
    
    @IBAction func closePageHandler(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ScrollViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        var avatarTransform = CATransform3DIdentity
        var headerTransform = CATransform3DIdentity

        // PULL DOWN
        if offset < 0 {

            let headerScaleFactor:CGFloat = -(offset) / headerView.bounds.height
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height)/2.0
            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)

            // Hide views if scrolled super fast
//            headerView.layer.transform = headerTransform
//            headerView.layer.zPosition = 0

            if headerColorViewAlpha != 0 {
                headerColorView?.alpha = 0
            }

        } else { // SCROLL UP/DOWN ------------


            // Header View -----------
            headerTransform = CATransform3DTranslate(headerTransform, 0, max(-offsetHeaderStop, -offset), 0)

            // Header Color View -----------
            headerColorViewAlpha = offset / offsetHeaderStop

            if let headerColorAlpha = headerColorViewAlpha {
                headerColorView?.alpha = min (1.0, (headerColorAlpha))
            }


            //大頭照 -----------
            let avatarScaleFactor = (min(offsetHeaderStop, offset)) / avatarImage.bounds.height / 1.4 // Slow down the animation
            let avatarSizeVariation = ((avatarImage.bounds.height * (1.0 + avatarScaleFactor)) - avatarImage.bounds.height) / 2.0
            avatarTransform = CATransform3DTranslate(avatarTransform, 0, avatarSizeVariation, 0)
            avatarTransform = CATransform3DScale(avatarTransform, 1.0 - avatarScaleFactor, 1.0 - avatarScaleFactor, 0)

            // headerView 和 avatarImage 的 z-position 位置調動
            if offset <= offsetHeaderStop {
                if avatarImage.layer.zPosition < headerView.layer.zPosition{
                    headerView.layer.zPosition = 0
//                    navBarBgAlpha = 0
//                    navBarTitleColor = .clear

                }

            }else if avatarImage.layer.zPosition >= headerView.layer.zPosition {
                    headerView.layer.zPosition = 2
//                navBarBgAlpha = 1
//                navBarTitleColor = UIColor(r: 102, g: 102, b: 102)

            }
        }

        // Apply Transformations
        headerView.layer.transform = headerTransform
        avatarImage.layer.transform = avatarTransform

    }
}
