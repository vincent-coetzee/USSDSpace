//
//  StringExtensions.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/21.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit

extension String
	{
	var cleanString:String
		{
		get
			{
			var newString:String
			
			newString = self.stringByReplacingOccurrencesOfString("\n",withString:"\\n")
			newString = newString.stringByReplacingOccurrencesOfString("\r",withString:"\\r")
			newString = newString.stringByReplacingOccurrencesOfString("\t",withString:"\\t")
			return(newString)
			}
		}
		
	func widthWithFont(font:NSFont) -> CGFloat
		{
		let textStorage = NSTextStorage(string: self)
		let textContainer = NSTextContainer(containerSize: NSSize(width:CGFloat(FLT_MAX),height:CGFloat(FLT_MAX)))
		let layoutManager = NSLayoutManager()
		layoutManager.addTextContainer(textContainer)
		textStorage.addLayoutManager(layoutManager)
		textStorage.addAttribute(NSFontAttributeName,value:font,range:NSRange(location: 0,length: textStorage.length))
		textContainer.lineFragmentPadding = 0.0
		layoutManager.glyphRangeForTextContainer(textContainer)
		return(layoutManager.usedRectForTextContainer(textContainer).size.width)
		}
		
	func heightInWidth(inWidth:CGFloat,withFont:NSFont) -> CGFloat
		{
		let textStorage = NSTextStorage(string: self)
		let textContainer = NSTextContainer(containerSize: NSSize(width:inWidth,height:CGFloat(FLT_MAX)))
		let layoutManager = NSLayoutManager()
		layoutManager.addTextContainer(textContainer)
		textStorage.addLayoutManager(layoutManager)
		textStorage.addAttribute(NSFontAttributeName,value:withFont,range:NSRange(location: 0,length: textStorage.length))
		textContainer.lineFragmentPadding = 0.0
		layoutManager.glyphRangeForTextContainer(textContainer)
		return(layoutManager.usedRectForTextContainer(textContainer).size.height)
		}
	}