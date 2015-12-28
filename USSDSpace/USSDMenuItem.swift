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
		
	override var zOrder:CGFloat
		{
		get
			{
			return(self.zPosition)
			}
		set
			{
			zPosition = newValue
			leftSource.zOrder = newValue - 10
			rightSource.zOrder = newValue - 10
			setNeedsDisplay()
			}
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeObject(leftSource,forKey:"leftSource")
		coder.encodeObject(rightSource,forKey:"rightSource")
		}
		
	required init?(coder aDecoder: NSCoder) 
		{
		leftSource = self.dynamicType.newLeftSlot()
		rightSource = self.dynamicType.newRightSlot()
	    super.init(coder:aDecoder)
		leftSource = aDecoder.decodeObjectForKey("leftSource") as! Slot
		leftSource.menuItem = self
		leftSource.enabled = false
		if leftSource.isConnected
			{
			leftSource.link!.sourceItem = self
			leftSource.enabled = true
			}
		rightSource = aDecoder.decodeObjectForKey("rightSource") as! Slot
		rightSource.menuItem = self
		rightSource.enabled = false
		if rightSource.isConnected
			{
			rightSource.link!.sourceItem = self
			rightSource.enabled = true
			}
		if !leftSource.isConnected && !rightSource.isConnected
			{
			leftSource.enabled = true
			rightSource.enabled = true
			}
		self.borderWidth = 0.5
		self.borderColor = NSColor.lightGrayColor().CGColor
		}
		
	override func popupMenu() -> NSMenu?
		{
		let newMenu = NSMenu()
		var menuItem:NSMenuItem
		
		menuItem = newMenu.addItemWithTitle("Move Up",action:"onMoveUp:",keyEquivalent:"")!
		menuItem.target = self
		menuItem = newMenu.addItemWithTitle("Move Down",action:"onMoveDown:",keyEquivalent:"")!
		menuItem.target = self
		newMenu.addItem(NSMenuItem.separatorItem())
		menuItem = newMenu.addItemWithTitle("Delete this Item",action:"onDeleteItem:",keyEquivalent:"")!
		menuItem.target = self
		return(newMenu)
		}
		
	func onDeleteItem(sender:AnyObject?)
		{
		if leftSource.isConnected
			{
			self.menu().menuView!.linkContainerLayer.removeLink(leftSource.link!)
			}
		if rightSource.isConnected
			{
			self.menu().menuView!.linkContainerLayer.removeLink(rightSource.link!)
			}
		self.menu().removeItem(self)
		}
		
	func onMoveUp(sender:AnyObject?)
		{
		self.menu().moveItemUp(self)
		}
		
	func onMoveDown(sender:AnyObject?)
		{
		self.menu().moveItemDown(self)
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
		
	func connectedSlot() -> Slot?
		{
		if leftSource.isConnected
			{
			return(leftSource)
			}
		else if rightSource.isConnected
			{
			return(rightSource)
			}
		return(nil)
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
		initSlots()
		}
		
	func initSlots()
		{
		addSublayer(leftSource)
		leftSource.menuItem = self
		addSublayer(rightSource)
		rightSource.menuItem = self
		leftSource.sisterSlot = rightSource
		rightSource.sisterSlot = leftSource
		rightSource.menuItem = self
		leftSource.menuItem = self
		self.borderWidth = 0.5
		self.borderColor = NSColor.lightGrayColor().CGColor
		}
		
	override init(layer:AnyObject)
		{
		leftSource = self.dynamicType.newLeftSlot()
		rightSource = self.dynamicType.newRightSlot()
		super.init(layer:layer)
		initSlots()
		}
		
	override init(text:String)
		{
		leftSource = self.dynamicType.newLeftSlot()
		rightSource = self.dynamicType.newRightSlot()
		super.init(text:text)
		initSlots()
		}
	}