//
//  LayoutFrame.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/26.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class LayoutFrame:NSObject
	{
	var leftRatio:CGFloat
	var leftOffset:CGFloat
	var topRatio:CGFloat
	var topOffset:CGFloat
	var rightRatio:CGFloat
	var rightOffset:CGFloat
	var bottomRatio:CGFloat
	var bottomOffset:CGFloat
	
	override init()
		{
		leftRatio = 0
		leftOffset = 0
		topRatio = 0
		topOffset = 0
		rightRatio = 1
		rightOffset = 0
		bottomRatio = 1
		bottomOffset = 0
		super.init()
		}
		
	init(coder aDecoder:NSCoder)
		{
		leftRatio = CGFloat(aDecoder.decodeDoubleForKey("leftRatio"))
		leftOffset = CGFloat(aDecoder.decodeDoubleForKey("leftOffset"))
		topRatio = CGFloat(aDecoder.decodeDoubleForKey("topRatio"))
		topOffset = CGFloat(aDecoder.decodeDoubleForKey("topOffset"))
		rightRatio = CGFloat(aDecoder.decodeDoubleForKey("rightRatio"))
		rightOffset = CGFloat(aDecoder.decodeDoubleForKey("rightOffset"))
		bottomRatio = CGFloat(aDecoder.decodeDoubleForKey("bottomRatio"))
		bottomOffset = CGFloat(aDecoder.decodeDoubleForKey("bottomOffset"))
		}
		
	convenience init(leftRatio:CGFloat,leftOffset:CGFloat,topRatio:CGFloat,topOffset:CGFloat,rightRatio:CGFloat,rightOffset:CGFloat,bottomRatio:CGFloat,bottomOffset:CGFloat)
		{
		self.init()
		self.leftRatio = leftRatio
		self.leftOffset = leftOffset
		self.topRatio = topRatio
		self.topOffset = topOffset
		self.rightRatio = rightRatio
		self.rightOffset = rightOffset
		self.bottomRatio = bottomRatio
		self.bottomOffset = bottomOffset
		}
		
	func encodeWithCoder(coder:NSCoder)
		{
		coder.encodeDouble(Double(leftRatio),forKey:"leftRatio")
		coder.encodeDouble(Double(leftOffset),forKey:"leftOffset")
		coder.encodeDouble(Double(topRatio),forKey:"topRatio")
		coder.encodeDouble(Double(topOffset),forKey:"topOffset")
		coder.encodeDouble(Double(rightRatio),forKey:"rightRatio")
		coder.encodeDouble(Double(rightOffset),forKey:"rightOffset")
		coder.encodeDouble(Double(bottomRatio),forKey:"bottomRatio")
		coder.encodeDouble(Double(bottomOffset),forKey:"bottomOffset")
		}
		
	func rectInRect(rect:CGRect) -> CGRect
		{
		var originX:CGFloat
		var originY:CGFloat
		var extentX:CGFloat
		var extentY:CGFloat
		
		originX = CGRectGetMinX(rect) + leftRatio * rect.width + leftOffset
		originY = CGRectGetMinY(rect) + topRatio * rect.height + topOffset
		extentX = CGRectGetMinX(rect) + rightRatio * rect.width + rightOffset
		extentY = CGRectGetMinY(rect) + bottomRatio * rect.height + bottomOffset
		return(CGRect(x:originX,y:originY,width:extentX-originX,height:extentY-originY))
		}
	}