//
//  RegexSearcher.swift
//  TextKitDemo
//
//  Created by 张思槐 on 2018/3/5.
//  Copyright © 2018年 zhangsihuai. All rights reserved.
//

import Foundation

protocol RegexSearcher {
    func search(in content: String) -> [NSTextCheckingResult]
}

protocol StringRegexSearcher: RegexSearcher {
    var pattern: String { get }
}

extension StringRegexSearcher {
    func search(in content: String) -> [NSTextCheckingResult] {
        
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let checkingResults = regex.matches(in: content, options: [], range: content.range)
        return checkingResults
        
    }
}

struct TopicRegexSearcher: StringRegexSearcher {
    let pattern: String = "#[^#]+#"
}

struct AtRegexSearcher: StringRegexSearcher {
    let pattern: String = "@.+"
}

struct LinkDataDetector: RegexSearcher {
    var dataDetector = try! NSDataDetector(types: NSTextCheckingTypes(NSTextCheckingResult.CheckingType.link.rawValue))
    
    func search(in content: String) -> [NSTextCheckingResult] {
        
        let checkingResults = dataDetector.matches(in: content, options: [], range: content.range)
        return checkingResults
    }
}


