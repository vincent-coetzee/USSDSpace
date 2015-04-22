//
//  SlotSet.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class SlotSet
	{
	private var slots:[Slot]
	
	init()
		{
		slots = [Slot]()
		}
		
	func print()
		{
		for slot in slots
			{
			slot.print()
			}
		}
		
	func addSlot(slot:Slot)
		{
		slots.append(slot)
		}
	
	func offsetSlotsByPoint(point:NSPoint)
		{
		for slot in slots
			{
			slot.offsetByPoint(point)
			}
		}
		
	func slotContainingPoint(point:NSPoint) -> Slot?
		{
		for slot in slots
			{
			if CGRectContainsPoint(slot.outerFrame,point)
				{
				return(slot)
				}
			}
		return(nil)
		}
	}