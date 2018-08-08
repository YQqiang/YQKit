//
//  UIResponder(YQ).swift
//  YQKit
//
//  Created by sungrow on 2018/8/8.
//  Copyright © 2018年 sungrow. All rights reserved.
//

import UIKit

extension UIResponder {
    
    /// UIView 调用时, 返回 View 所在的 ViewController;
    /// UIViewController 调用时, 返回 调用者
    ///
    /// 返回最近的ViewController
    var recentlyViewController: UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let vc = responder as? UIViewController {
                return vc
            } else {
                responder = responder?.next
            }
        }
        return nil
    }
}
