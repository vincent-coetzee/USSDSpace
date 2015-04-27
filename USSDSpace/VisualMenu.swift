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
	private let menuSize = CGSize(width:140,height:260)
	private var titleItem:VisualText?
	private var entries:VisualItemSet = VisualItemSet()
	private var nameItem:VisualText?
	private var frameDependents = VisualItemSet()
	
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
		
	override func hitTest(point:CGPoint) -> CALayer?
		{
		var newPoint = point.pointBySubtractingPoint(self.frame.origin)
		
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
		self.cornerRadius = 14
		self.backgroundColor = NSColor.percentGray(0.95).CGColor
		self.shadow = Shadow()
		}
		
	override init(layer:AnyObject?)
		{
		super.init(layer:layer)
		}
		
	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
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
		titleItem = VisualText()
		titleItem!.text = "Menu Title"
		titleItem!.styling = UFXStylist.menuTitleStyle()
		addItem(titleItem!)
		}
		
	func addNameItem()
		{
		nameItem = VisualText()
		nameItem!.text = "MENU-NAME"
		nameItem!.layoutFrame = LayoutFrame(leftRatio:0,leftOffset:2,topRatio:0,topOffset:2,rightRatio:1,rightOffset:-2,bottomRatio:0,bottomOffset:20)
		nameItem!.styling = UFXStylist.menuStyle()
		addSublayer(nameItem!)
		}
		
	override func addItem(entry:VisualItem)
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
		addItem(entry)
		entry = VisualLinkingMenuEntry()
		entry.text = "Item Number 2"
		addItem(entry)
		entry = VisualLinkingMenuEntry()
		entry.text = "Item Number 3"
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
		
		nameItem!.frame = nameItem!.layoutFrame.rectInRect(myFrame)
		for entry in entries
			{
			totalHeight += (entry.desiredSizeInFrame(myFrame).height+2)
			}
		offset = (menuSize.height - -30 - totalHeight)/2 - 30
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