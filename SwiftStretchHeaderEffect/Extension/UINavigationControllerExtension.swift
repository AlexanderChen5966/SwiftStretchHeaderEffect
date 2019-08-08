//
//  UINavigationExtendsion.swift
//  BrandApp
//
//  Created by Bobson on 2015/12/30.
//  Copyright © 2015年 Sonet. All rights reserved.
//

import UIKit


// MARK: - UINavigationController Customize Function
extension UINavigationController {
    
    /// 設定透明度
    fileprivate func navBarBackgroundAlpha(_ alpha: CGFloat) {
        navigationBar.backgroundAlpha(alpha)
    }
    
    /// 設定背景色
    fileprivate func navBarBackgroundColor(_ color: UIColor) {
        navigationBar.backgroundColor(color)
    }
    
    /// 設定 Tint color
    fileprivate func navBarTintColor(_ color: UIColor) {
        navigationBar.tintColor(color)
    }
    
    /// 設定 title 的顏色
    fileprivate func navBarTitleColor(_ color: UIColor) {
        navigationBar.titleColor(color)
    }
    
    /// 隱藏或顯示分割線
    fileprivate func shadowImageHide(_ hide: Bool) {
        navigationBar.shadowImage(hide)
    }
    
    private func updateAllStyle(_ viewController: UIViewController) {
        navBarBackgroundAlpha(viewController.navBarBgAlpha)
        navBarBackgroundColor(viewController.navBarBgColor)
        navBarTintColor(viewController.navBarTintColor)
        shadowImageHide(viewController.isHiddenShadowImage)
    }
    
    // 計算兩個View Controller Navigation Bar顏色的過度
    private func averageColor(fromColor: UIColor, toColor: UIColor, percent: CGFloat) -> UIColor {
        var fromRed: CGFloat = 0
        var fromGreen: CGFloat = 0
        var fromBlue: CGFloat = 0
        var fromAlpha: CGFloat = 0
        fromColor.getRed(&fromRed, green: &fromGreen, blue: &fromBlue, alpha: &fromAlpha)
        
        var toRed: CGFloat = 0
        var toGreen: CGFloat = 0
        var toBlue: CGFloat = 0
        var toAlpha: CGFloat = 0
        toColor.getRed(&toRed, green: &toGreen, blue: &toBlue, alpha: &toAlpha)
        
        let nowRed = fromRed + (toRed - fromRed) * percent
        let nowGreen = fromGreen + (toGreen - fromGreen) * percent
        let nowBlue = fromBlue + (toBlue - fromBlue) * percent
        let nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percent
        
        return UIColor(red: nowRed, green: nowGreen, blue: nowBlue, alpha: nowAlpha)
    }
}


// MARK: - UINavigationBarDelegate 邊緣返回手勢鬆手時的監控
extension UINavigationController: UINavigationBarDelegate {
    
    /// pop
    public func navigationBar(_ navigationBar: UINavigationBar,
                              shouldPop item: UINavigationItem) -> Bool {
        
        if let topVC = topViewController,
            let coor = topVC.transitionCoordinator,
            coor.initiallyInteractive {
            
            if #available(iOS 10.0, *) {
                coor.notifyWhenInteractionChanges({ (context) in
                    self.dealInteractionChanges(context)
                })
            } else {
                coor.notifyWhenInteractionEnds({ (context) in
                    self.dealInteractionChanges(context)
                })
            }
            return true
        }
        
        let itemCount = navigationBar.items?.count ?? 0
        let n = viewControllers.count >= itemCount ? 2 : 1
        let popToVC = viewControllers[viewControllers.count - n]
        
        popToViewController(popToVC, animated: true)
        return true
    }
    
    /// push 到新的頁面
    public func navigationBar(_ navigationBar: UINavigationBar,
                              shouldPush item: UINavigationItem) -> Bool {
        
        if let vc = topViewController {
            updateAllStyle(vc)
        }
        return true
    }
    
    /// 處理返回手勢中斷的情況
    private func dealInteractionChanges(_ context: UIViewControllerTransitionCoordinatorContext) {
        /// 設定動畫
        let animations: (UITransitionContextViewControllerKey) -> () = { [weak self] in
            if let vc = context.viewController(forKey: $0) {
                self?.updateAllStyle(vc)
            }
        }
        
        if context.isCancelled {
            /// 手勢取消
            let cancelDuration: TimeInterval = context.transitionDuration * Double(context.percentComplete)
            //            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: cancelDuration, delay: 0, options: [], animations: {
            //                animations(.from)
            //            }, completion: nil)
            
            UIView.animate(withDuration: cancelDuration) {
                animations(.from)
            }
        } else {
            /// 手勢完成
            let finishDuration: TimeInterval = context.transitionDuration * Double(1 - context.percentComplete)
            //            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: finishDuration, delay: 0, options: [], animations: {
            //                animations(.to)
            //            }, completion: nil)
            
            UIView.animate(withDuration: finishDuration) {
                animations(.to)
            }
        }
    }
}

// MARK: - UINavigationBar
extension UINavigationBar {
    
    fileprivate struct DefaultValue {
        static var backgroundView: UIView = UIView()
        static var backgroundImageView: UIImageView = UIImageView()
        static var statusBarStyle: UIStatusBarStyle = .default
    }
    
    /// Navigation Bar背景視圖
    fileprivate var backgroundView: UIView? {
        get {
            guard let bgView = objc_getAssociatedObject(self, &DefaultValue.backgroundView) as? UIView else {
                return nil
            }
            return bgView
        }
        set {
            objc_setAssociatedObject(self, &DefaultValue.backgroundView, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 設定Navigation Bar的透明度
    fileprivate func backgroundAlpha(_ alpha: CGFloat) {
        
        if let barBackgroundView = subviews.first {
            if #available(iOS 11.0, *) {
                for view in barBackgroundView.subviews
                    where !view.isKind(of: UIImageView.self) {
                        
                        view.alpha = alpha
                }
            } else {
                barBackgroundView.alpha = alpha
            }
        }
    }
    
    /// 設定Navigation Bar背景色
    fileprivate func backgroundColor(_ color: UIColor) {
        
        if backgroundView == nil {
            // 添加一个透明背景的 image 到 _UIBarBackground
            setBackgroundImage(UIImage(), for: .default)
            let height = UIApplication.shared.statusBarFrame.size.height + self.frame.height
            backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: Int(bounds.width), height: Int(height)))
            //            let height = Device == .iPhoneX ? 88 : 64
            //        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: Int(bounds.width), height: 64))
            backgroundView?.autoresizingMask = .flexibleWidth
            // _UIBarBackground 是 navigationBar 的第一個子視圖
            subviews.first?.insertSubview(backgroundView ?? UIView(), at: 0)
        }
        backgroundView?.backgroundColor = color
    }
    
    /// 設定 tint color
    fileprivate func tintColor(_ color: UIColor) {
        tintColor = color
    }
    
    /// 設定 title 的顏色
    fileprivate func titleColor(_ color: UIColor) {
        guard titleTextAttributes != nil else {
            titleTextAttributes = [.foregroundColor: color]
            
            return
        }
        titleTextAttributes?.updateValue(color, forKey: .foregroundColor)
    }
    
    /// 隱藏或顯示分割線
    fileprivate func shadowImage(_ hide: Bool) {
        shadowImage = hide ? UIImage() : nil
    }
}

//MARK: 修改 Navigation Bar 屬性使用
extension UIViewController {
    
    private struct DefaultValue {
        static var navBarBgAlpha: CGFloat = 1.0
        static var navBarBgColor: UIColor = .white
        
//        static var navBarTintColor: UIColor = UIColor(r: 148, g: 31, b: 150)
        static var navBarTintColor: UIColor = .white
        static var navBarTitleColor: UIColor = UIColor(r: 102, g: 102, b: 102)
        static var statusBarStyle: UIStatusBarStyle = .default
        static var isHiddenShadowImage: Bool = false
        
    }
    
    /// 設定Navigation Bar背景透明度
    public var navBarBgAlpha: CGFloat {
        get {
            if let alpha = objc_getAssociatedObject(self, &DefaultValue.navBarBgAlpha) as? CGFloat {
                return alpha
            }
            return DefaultValue.navBarBgAlpha
        }
        set {
            let alpha = max(min(newValue, 1), 0)
            objc_setAssociatedObject(self, &DefaultValue.navBarBgAlpha, alpha, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            //設定Navigation Bar透明度
            navigationController?.navBarBackgroundAlpha(alpha)
        }
    }
    
    /// 設定Navigation Bar的背景顏色
    public var navBarBgColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &DefaultValue.navBarBgColor) as? UIColor {
                return color
            }
            return DefaultValue.navBarBgColor
        }
        set {
            objc_setAssociatedObject(self, &DefaultValue.navBarBgColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            navigationController?.navBarBackgroundColor(newValue)
        }
    }
    
    /// 設定 tint color
    public var navBarTintColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &DefaultValue.navBarTintColor) as? UIColor {
                return color
            }
            return DefaultValue.navBarTintColor
        }
        set {
            objc_setAssociatedObject(self, &DefaultValue.navBarTintColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            navigationController?.navBarTintColor(newValue)
        }
    }
    
    /// 設定 title 的顏色
    public var navBarTitleColor: UIColor {
        get {
            if let color = objc_getAssociatedObject(self, &DefaultValue.navBarTitleColor) as? UIColor {
                return color
            }
            return DefaultValue.navBarTitleColor
        }
        set {
            objc_setAssociatedObject(self, &DefaultValue.navBarTitleColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            navigationController?.navBarTitleColor(newValue)
        }
    }
    
    /// 設定 status bar 的狀態
    public var statusBarStyle: UIStatusBarStyle {
        get {
            if let style = objc_getAssociatedObject(self, &DefaultValue.statusBarStyle) as? UIStatusBarStyle {
                return style
            }
            return DefaultValue.statusBarStyle
        }
        set {
            objc_setAssociatedObject(self, &DefaultValue.statusBarStyle, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    /// 隱藏或顯示分割線
    public var isHiddenShadowImage: Bool {
        get {
            if let isHide = objc_getAssociatedObject(self, &DefaultValue.isHiddenShadowImage) as? Bool {
                return isHide
            }
            return DefaultValue.isHiddenShadowImage
        }
        set {
            objc_setAssociatedObject(self, &DefaultValue.isHiddenShadowImage, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            navigationController?.shadowImageHide(newValue)
        }
    }
}

// MARK: - UINavigationController Swizzle Function
extension UINavigationController: SelfAware {
    
    /// 設定 status bar style
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.statusBarStyle ?? .default
    }
    
    static func awake() {
        /// 判斷是否為其子類別
        guard self !== UINavigationController.self else { return }
        self.swizzle
    }
    
    /**
     * Swift 中 static let 具備 dispatch once 特性，所以可以用這種方式宣告，
     * 閉包的形式宣告一個程式碼區塊，默認懶加載(Lazy Load)
     * 類似 Objective-C 中的 dispatch once
     */
    private static let swizzle: () = {
        let needSwizzleSelectorAry = [
            NSSelectorFromString("_updateInteractiveTransition:"),
            #selector(popToViewController(_:animated:)),
            #selector(popToRootViewController(animated:))
        ]
        let swizzleSelectorAry = [
            #selector(em_updateInteractiveTransition(_:)),
            #selector(em_popToViewController(_:animated:)),
            #selector(em_popToRootViewControllerAnimated(_:))
        ]
        for sel in needSwizzleSelectorAry {
            let str = ("em_" + sel.description).replacingOccurrences(of: "__", with: "_")
            if let originMethod = class_getInstanceMethod(UINavigationController.self, sel),
                let swizzleMethod = class_getInstanceMethod(UINavigationController.self, Selector(str)) {
                
                method_exchangeImplementations(originMethod, swizzleMethod)
            }
        }
    }()
    
    /// 用於替換系統的 _updateInteractiveTransition: 方法，監聽返回手勢進度
    @objc func em_updateInteractiveTransition(_ percentComplete: CGFloat) {
        /// transitionCoordinator 帶有兩個 View Controller的轉場Context
        if let coor = self.topViewController?.transitionCoordinator,
            let fromVC = coor.viewController(forKey: .from),
            let toVC = coor.viewController(forKey: .to) {
            
            let fromAlpha = fromVC.navBarBgAlpha
            let toAlpha = toVC.navBarBgAlpha
            let nowAlpha = fromAlpha + (toAlpha - fromAlpha) * percentComplete
            self.navBarBackgroundAlpha(nowAlpha)
            
            let fromTintColor = fromVC.navBarTintColor
            let toTintColor = toVC.navBarTintColor
            let nowTintColor = averageColor(fromColor: fromTintColor, toColor: toTintColor, percent: percentComplete)
            self.navBarTintColor(nowTintColor)
            
            let fromColor = fromVC.navBarBgColor
            let toColor = toVC.navBarBgColor
            let nowColor = averageColor(fromColor: fromColor, toColor: toColor, percent: percentComplete)
            self.navBarBackgroundColor(nowColor)
        }
        em_updateInteractiveTransition(percentComplete)
    }
    
    /// 替換系統的 pop
    @objc func em_popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        updateAllStyle(viewController)
        navBarTitleColor(viewController.navBarTitleColor)
        return em_popToViewController(viewController, animated: animated)
    }
    
    /// 替換系統的 pop to root
    @objc func em_popToRootViewControllerAnimated(_ animated: Bool) -> [UIViewController]? {
        if let vc = viewControllers.first {
            updateAllStyle(vc)
            navBarTitleColor(vc.navBarTitleColor)
        }
        return em_popToRootViewControllerAnimated(animated)
    }
}




/**
 * 替代 Objective-C 中的 +load() 方法
 * 替代 Swift 之前版本中的 initialize() 方法
 * 透過 runtime 取得到所有類別的列表，
 * 然後向所有諄遵循 SelfAware Protocol的ㄋ類別發送消息，並且把這些操作放到 UIApplication 的 next 屬性的調用中，
 * 同時 next 屬性下會在 applicationDidFinishLaunching 之前被調用。
 */
private protocol SelfAware: class {
    static func awake()
}

private class NothingToSeeHere {
    
    static func harmlessFunction() {
        
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass?>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0..<typeCount { (types[index] as? SelfAware.Type)?.awake() }
        types.deallocate()
    }
}

extension UIApplication {
    
    /// 啟動只執行一次
    private static let runOnce: Void = {
        NothingToSeeHere.harmlessFunction()
    }()
    
    override open var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        UIApplication.runOnce
        return super.next
    }
}
