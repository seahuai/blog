//
//  SHTextView.swift
//  TextKitDemo
//
//  Created by 张思槐 on 2018/3/5.
//  Copyright © 2018年 zhangsihuai. All rights reserved.
//

import UIKit

class SHTextStorage: NSTextStorage {
    
    private var attributeString: NSMutableAttributedString!
    
    // 重写
    override var string: String {
        return attributeString.string
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedStringKey : Any] {
        return attributeString.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        attributeString.replaceCharacters(in: range, with: str)
        self.edited(NSTextStorageEditActions.editedCharacters, range: range, changeInLength: NSString(string: str).length - range.length)
    }
    
    
    override func setAttributes(_ attrs: [NSAttributedStringKey : Any]?, range: NSRange) {
        attributeString.setAttributes(attrs, range: range)
        self.edited(NSTextStorageEditActions.editedAttributes, range: range, changeInLength: 0)
    }
    
    override init() {
        super.init()
        attributeString = NSMutableAttributedString()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var linkSearcher: RegexSearcher = LinkDataDetector()
    lazy var topicSearcher: RegexSearcher = TopicRegexSearcher()
    lazy var atSearcher: RegexSearcher = AtRegexSearcher()
    
    override func processEditing() {
        
//        let editedRange = self.editedRange
        
        removeAttribute(NSAttributedStringKey.foregroundColor, range: self.string.range)
        
        // 匹配链接
        let linkResults = linkSearcher.search(in: self.string)
        for linkResult in linkResults {
            if let url = linkResult.url {
                let attrString = NSMutableAttributedString(string: "网页链接")
                attrString.addAttributes([NSAttributedStringKey.link : url], range: attrString.string.range)
                self.replaceCharacters(in: linkResult.range, with: attrString)
            }
        }
        
        // 匹配话题
        let topicResults = topicSearcher.search(in: self.string)
        for topicResult in topicResults {
            self.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: topicResult.range)
        }
        
        // 匹配@
        let atResults = atSearcher.search(in: self.string)
        for atResult in atResults {
            self.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: atResult.range)
        }
        
        super.processEditing()
    }
    
    
}
