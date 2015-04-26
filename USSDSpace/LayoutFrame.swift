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

class LayoutFrame
	{
	var leftRatio:CGFloat
	var leftOffset:CGFloat
	var topRatio:CGFloat
	var topOffset:CGFloat
	var rightRatio:CGFloat
	var rightOffset:CGFloat
	var bottomRatio:CGFloat
	var bottomOffset:CGFloat
	
	init()
		{
		leftRatio = 0
		leftOffset = 0
		topRatio = 0
		topOffset = 0
		rightRatio = 1
		rightOffset = 0
		bottomRatio = 1
		bottomOffset = 0
		}
		
	required init(coder:NSCoder)
		{
		leftRatio = CGFloat(coder.decodeDoubleForKey("leftRatio"))
		leftOffset = CGFloat(coder.decodeDoubleForKey("leftOffset"))
		topRatio = CGFloat(coder.decodeDoubleForKey("topRatio"))
		topOffset = CGFloat(coder.decodeDoubleForKey("topOffset"))
		rightRatio = CGFloat(coder.decodeDoubleForKey("rightRatio"))
		rightOffset = CGFloat(coder.decodeDoubleForKey("rightOffset"))
		bottomRatio = CGFloat(coder.decodeDoubleForKey("bottomRatio"))
		bottomOffset = CGFloat(coder.decodeDoubleForKey("bottomOffset"))
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
		coder.encodeDouble(Double(leftRatio),forKey:"topRatio")
		coder.encodeDouble(Double(leftOffset),forKey:"topOffset")
		coder.encodeDouble(Double(leftRatio),forKey:"rightRatio")
		coder.encodeDouble(Double(leftOffset),forKey:"rightOffset")
		coder.encodeDouble(Double(leftRatio),forKey:"bottomRatio")
		coder.encodeDouble(Double(leftOffset),forKey:"bottomOffset")
		}
		
	func rectInRect(rect:CGRect) -> CGRect
		{
		var originX:CGFloat
		var originY:CGFloat
		var extentX:CGFloat
		var extentY:CGFloat
		
		originX = leftRatio * CGRectGetMinX(rect) + leftOffset
		originY = topRatio * CGRectGetMinY(rect) + topOffset
		extentX = rightRatio * CGRectGetMaxX(rect) + rightOffset
		extentY = bottomRatio * CGRectGetMaxY(rect) + bottomOffset
		return(CGRect(x:originX,y:originY,width:extentX-originX,height:extentY-originY))
		}
	}