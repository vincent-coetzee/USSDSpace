//
//  TargetSlot.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/08.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit

class TargetSlot:NSObject
	{
	var link:SlotLink?
	var sourceSlot:Slot?
	
	func setMenuFrame(frame:CGRect)
		{
		if link != nil
			{
			var centerPoint = frame.centerPoint
			var targetPoint = frame.pointOfIntersectionWithLine(NSLineSegment(start:link!.startPoint,end:centerPoint))
			link!.setEnd(targetPoint!)
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
		}
		
	required init(coder aDecoder: NSCoder) 
		{
		link = aDecoder.decodeObjectForKey("link") as! SlotLink?
		sourceSlot = aDecoder.decodeObjectForKey("sourceSlot") as! Slot?
		}
	}