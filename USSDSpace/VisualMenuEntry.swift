//
//  VisualMenuEntry.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/26.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class VisualMenuEntry:VisualItem
	{
	internal var labelItem:VisualText = VisualText()
	
	override init()
		{
		super.init()
		labelItem.text = "text"
		labelItem.layoutFrame = LayoutFrame(leftRatio:0,leftOffset:16,topRatio:0,topOffset:0,rightRatio:1,rightOffset:-16,bottomRatio:1,bottomOffset:0)
		addSublayer(labelItem)
		markForLayout()
		markForDisplay()
		self.backgroundColor = NSColor.redColor().CGColor
		}

	required init(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
		labelItem = aDecoder.decodeObjectForKey("labelItem") as! VisualText
		}
		
	var text:String
		{
		get
			{
			return(labelItem.text)
			}
		set
			{
			labelItem.text = newValue
			}
		}
		
	override func desiredSizeInFrame(frame:CGRect) -> CGSize
		{
		var revisedFrame = frame
		revisedFrame.size.width -= 32
		var aSize = labelItem.desiredSizeInFrame(revisedFrame)
		aSize.width += 32
		return(aSize)
		}
		
	override var style:[NSObject:AnyObject]!
		{
		get
			{
			return(super.style)
			}
		set
			{
			super.style = newValue
			labelItem.style = newValue
			}
		}
		
	override func drawInContext(context:CGContext)
		{
		CGContextSaveGState(context)
		CGContextSetGrayStrokeColor(context,0.4,1.0)
		CGContextSetLineWidth(context,1)
		CGContextBeginPath(context)
		CGContextMoveToPoint(context,0,0)
		CGContextAddLineToPoint(context,CGRectGetMaxX(self.bounds),0)
		CGContextMoveToPoint(context,0,CGRectGetMaxY(self.bounds))
		CGContextMoveToPoint(context,CGRectGetMaxX(self.bounds),CGRectGetMaxY(self.bounds))
		CGContextStrokePath(context)
		}
	}