//
//  Extensions.swift
//  Spotify
//
//  Created by Justin Viasus on 8/2/21.
//

import Foundation
import UIKit

// allows us to use abbreviations when working with frames, making life easier.
extension UIView {
    // width of a frame
    var width: CGFloat {
        return frame.size.width
    }
    
    // height of a frame
    var height: CGFloat {
        return frame.size.height
    }
    
    // left of a frame
    var left: CGFloat {
        return frame.origin.x
    }
    
    // right of a frame
    var right: CGFloat {
        return left + width
    }
    
    // top of a frame
    var top: CGFloat {
        return frame.origin.y
    }
    
    // bottom of a frame
    var bottom: CGFloat {
        return top + height
    }
}
