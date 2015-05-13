//
//  VisualMenu.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/26.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class VisualMenu:VisualItem
	{
	private let menuSize = CGSize(width:150,height:271)
	private var titleItem:VisualLabelItem?
	private var entries:VisualItemSet = VisualItemSet()
	private var nameItem:VisualLabelItem?
	private var frameDependents = VisualItemSet()
	private var imageLayer:CALayer = CALayer()
	
	required init(coder aDecoder: NSCoder) 
		{
		super.init(coder:aDecoder)
		self.shadow = Shadow()
		titleItem = aDecoder.decodeObjectForKey("titleItem") as? VisualLabelItem
		entries = aDecoder.decodeObjectForKey("entries") as! VisualItemSet
		nameItem = aDecoder.decodeObjectForKey("nameItem") as? VisualLabelItem
		frameDependents = aDecoder.decodeObjectForKey("frameDependents") as! VisualItemSet
		imageLayer = aDecoder.decodeObjectForKey("imageLayer") as! CALayer
		}
	
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeObject(titleItem,forKey:"titleItem")
		coder.encodeObject(entries,forKey:"entries")
		coder.encodeObject(nameItem,forKey:"nameItem")
		coder.encodeObject(frameDependents,forKey:"frameDependents")
		coder.encodeObject(imageLayer,forKey:"imageLayer")
		}
		
	var menuName:String = "MENU"
		{
		didSet
			{
			if titleItem != nil
				{
				titleItem!.text = self.menuName
				}
			}
		}
		
	override func asJSONString() -> String
		{
		var aString:String = ""
		var stringItems:[String] = [String]()
		
		aString = "{ \"type\":\"menu\",\"uuid\": \"\(uuid)\", \"text\": \"\(titleItem!.text)\", \"menuName\": \"\(nameItem!.text)\", \"transferElements\": [";
		for entry in entries
			{
			stringItems.append(entry.asJSONString())
			}
		aString += (stringItems as NSArray).componentsJoinedByString(",")
		aString += "]}"
		return(aString)
		}
		
	override func loadIntoLayer(menuLayer:CALayer,linkLayer:LinkManagementLayer)
		{
		var newFrame = self.frame
		newFrame.size = menuSize
		self.frame =  newFrame
		menuLayer.addSublayer(self)
		imageLayer.removeFromSuperlayer()
		imageLayer = CALayer()
		imageLayer.frame = self.bounds
		imageLayer.contents = NSImage(named:"WhiteiPhone-150x271")
		imageLayer.zPosition = -10
		addSublayer(imageLayer)
		markForLayout()
		markForDisplay()
		}
		
	override func hitTest(point:CGPoint) -> CALayer?
		{
		var newPoint = point.pointBySubtractingPoint(self.frame.origin)
		
		if CGRectContainsPoint(nameItem!.frame,newPoint)
			{
			return(nameItem)
			}
		if CGRectContainsPoint(self.frame,point)
			{
			var anItem = entries.itemContainingPoint(newPoint)
			if anItem != nil
				{
				return(anItem)
				}
			return(self)
			}
		
		return(nil)
		}
	
	override init()
		{
		super.init()
		addTitleItem()
		addNameItem()
		addEntries()
		self.shadow = Shadow()
		self.contents = NSImage(named:"WhiteiPhone-150x271")
		}
		
	override init(layer:AnyObject?)
		{
		super.init(layer:layer)
		}
		
	override func popupMenu() -> NSMenu?
		{
		var newMenu = NSMenu()
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
		
	override func addFrameDependent(dependent:VisualItem)
		{
		frameDependents.addItem(dependent)
		}
		
	override func removeFrameDependent(dependent:VisualItem)
		{
		frameDependents.removeItem(dependent)
		}
		
	func addTitleItem()
		{
		titleItem = VisualLabelItem()
		titleItem!.text = "Menu Title"
		titleItem!.styling = UFXStylist.menuTitleStyle()
		addItem(titleItem!)
		}
		
	func addNameItem()
		{
		nameItem = VisualLabelItem()
		nameItem!.container = self
		nameItem!.text = "MENU-NAME"
		nameItem!.layoutFrame = LayoutFrame(leftRatio:0,leftOffset:2,topRatio:0,topOffset:15,rightRatio:1,rightOffset:-2,bottomRatio:0,bottomOffset:35)
		nameItem!.styling = UFXStylist.menuStyle()
		addSublayer(nameItem!)
		}
		
	func addItem(entry:VisualItem)
		{
		entries.addItem(entry)
		entry.container = self
		addSublayer(entry)
		var index:Int = 0
		for entry in entries
			{
			entry.setIndex(index++)
			}
		markForLayout()
		}
		
	func addEntries()
		{
		var entry = VisualLinkingMenuEntry()
		entry.text = "Item Number 1"
		entry.containingMenu = self
		addItem(entry)
		entry = VisualDataMenuEntry()
		entry.text = "Item Number 2 - which is a slightly longer piece of text"
		entry.containingMenu = self
		addItem(entry)
		entry = VisualLinkingMenuEntry()
		entry.text = "Item Number 3 - which in the case of number 3 it could have been written by George R.R. Martin, because it uses many words when one would actually do."
		entry.containingMenu = self
		addItem(entry)
		entry = VisualActionMenuEntry()
		entry.text = "Action Item Number 4"
		entry.containingMenu = self
		addItem(entry)
		entry = VisualActionMenuEntry()
		entry.text = "Action Item Number 5 - which causes something to be done on the server"
		entry.containingMenu = self
		addItem(entry)
		}
		
	func setFrameOrigin(origin:CGPoint)
		{
		self.frame = CGRect(origin:origin,size:menuSize)
		frameDependents.frameChanged(self)
		}
		
	override func handleMouseDownAtPoint(point:CGPoint,inView:DesignView)
		{
		var delta:CGPoint
		
		delta = point.pointBySubtractingPoint(self.frame.origin)
		self.shadowOffset = CGSize(width:5,height:5)
		self.shadowRadius = 6
		self.shadowColor = NSColor.blackColor().CGColor
		self.shadowOpacity = 0.9
		self.zPosition = 500
		loopUntilMouseUp(inView,closure: { (localPoint:CGPoint,atEnd:Bool) in
			self.setFrameOrigin(localPoint.pointBySubtractingPoint(delta))
			})
		self.shadow = Shadow()
		self.zPosition = 0
		}
		
	override func layoutSublayers()
		{
		var myFrame = self.bounds
		var size:CGSize
		var offset:CGFloat = 0
		var totalHeight:CGFloat = 0
		
		imageLayer.frame = self.bounds
		nameItem!.frame = nameItem!.layoutFrame.rectInRect(myFrame)
		for entry in entries
			{
			totalHeight += (entry.desiredSizeInFrame(myFrame).height+1)
			}
		offset = (menuSize.height - totalHeight)/2
		for entry in entries
			{
			size = entry.desiredSizeInFrame(myFrame)
			entry.frame = CGRect(x:0,y:offset,width:myFrame.size.width,height:size.height)
			offset += (size.height + 1)
			}
		}
		
	var title:String
		{
		get
			{
			return("")
			}
		set
			{
			}
		}
	}