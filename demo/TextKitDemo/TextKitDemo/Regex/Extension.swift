//
//  Extension.swift
//  TextKitDemo
//
//  Created by 张思槐 on 2018/3/5.
//  Copyright © 2018年 zhangsihuai. All rights reserved.
//

import Foundation

extension String {
    var range: NSRange {
        return NSMakeRange(0, self.utf16.count)
    }
    
    func range(from range: NSRange) -> Range<String.Index>? {
        // 来源：https://www.raywenderlich.com/153591/core-text-tutorial-ios-making-magazine-app
        guard let from16 = utf16.index(utf16.startIndex,
                                       offsetBy: range.location,
                                       limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) else {
                return nil
        }
        
        return from ..< to
    }
}
