//
//  USSDMenuItem.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class USSDMenuItem:USSDMenuEntry
	{
	var leftSource:Slot = Slot()
	var rightSource:Slot = Slot()
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeObject(leftSource,forKey:"leftSource")
		coder.encodeObject(rightSource,forKey:"rightSource")
		}
		
	required init(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
		leftSource = aDecoder.decodeObjectForKey("leftSource") as! Slot
		leftSource.menuItem = self
		rightSource = aDecoder.decodeObjectForKey("rightSource") as! Slot
		rightSource.menuItem = self
		}
		
	override var displayText:String
		{
		get
			{
			return("\(menuIndex).\(text)")
			}
		}
		
	override func asJSONString() -> String
		{
		var aString:String = ""
		
		aString = "{ \"type\": \"\(self.dynamicType)\", \"uuid\":\"\(uuid)\", \"itemIndex\": \(menuIndex), \"text\": \"\(text.cleanString)\""
		if leftSource.link != nil
			{
			aString += ",\"actionType\": \"link\",\"nextMenuUUID\": \"\(leftSource.link!.targetMenu!.uuid)\""
			}
		else if rightSource.link != nil
			{
			aString += ",\"actionType\": \"link\",\"nextMenuUUID\": \"\(rightSource.link!.targetMenu!.uuid)\""
			}
		aString += " }"
		return(aString)
		}
		
	override func setFrameDelta(delta:NSPoint)
		{
		leftSource.setFrameDelta(delta)
		rightSource.setFrameDelta(delta)
		if leftSource.isConnected
			{
			leftSource.adjustSideAccordingToTargetSlot(leftSource.link!.targetSlot!)
			rightSource.enabled = false
			}
		else if rightSource.isConnected
			{
			rightSource.adjustSideAccordingToTargetSlot(rightSource.link!.targetSlot!)
			leftSource.enabled = false
			}
		
		}
		
	override func addSourceSlotsToSet(set:SlotSet)
		{
		leftSource.resetOuterFrame()
		set.addSlot(leftSource.offsetByPoint(self.frame.origin))
		rightSource.resetOuterFrame()
		set.addSlot(rightSource.offsetByPoint(self.frame.origin))
		}
		
	override func isMenuItem() -> Bool
		{
		return(true)
		}
		
	override func loadIntoLayer(menuLayer:CALayer,linkLayer:LinkManagementLayer)
		{
		if leftSource.isConnected
			{
			linkLayer.addLink(leftSource.link!)
			leftSource.menuItem = self
			}
		if rightSource.isConnected
			{
			linkLayer.addLink(rightSource.link!)
			rightSource.menuItem = self
			}
		}
		
	func swapSlotAndFrames(slot1:Slot,slot2:Slot)
		{
		var tempOuterFrame:CGRect
		var tempInnerFrame:CGRect
		var tempSlot:Slot
		var line:NSLineSegment
		var point:NSPoint
		
		tempOuterFrame = slot1.outerFrame
		tempInnerFrame = slot1.frame
		slot1.outerFrame = slot2.outerFrame
		slot1.frame = slot2.frame
		slot2.outerFrame = tempOuterFrame
		slot2.frame = tempInnerFrame
		if (slot1 == leftSource)
			{
			tempSlot = leftSource
			leftSource = slot2
			rightSource = tempSlot
			}
		else
			{
			tempSlot = rightSource
			rightSource = slot2
			leftSource = tempSlot
			}
		if leftSource.link != nil
			{
			line = NSLineSegment(start:leftSource.outerFrame.centerPoint,end:leftSource.link!.targetSlot!.outerFrame!.centerPoint)
			point = leftSource.link!.targetSlot!.outerFrame!.pointOfIntersectionWithLine(line)!
			leftSource.link!.setLine(leftSource.outerFrame.centerPoint,toPoint: point)
			}
		else
			{
			line = NSLineSegment(start:rightSource.outerFrame.centerPoint,end:rightSource.link!.targetSlot!.outerFrame!.centerPoint)
			point = rightSource.link!.targetSlot!.outerFrame!.pointOfIntersectionWithLine(line)!
			rightSource.link!.setLine(rightSource.outerFrame.centerPoint,toPoint: point)
			}
		}
		
	override func layoutInFrame(frame:CGRect)
		{
		var rect:CGRect
		
		self.frame = frame;
		rect = CGRect(x:-16,y:0,width:16,height:16)
		leftSource.frame = rect
		rect = CGRect(x:frame.size.width,y:0,width:16,height:16)
		rightSource.frame = rect
		}
	
	override init()
		{
		super.init()
		addSublayer(leftSource)
		addSublayer(rightSource)
		leftSource.sisterSlot = rightSource
		rightSource.sisterSlot = leftSource
		rightSource.menuItem = self
		leftSource.menuItem = self
		}
		
	override init(layer:AnyObject?)
		{
		super.init(layer:layer)
		addSublayer(leftSource)
		addSublayer(rightSource)
		leftSource.sisterSlot = rightSource
		rightSource.sisterSlot = leftSource
		rightSource.menuItem = self
		leftSource.menuItem = self
		}
		
	override init(text:String)
		{
		super.init(text:text)
		addSublayer(leftSource)
		addSublayer(rightSource)
		leftSource.sisterSlot = rightSource
		rightSource.sisterSlot = leftSource
		rightSource.menuItem = self
		leftSource.menuItem = self
		}
	}