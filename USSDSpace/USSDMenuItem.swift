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
	var leftSource:Slot
	var rightSource:Slot
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeObject(leftSource,forKey:"leftSource")
		coder.encodeObject(rightSource,forKey:"rightSource")
		}
		
	required init(coder aDecoder: NSCoder) 
		{
		leftSource = self.dynamicType.newLeftSlot()
		rightSource = self.dynamicType.newRightSlot()
	    super.init(coder:aDecoder)
		leftSource = aDecoder.decodeObjectForKey("leftSource") as! Slot
		leftSource.menuItem = self
		rightSource = aDecoder.decodeObjectForKey("rightSource") as! Slot
		rightSource.menuItem = self
		}
		
	class func newLeftSlot() -> Slot
		{
		var aSlot:Slot
		
		aSlot = Slot()
		aSlot.isLeft = true
		return(aSlot)
		}
		
	class func newRightSlot() -> Slot
		{
		var aSlot:Slot
		
		aSlot = Slot()
		aSlot.isRight = true
		return(aSlot)
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
		UFXStylist.styleMenuEntry(self)
		if leftSource.isConnected
			{
			linkLayer.addLink(leftSource.link!)
			leftSource.menuItem = self
			}
		else if rightSource.isConnected
			{
			linkLayer.addLink(rightSource.link!)
			rightSource.menuItem = self
			}
		layoutInFrame(self.frame)
		setNeedsLayout()
		setNeedsDisplay()
		}
		
	override func layoutInFrame(frame:CGRect)
		{
		var rect:CGRect
		
		self.frame = frame;
		rect = CGRect(x:-15,y:-2,width:16,height:16)
		leftSource.frame = rect
		rect = CGRect(x:frame.size.width-1,y:-2,width:16,height:16)
		rightSource.frame = rect
		}
	
	override init()
		{
		leftSource = self.dynamicType.newLeftSlot()
		rightSource = self.dynamicType.newRightSlot()
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
		leftSource = self.dynamicType.newLeftSlot()
		rightSource = self.dynamicType.newRightSlot()
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
		leftSource = self.dynamicType.newLeftSlot()
		rightSource = self.dynamicType.newRightSlot()
		super.init(text:text)
		addSublayer(leftSource)
		addSublayer(rightSource)
		leftSource.sisterSlot = rightSource
		rightSource.sisterSlot = leftSource
		rightSource.menuItem = self
		leftSource.menuItem = self
		}
	}