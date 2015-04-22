//
//  USSDMenuItem.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 Olamide. All rights reserved.
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
		rightSource = aDecoder.decodeObjectForKey("rightSource") as! Slot
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
			}
		if rightSource.isConnected
			{
			linkLayer.addLink(rightSource.link!)
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
		}
		
	override init(layer:AnyObject?)
		{
		super.init(layer:layer)
		addSublayer(leftSource)
		addSublayer(rightSource)
		leftSource.sisterSlot = rightSource
		rightSource.sisterSlot = leftSource
		}
		
	override init(text:String)
		{
		super.init(text:text)
		addSublayer(leftSource)
		addSublayer(rightSource)
		leftSource.sisterSlot = rightSource
		rightSource.sisterSlot = leftSource
		}
	}