//
//  TargetSlot.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/08.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit

class TargetSlot:NSObject
	{
	var link:SlotLink?
	var sourceSlot:Slot?
	var outerFrame:CGRect? 
	
	func setMenuFrame(frame:CGRect)
		{
		outerFrame = frame
		if link != nil
			{
			sourceSlot!.adjustSideIfNeeded()
			var targetPoint = frame.pointOnPerimeterNearestToPoint(sourceSlot!.centerPoint)
			link!.setEnd(targetPoint)
			}
		}
		
	override init()
		{
		super.init()
		}
		
	func encodeWithCoder(coder:NSCoder)
		{
		coder.encodeObject(link,forKey:"link")
		coder.encodeObject(sourceSlot,forKey:"sourceSlot")
		coder.encodeBool(outerFrame == nil,forKey:"outerFrameIsNil")
		if outerFrame != nil
			{
			coder.encodeRect(outerFrame!,forKey:"outerFrame")
			}
		}
		
	required init(coder aDecoder: NSCoder) 
		{
		var isNil:Bool
		
		link = aDecoder.decodeObjectForKey("link") as! SlotLink?
		sourceSlot = aDecoder.decodeObjectForKey("sourceSlot") as! Slot?
		isNil = aDecoder.decodeBoolForKey("outerFrameIsNil")
		if !isNil
			{
			outerFrame = aDecoder.decodeRectForKey("outerFrame")
			}
		}
	}