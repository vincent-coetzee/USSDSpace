//
//  NSAttributedStringExtensions.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/22.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit

extension NSAttributedString
	{
	func width() -> CGFloat
		{
		let textStorage = NSTextStorage(attributedString: self)
		let textContainer = NSTextContainer(containerSize: NSSize(width:CGFloat(FLT_MAX),height:CGFloat(FLT_MAX)))
		let layoutManager = NSLayoutManager()
		layoutManager.addTextContainer(textContainer)
		textStorage.addLayoutManager(layoutManager)
		textContainer.lineFragmentPadding = 0.0
		layoutManager.glyphRangeForTextContainer(textContainer)
		return(layoutManager.usedRectForTextContainer(textContainer).size.width)
		}
	}