//
//  ActionSlot.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/11.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class ActionSlot:Slot
	{	
	init(rect:CGRect)
		{
		super.init()
		frame = rect
		outerFrame = rect
		self.contents = UFXStylist.SlotMenuImage
		}
		
	override var isConnected:Bool
		{
		didSet
			{
			self.enabled = self.isConnected
			sisterSlot!.enabled = !self.isConnected
			if self.isConnected
				{
				setTargetMenuUUID(link!.targetMenu!.uuid)
				UFXStylist.styleActionSlotLink(self.link as! ActionSlotLink)
				}
			}
		}
		
	func setTargetMenuUUID(aUUID:String)
		{
		}
		
	override func newLink() -> SlotLink
		{
		var aLink:ActionSlotLink = ActionSlotLink()
		aLink.sourceItem = menuItem
		UFXStylist.styleActionSlotLink(aLink)
		return(aLink)
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		}
		
	override init()
		{
		super.init()
//		self.contents = UFXStylist.SlotMenuImage
		}
		
	override init(layer:AnyObject?)
		{
		super.init(layer: layer)
//		self.contents = UFXStylist.SlotMenuImage
		}

	required init(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
//		outerFrame = aDecoder.decodeRectForKey("outerFrame")
//		self.contents = UFXStylist.SlotMenuImage
		}
	}