//
//  TableViewController.swift
//  SwiftStretchHeaderEffect
//
//  Created by AlexanderChen on 2019/8/7.
//  Copyright © 2019 AlexanderChen. All rights reserved.
//

import UIKit

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var headerView : UIView!
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
        
        avatarImage.layer.cornerRadius = 10.0
        avatarImage.layer.borderColor = UIColor.white.cgColor
        avatarImage.layer.borderWidth = 3.0

            
        navBarBgAlpha = 0
        navBarTitleColor = .clear
        navBarBgColor = .clear
        isHiddenShadowImage = true
        
        tableView.contentInset.top = headerView.frame.height

    }

}


extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "Test Cell"
        return cell
    }
        
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        debugPrint("scrollView.contentOffset.y: \(scrollView.contentOffset.y)")

//        let offset = scrollView.contentOffset.y
        let offset = scrollView.contentOffset.y + headerView.bounds.height //多加headerView的height是因為tableView的contentInset top並不是0，所以在Scroll的時候起始位置還是從0開始scrollView contentOffset y與內容物起始點的位置不同，才導致動畫會很不順暢

        var headerTransform = CATransform3DIdentity
        var avatarTransform = CATransform3DIdentity

        // PULL DOWN
        if offset < 0 {

            let headerScaleFactor:CGFloat = -(offset) / headerView.bounds.height
            let headerSizevariation = ((headerView.bounds.height * (1.0 + headerScaleFactor)) - headerView.bounds.height)/2.0

//            debugPrint("headerScaleFactor:\(headerScaleFactor))")
//            debugPrint("headerSizevariation:\(headerSizevariation))")

            headerTransform = CATransform3DTranslate(headerTransform, 0, headerSizevariation, 0)
            headerTransform = CATransform3DScale(headerTransform, 1.0 + headerScaleFactor, 1.0 + headerScaleFactor, 0)

            // Hide views if scrolled super fast
            headerView.layer.zPosition = 0

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
