//
//  USSDMenu.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class USSDMenu:USSDElement
	{
	private let menuSize = CGSize(width: 137,height: 280)
	private var items:[USSDMenuEntry] = [USSDMenuEntry]()
	private var menuTitleItem:USSDMenuTitleItem = USSDMenuTitleItem(text: "Menu")
	private var imageLayer = CALayer()
	private var menuNameLayer = USSDMenuNameItem(text: "")
	private var actualMenuName:String = ""
	private var linkedTargetSlots:[TargetSlot] = [TargetSlot]()
	private var selectionLayer:CALayer = CALayer()
	
	let menuEdgeInsets = NSEdgeInsets(top:30,left:8,bottom:60,right:8)
	let interlineSpacing:CGFloat = 2
	let menuNameFrame = CGRect(x:8,y:16,width:120,height:20)
	let menuImage = NSImage(named:"iPhone6WhiteUSSD-137x280")
	
	var workspace:USSDWorkspace?
	
	override var menuName:String
		{
		get
			{
			return(menuNameLayer.text)
			}
		set
			{
			actualMenuName = newValue
			menuNameLayer.text = actualMenuName
			setNeedsDisplay()
//			self.workspace!.reIndexMenus()
			}
		}
		
	override var zOrder:CGFloat
		{
		get
			{
			return(self.zPosition)
			}
		set
			{
			zPosition = newValue
			for item in items
				{
				item.zOrder = newValue
				}
			setNeedsDisplay()
			}
		}
		
	override func removeLinkedTargetSlot(targetSlot:TargetSlot)
		{
		let index = linkedTargetSlots.indexOf(targetSlot)
		if index != nil
			{
			linkedTargetSlots.removeAtIndex(index!)
			}
		}
		
	override func asJSONString() -> String
		{
		var aString:String = ""
		var stringItems:[String] = [String]()
		
		aString = "{ \"uuid\": \"\(uuid)\", \"text\": \"\(menuTitleItem.text.cleanString)\", \"menuName\": \"\(actualMenuName)\", \"transferElements\": [";
		for item in items
			{
			stringItems.append(item.asJSONString())
			}
		aString += (stringItems as NSArray).componentsJoinedByString(",")
		aString += "]}"
		return(aString)
		}
		
	override func loadIntoLayer(menuLayer:CALayer,linkLayer:LinkManagementLayer)
		{
		menuLayer.addSublayer(self)
		UFXStylist.styleMenu(self)
		for item in items
			{
			item.loadIntoLayer(menuLayer,linkLayer:linkLayer)
			}
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeObject(items,forKey:"items")
		coder.encodeObject(actualMenuName,forKey:"menuName")
		coder.encodeObject(linkedTargetSlots,forKey:"linkedTargetSlots")
		coder.encodeObject(imageLayer,forKey:"imageLayer")
		coder.encodeObject(menuNameLayer,forKey:"menuNameLayer")
		coder.encodeObject(workspace,forKey:"workspace")
		coder.encodeObject(selectionLayer,forKey:"selectionLayer")
		}
		
	override func recalibrate()
		{
//		imageLayer.removeFromSuperlayer()
//		imageLayer = CALayer()
//		self.insertSublayer(imageLayer,below:menuNameLayer)
//		imageLayer.contents = menuImage
//		imageLayer.frame = CGRect(origin:CGPoint(x:0,y:0),size:menuSize)
//		self.frame = CGRect(origin:self.frame.origin,size:menuSize)
//		self.setNeedsLayout()
//		self.setNeedsDisplay()
		}
		
	required init?(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
		items = aDecoder.decodeObjectForKey("items") as! [USSDMenuEntry]
		for entry in items
			{
			if entry.isMenuTitleItem()
				{
				menuTitleItem = entry as! USSDMenuTitleItem
				menuTitleItem.removeFromSuperlayer()
				addSublayer(menuTitleItem)
				}
			}
		actualMenuName = aDecoder.decodeObjectForKey("menuName") as! String
		linkedTargetSlots = aDecoder.decodeObjectForKey("linkedTargetSlots") as! [TargetSlot]
		imageLayer = aDecoder.decodeObjectForKey("imageLayer") as! CALayer
		menuNameLayer = aDecoder.decodeObjectForKey("menuNameLayer") as! USSDMenuNameItem
		UFXStylist.styleLayerAsMenuName(menuNameLayer)
		workspace = aDecoder.decodeObjectForKey("workspace") as! USSDWorkspace?
		selectionLayer = aDecoder.decodeObjectForKey("selectionLayer") as! CALayer
		if selectionLayer.superlayer != nil
			{
			selectionLayer.removeFromSuperlayer()
			}
		borderColor = NSColor.clearColor().CGColor
		setNeedsLayout()
		}
		
	override func popupMenu() -> NSMenu?
		{
		let newMenu = NSMenu()
		var menuItem:NSMenuItem
		
		menuItem = newMenu.addItemWithTitle("Set as Start Menu",action:"onBecomeStartMenu:",keyEquivalent:"")!
		menuItem.target = self
		newMenu.addItem(NSMenuItem.separatorItem())
		menuItem = newMenu.addItemWithTitle("Add Menu Item",action:"onAddMenuItem:",keyEquivalent:"")!
		menuItem.target = self
		menuItem = newMenu.addItemWithTitle("Add Data Entry Item",action:"onAddDataEntryItem:",keyEquivalent:"")!
		menuItem.target = self
		menuItem = newMenu.addItemWithTitle("Add Action Menu Item",action:"onAddActionMenuItem:",keyEquivalent:"")!
		menuItem.target = self
		newMenu.addItem(NSMenuItem.separatorItem())
		menuItem = newMenu.addItemWithTitle("Delete this Menu",action:"onDeleteMenu:",keyEquivalent:"")!
		menuItem.target = self
		return(newMenu)
		}
		
	func onBecomeStartMenu(sender:AnyObject?)
		{
		self.workspace!.startMenu = self
		}
		
	func onAddDataEntryItem(sender:AnyObject?)
		{
		let menuItem = USSDDataEntryMenuItem(text: "REQUEST=")
		addItem(menuItem)
		}
		
	func onAddActionMenuItem(sender:AnyObject?)
		{
		let menuItem = USSDActionMenuItem(text: "Action Item")
		addItem(menuItem)
		}
		
	func onAddMenuItem(sender:AnyObject?)
		{
		let menuItem = USSDMenuItem(text: "Menu Item")
		addItem(menuItem)
		}
		
	override func startDrag()
		{
		self.shadowColor = NSColor.blackColor().CGColor
		self.shadowRadius = 4
		self.shadowOffset = CGSize(width:3,height:3)
		self.shadowOpacity = 0.9
		self.zPosition = zDrag
		}
		
	override func endDrag()
		{
		self.shadowColor = NSColor.blackColor().CGColor
		self.shadowRadius = 2
		self.shadowOffset = CGSize(width:2,height:2)
		self.shadowOpacity = 0.6
		self.zPosition = zMenu
		}
		
	override func addIncomingSlotLink(link:SlotLink,fromSlot:Slot)
		{
		var targetSlot:TargetSlot
		
		targetSlot = TargetSlot()
		targetSlot.link = link
		targetSlot.sourceSlot = fromSlot
		targetSlot.link!.targetMenu = self
		fromSlot.link = link
		linkedTargetSlots.append(targetSlot)
		link.targetSlot = targetSlot
		targetSlot.setMenuFrame(frame)
		}
		
	override func sourceSlotSet() -> SlotSet
		{
		let slotSet = SlotSet()
		
		for item in items
			{
			item.addSourceSlotsToSet(slotSet)
			}
		slotSet.offsetSlotsByPoint(self.frame.origin)
		return(slotSet)
		}
		
	override func setFrameOrigin(origin:CGPoint)
		{
		var delta:NSPoint
		
		delta = origin.pointBySubtractingPoint(frame.origin)
		frame = CGRect(origin:origin,size:menuSize)
		for item in items
			{
			item.setFrameDelta(delta)
			}
		for slot in linkedTargetSlots
			{
			slot.setMenuFrame(frame)
			}
		}
		
	override init()
		{
		var image:CALayer
		
		items = [USSDMenuItem]()
		super.init()
		UFXStylist.styleMenu(self)
		UFXStylist.styleMenuEntry(menuTitleItem)
		imageLayer.contents = menuImage
		addSublayer(imageLayer)
		imageLayer.frame = CGRect(x:0,y:0,width:menuSize.width,height:menuSize.height)
		addTitleItem(menuTitleItem)
		addSublayer(menuNameLayer)
		UFXStylist.styleLayerAsMenuName(menuNameLayer)
		menuNameLayer.frame = menuNameFrame
		}
		
	override func select()
		{
		self.insertSublayer(selectionLayer,below:menuTitleItem)
		selectionLayer.backgroundColor = UFXStylist.SelectionColor.CGColor
//		imageLayer.contents = NSImage(named:"iPhone6BlackUSSD-170x347")
//		menuNameLayer.foregroundColor = NSColor.whiteColor().CGColor
		}
		
	override func deselect()
		{
		selectionLayer.removeFromSuperlayer()
//		imageLayer.contents = NSImage(named:"iPhone6WhiteUSSD-170x347")
//		menuNameLayer.foregroundColor = NSColor.blackColor().CGColor
		}
		
	override func isMenu() -> Bool
		{
		return(true)
		}
		
	override init(layer:AnyObject)
		{
		super.init(layer:layer)
		}
		
	func removeItem(item:USSDMenuEntry)
		{
		let index = items.indexOf(item)
		if index != nil
			{
			item.removeFromSuperlayer()
			items.removeAtIndex(index!)
			setNeedsLayout()
			setNeedsDisplay()
			}
		}
		
	func menuUUIDForMenuName(name:String) -> String
		{
		return(workspace!.menuUUIDForMenuName(name))
		}
		
//	func menuNameForMenuUUID(name:String) -> String
//		{
//		return(workspace!.menuNameForMenuUUID(name)!)
//		}
		
	func moveItemUp(item:USSDMenuEntry)
		{
		var index:Int?
		
		index = items.indexOf(item)
		if index == nil || index! == 0
			{
			return;
			}
		items.removeAtIndex(index!)
		items.insert(item,atIndex:index!-1)
		setNeedsLayout();
		setNeedsDisplay()
		}
		
	func moveItemDown(item:USSDMenuEntry)
		{
		var index:Int?
		
		index = items.indexOf(item)
		if index == nil || index! == (items.count - 1)
			{
			return;
			}
		items.removeAtIndex(index!)
		items.insert(item,atIndex:index!+1)
		setNeedsLayout();
		setNeedsDisplay()
		}
		
	func addItem(item:USSDMenuEntry)
		{
		UFXStylist.styleMenuEntry(item)
		items.append(item)
		addSublayer(item)
		setNeedsLayout()
		setNeedsDisplay()
		}
		
	func addTitleItem(item:USSDMenuTitleItem)
		{
		items.append(item)
		addSublayer(item)
		setNeedsLayout()
		setNeedsDisplay()
		}
		
	override func itemContainingPoint(point:NSPoint) -> USSDMenuEntry?
		{
		let myFrame = frame
		let newPoint = point.pointBySubtractingPoint(myFrame.origin)
		
		for item in items
			{
			if item.frameContainsPoint(newPoint)
				{
				return(item)
				}
			}
		if menuNameLayer.frameContainsPoint(newPoint)
			{
			return(menuNameLayer)
			}
		return(nil)
		}
		
	override func layoutSublayers()
		{
		var totalHeight:CGFloat = 0
		var height:CGFloat = 0
		var menuIndex:Int = 0
		var topOffset:CGFloat
		var textWidth:CGFloat
		
		textWidth = menuSize.width-menuEdgeInsets.left-menuEdgeInsets.right
		for (index,item) in items.enumerate()
			{
			item.menuIndex = menuIndex++
			totalHeight += item.sizeToFitInWidth(textWidth) + interlineSpacing
			}
		topOffset = menuEdgeInsets.top + (menuSize.height - menuEdgeInsets.top - menuEdgeInsets.bottom - totalHeight)/2
		for (index,item) in items.enumerate()
			{
			height = item.desiredHeight
			item.layoutInFrame(CGRect(x:menuEdgeInsets.left,y:topOffset+1,width:textWidth,height:height))
			topOffset += height + interlineSpacing/2
			}
		var newFrame:CGRect = self.bounds
		newFrame.origin.x = newFrame.origin.x + 10
		newFrame.origin.y = newFrame.origin.y + 36
		newFrame.size.width = newFrame.width - 2*10
		newFrame.size.height = newFrame.height - 2*36
		selectionLayer.frame = newFrame
		}
		
	}