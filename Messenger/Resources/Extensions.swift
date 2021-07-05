//
//  Extensions.swift
//  Messenger
//
//  Created by Oybek on 7/5/21.
//

import UIKit

extension UIView {
    public var width: CGFloat {
        return self.frame.width
    }
    public var height: CGFloat {
        return self.frame.height
    }
    public var top: CGFloat {
        return self.frame.origin.y
    }
    public var bottom: CGFloat {
        return self.frame.size.height + self.frame.origin.y
    }
    public var left: CGFloat {
        return self.frame.origin.x
    }
    public var right: CGFloat {
        return self.frame.size.width + self.frame.origin.x
    }
}
