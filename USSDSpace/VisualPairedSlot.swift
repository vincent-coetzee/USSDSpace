//
//  VisualPairedSlot.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/27.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class VisualPairedSlot:VisualSlot
	{
	var pairedSlot:VisualPairedSlot?
	var direction:String = "left"

	required init(coder aDecoder:NSCoder)
		{
		super.init(coder: aDecoder)
		pairedSlot = aDecoder.decodeObjectForKey("pairedSlot") as? VisualPairedSlot
		direction = aDecoder.decodeObjectForKey("direction") as! String
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeObject(pairedSlot,forKey:"pairedSlot")
		coder.encodeObject(direction,forKey:"direction")
		}
		
	func pairWithSlot(slot:VisualPairedSlot)
		{
		pairedSlot = slot
		}
		
	func makeLeft()
		{
		direction = "left"
		self.enabled = true
		}
		
	func makeRight()
		{
		direction = "right"
		self.enabled = true
		}
		
	override var enabled:Bool
		{
		didSet
			{
			if self.enabled 
				{
				slotImage = link != nil ? NSImage(named:"\(direction)-full-peg-16x16")! : NSImage(named:"\(direction)-empty-peg-16x16")!
				self.contents = slotImage
				}
			else
				{
				self.contents = nil
				}
			}
		}
		
	override func adjustForLinkChanges(link:VisualLink,source:VisualItem,target:VisualItem)
		{
		var closestSlot:VisualSlot
		
		closestSlot = link.closestSlotToTarget(self,slot2: pairedSlot!)
		if closestSlot == self
			{
			return;
			}
		pairedSlot!.enabled = true
		self.enabled = false
		pairedSlot!.link = link
		self.link = nil
		link.setSource(pairedSlot!)
		}
	}