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
	private var actualText:String = ""
	private var menuIndex:Int = 0
		
	override init()
		{
		super.init()
		labelItem.text = "text"
		labelItem.layoutFrame = LayoutFrame(leftRatio:0,leftOffset:16,topRatio:0,topOffset:0,rightRatio:1,rightOffset:-16,bottomRatio:1,bottomOffset:0)
		addSublayer(labelItem)
		markForLayout()
		markForDisplay()
		self.backgroundColor = NSColor.redColor().CGColor
		self.styling = UFXStylist.menuItemStyle()
		}

	override func hitTest(point:CGPoint) -> CALayer?
		{
		if CGRectContainsPoint(self.frame,point)
			{
			return(self)
			}
		return(nil)
		}
		
	required init(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
		labelItem = aDecoder.decodeObjectForKey("labelItem") as! VisualText
		}
		
	override func setIndex(index:Int)
		{
		menuIndex = index
		labelItem.text = displayText
		}
		
	var text:String
		{
		get
			{
			return(actualText)
			}
		set
			{
			actualText = newValue
			labelItem.text = displayText
			}
		}
		
	var displayText:String
		{
		get
			{
			return("\(menuIndex).\(actualText)")
			}
		}
		
	override func desiredSizeInFrame(frame:CGRect) -> CGSize
		{
		var revisedFrame = frame
		revisedFrame.size.width -= 32
		var aSize = labelItem.desiredSizeInFrame(revisedFrame)
		aSize.width += 32
		aSize.height = maximum(aSize.height,16)
		return(aSize)
		}
		
	override func applyStyling()
		{
		labelItem.styling = self.styling
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