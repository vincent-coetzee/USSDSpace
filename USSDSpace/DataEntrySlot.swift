//
//  DataEntrySlot.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/24.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class DataEntrySlot:ActionSlot
	{
	override func newLink() -> SlotLink
		{
		let aLink:ActionSlotLink = ActionSlotLink()
		aLink.sourceItem = menuItem
		UFXStylist.styleDataEntrySlotLink(aLink)
		return(aLink)
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
				UFXStylist.styleDataEntrySlotLink(self.link as! ActionSlotLink)
				}
			}
		}
		
	override init()
		{
		super.init()
		if link != nil
			{
			UFXStylist.styleDataEntrySlotLink(link as! ActionSlotLink)
			}
		}
		
	override init(layer:AnyObject)
		{
		super.init(layer: layer)
		if link != nil
			{
			UFXStylist.styleDataEntrySlotLink(link as! ActionSlotLink)
			}
		}

	required init?(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
		if link != nil
			{
			UFXStylist.styleDataEntrySlotLink(link as! ActionSlotLink)
			}
		}
	}