//
//  USSDEntryFieldMenuItem.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/23.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class USSDDataEntryMenuItem:USSDActionMenuItem
	{
	override func editTextInView(view:NSView)
		{
		}
	
	override class func newLeftSlot() -> Slot
		{
		var aSlot:DataEntrySlot
		
		aSlot = DataEntrySlot()
		aSlot.isLeft = true
		return(aSlot)
		}
		
	override class func newRightSlot() -> Slot
		{
		var aSlot:DataEntrySlot
		
		aSlot = DataEntrySlot()
		aSlot.isRight = true
		return(aSlot)
		}
		
	override func updateAfterEdit()
		{
		if leftSource.isConnected || rightSource.isConnected
			{
			self.text = "\(actionType)(\(actionTargetName))"
			}
		}
	}