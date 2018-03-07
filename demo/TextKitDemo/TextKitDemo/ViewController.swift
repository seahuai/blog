//
//  ViewController.swift
//  TextKitDemo
//
//  Created by 张思槐 on 2018/3/5.
//  Copyright © 2018年 zhangsihuai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var textView: UITextView! {
        didSet{
            textView.delegate = self
        }
    }
    // 需要强引用
    private var textStorage: SHTextStorage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textStorage = SHTextStorage()
        
        let layoutManager = NSLayoutManager()
        self.textStorage.addLayoutManager(layoutManager)
        
        let textContainer = NSTextContainer()
        layoutManager.addTextContainer(textContainer)
        
        let textView = UITextView(frame: self.view.bounds, textContainer: textContainer)
        textView.frame.origin = CGPoint(x: 0, y: 30)
        self.textView = textView
        
        self.view.addSubview(textView)
        
        let file = Bundle.main.path(forResource: "weibo", ofType: "txt")
        let text = try! String.init(contentsOfFile: file!)
        self.textStorage.replaceCharacters(in: NSMakeRange(0, 0), with: text)
        
        self.textView.isSelectable = true
        self.textView.isEditable = false
    }

}

extension ViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        /*
         Links in text views are interactive only if the text view is selectable but noneditable. That is, if the value of the UITextViewselectable property is YES and the editable property is NO.
         */
//        UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        return true
    }
    
}

