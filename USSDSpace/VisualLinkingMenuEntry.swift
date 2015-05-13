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
	var leftSlot:VisualPairedSlot = VisualPairedSlot()
	var rightSlot:VisualPairedSlot = VisualPairedSlot()
	
	override init()
		{
		super.init()
		leftSlot.layoutFrame = LayoutFrame(leftRatio:0,leftOffset:-4,topRatio:0,topOffset:0,rightRatio:0,rightOffset:12,bottomRatio:0,bottomOffset:16)
		leftSlot.container = self
		leftSlot.containingMenuEntry = self
		leftSlot.makeLeft()
		leftSlot.pairWithSlot(rightSlot)
		addSublayer(leftSlot)
		rightSlot.layoutFrame = LayoutFrame(leftRatio:1,leftOffset:-13,topRatio:0,topOffset:0,rightRatio:1,rightOffset:3,bottomRatio:0,bottomOffset:16)
		rightSlot.container = self
		rightSlot.containingMenuEntry = self
		rightSlot.makeRight()
		rightSlot.pairWithSlot(leftSlot)
		addSublayer(rightSlot)
		labelItem.backgroundColor = UFXStylist.SlotLinkColor.lighter().withAlpha(0.2).CGColor
		}
		
	override init(layer:AnyObject?)
		{
		super.init(layer:layer)
		}

	required init(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
		leftSlot = aDecoder.decodeObjectForKey("leftSlot") as! VisualPairedSlot
		rightSlot = aDecoder.decodeObjectForKey("rightSlot") as! VisualPairedSlot
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeObject(leftSlot,forKey:"leftSlot")
		coder.encodeObject(rightSlot,forKey:"rightSlot")
		}
		
	override func slotWasLinked(slot:VisualSlot)
		{
		if slot == leftSlot
			{
			rightSlot.enabled = false
			leftSlot.enabled = true
			}
		else if slot == rightSlot
			{
			leftSlot.enabled = false
			rightSlot.enabled = true
			}
		}
		
	override func asJSONString() -> String
		{
		var aLink:VisualLink?
		var targetUUID:String
		
		aLink = leftSlot.link
		if aLink == nil
			{
			aLink = rightSlot.link
			}
		targetUUID = aLink == nil ? "" : aLink!.targetItem!.uuid
		return("{ \"type\":\"link\",\"uuid\": \"\(uuid)\", \"target-uuid\": \"\(targetUUID)\"}");
		}
		
	override func slotWasUnLinked(slot:VisualSlot)
		{
		rightSlot.enabled = true
		leftSlot.enabled = true
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