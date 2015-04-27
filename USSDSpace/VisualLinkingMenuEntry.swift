//
//  VisualLinkedMenuEntry.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/26.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class VisualLinkingMenuEntry:VisualMenuEntry
	{
	var leftSlot:VisualSlot = VisualSlot()
	var rightSlot:VisualSlot = VisualSlot()
	
	override init()
		{
		super.init()
		leftSlot.layoutFrame = LayoutFrame(leftRatio:0,leftOffset:0,topRatio:0,topOffset:0,rightRatio:0,rightOffset:16,bottomRatio:0,bottomOffset:16)
		leftSlot.container = self
		addSublayer(leftSlot)
		rightSlot.layoutFrame = LayoutFrame(leftRatio:1,leftOffset:-16,topRatio:0,topOffset:0,rightRatio:1,rightOffset:0,bottomRatio:0,bottomOffset:16)
		rightSlot.container = self
		addSublayer(rightSlot)
		}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func hitTest(point:CGPoint) -> CALayer?
		{
		if CGRectContainsPoint(self.frame,point)
			{
			var newPoint = point.pointBySubtractingPoint(self.frame.origin)
			if CGRectContainsPoint(leftSlot.frame,newPoint)
				{
				return(leftSlot)
				}
			else if CGRectContainsPoint(rightSlot.frame,newPoint)
				{
				return(rightSlot)
				}
			else
				{
				return(self)
				}
			}
		return(nil)
		}
	}