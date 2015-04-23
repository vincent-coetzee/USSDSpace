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
	private let menuSize = CGSize(width: 170,height: 347)
	private var items:[USSDMenuEntry]?
	private var menuTitleItem:USSDMenuTitleItem = USSDMenuTitleItem(text: "Menu")
	private var imageLayer = CALayer()
	private var menuNameLayer = USSDMenuNameItem(text: "")
	private var actualMenuName:String = ""
	private var linkedTargetSlots:[TargetSlot] = [TargetSlot]()
	private var selectionLayer:CALayer = CALayer()
	
	let menuEdgeInsets = NSEdgeInsets(top:30,left:20,bottom:60,right:20)
	let interlineSpacing:CGFloat = 4
	let menuNameFrame = CGRect(x:10,y:24,width:150,height:20)
	
	var workspace:USSDWorkspace?
	
	var menuName:String
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
			self.workspace!.reIndexMenus()
			}
		}
		
	func removeLinkedTargetSlot(targetSlot:TargetSlot)
		{
		var index = find(linkedTargetSlots,targetSlot)
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
		for item in items!
			{
			stringItems.append(item.asJSONString())
			}
		aString += (stringItems as NSArray).componentsJoinedByString(",")
		aString += "]}"
		return(aString)
		}
		
	func loadIntoLayer(menuLayer:CALayer,linkLayer:LinkManagementLayer)
		{
		menuLayer.addSublayer(self)
		for item in items!
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
		}
		
	required init(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
		items = aDecoder.decodeObjectForKey("items") as! [USSDMenuEntry]?
		for entry in items!
			{
			if entry.isMenuTitleItem()
				{
				menuTitleItem = entry as! USSDMenuTitleItem
				}
			}
		actualMenuName = aDecoder.decodeObjectForKey("menuName") as! String
		linkedTargetSlots = aDecoder.decodeObjectForKey("linkedTargetSlots") as! [TargetSlot]
		imageLayer = aDecoder.decodeObjectForKey("imageLayer") as! CALayer
		menuNameLayer = aDecoder.decodeObjectForKey("menuNameLayer") as! USSDMenuNameItem
		UFXStylist.styleLayerAsMenuName(menuNameLayer)
		workspace = aDecoder.decodeObjectForKey("workspace") as! USSDWorkspace?
		borderColor = NSColor.clearColor().CGColor
		setNeedsLayout()
		}
		
	func addSlotLink(link:SlotLink,fromSlot:Slot)
		{
		var targetSlot:TargetSlot
		
		targetSlot = TargetSlot()
		targetSlot.link = link
		targetSlot.sourceSlot = fromSlot
		targetSlot.link!.targetMenu = self
		linkedTargetSlots.append(targetSlot)
		link.targetSlot = targetSlot
		targetSlot.setMenuFrame(frame)
		}
		
	func sourceSlotSet() -> SlotSet
		{
		var slotSet = SlotSet()
		
		for item in items!
			{
			item.addSourceSlotsToSet(slotSet)
			}
		slotSet.print()
		slotSet.offsetSlotsByPoint(self.frame.origin)
		slotSet.print()
		return(slotSet)
		}
		
	override func setFrameOrigin(origin:CGPoint)
		{
		var delta:NSPoint
		
		delta = origin.pointBySubtractingPoint(frame.origin)
		frame = CGRect(origin:origin,size:CGSize(width:170,height:347))
		for item in items!
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
		imageLayer.contents = NSImage(named:"iPhone6WhiteUSSD-170x347")
		addSublayer(imageLayer)
		imageLayer.frame = CGRect(x:0,y:0,width:170,height:347)
		addTitleItem(menuTitleItem)
		addSublayer(menuNameLayer)
		UFXStylist.styleLayerAsMenuName(menuNameLayer)
		menuNameLayer.frame = menuNameFrame
		borderColor = NSColor.clearColor().CGColor
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
		
	override init(layer:AnyObject?)
		{
		super.init(layer:layer)
		}
		
	func removeItem(item:USSDMenuEntry)
		{
		var index = find(items!,item)
		if index != nil
			{
			item.removeFromSuperlayer()
			items!.removeAtIndex(index!)
			setNeedsLayout()
			setNeedsDisplay()
			}
		}
		
	func menuUUIDForMenuName(name:String) -> String
		{
		return(workspace!.menuUUIDForMenuName(name))
		}
		
	func menuNameForMenuUUID(name:String) -> String
		{
		return(workspace!.menuNameForMenuUUID(name)!)
		}
		
	func moveItemUp(item:USSDMenuEntry)
		{
		var index:Int?
		
		index = find(items!,item)
		if index == nil || index! == 0
			{
			return;
			}
		items!.removeAtIndex(index!)
		items!.insert(item,atIndex:index!-1)
		setNeedsLayout();
		setNeedsDisplay()
		}
		
	func moveItemDown(item:USSDMenuEntry)
		{
		var index:Int?
		
		index = find(items!,item)
		if index == nil || index! == (items!.count - 1)
			{
			return;
			}
		items!.removeAtIndex(index!)
		items!.insert(item,atIndex:index!+1)
		setNeedsLayout();
		setNeedsDisplay()
		}
		
	func addItem(item:USSDMenuEntry)
		{
		UFXStylist.styleMenuEntry(item)
		items!.append(item)
		addSublayer(item)
		setNeedsLayout()
		setNeedsDisplay()
		}
		
	func addTitleItem(item:USSDMenuTitleItem)
		{
		items!.append(item)
		addSublayer(item)
		setNeedsLayout()
		setNeedsDisplay()
		}
		
	func itemContainingPoint(point:NSPoint) -> USSDMenuEntry?
		{
		let myFrame = frame
		let newPoint = point.pointBySubtractingPoint(myFrame.origin)
		
		for item in items!
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
		for (index,item) in enumerate(items!)
			{
			item.menuIndex = menuIndex++
			totalHeight += item.sizeToFitInWidth(textWidth) + interlineSpacing
			}
		topOffset = menuEdgeInsets.top + (menuSize.height - menuEdgeInsets.top - menuEdgeInsets.bottom - totalHeight)/2
		for (index,item) in enumerate(items!)
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