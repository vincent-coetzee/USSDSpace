//
//  TextHelper.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit

class TextHelper
	{
	static func heightOfString(string:String,forWidth:CGFloat,withFont:NSFont) -> CGFloat
		{
		var textStorage = NSTextStorage(string: string)
		var textContainer = NSTextContainer(containerSize: NSSize(width:forWidth,height:CGFloat(FLT_MAX)))
		var layoutManager = NSLayoutManager()
		layoutManager.addTextContainer(textContainer)
		textStorage.addLayoutManager(layoutManager)
		textStorage.addAttribute(NSFontAttributeName,value:withFont,range:NSRange(location: 0,length: textStorage.length))
		textContainer.lineFragmentPadding = 0.0
		layoutManager.glyphRangeForTextContainer(textContainer)
		return(layoutManager.usedRectForTextContainer(textContainer).size.height)
		}
	}