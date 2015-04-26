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
	private var entries:[VisualMenuEntry] = [VisualMenuEntry]()
	
	override init()
		{
		super.init()
		addTitleItem()
		addEntries()
		self.cornerRadius = 14
		self.backgroundColor = NSColor.percentGray(0.95).CGColor
		self.shadow = Shadow()
		}

	required init(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
		
	func addTitleItem()
		{
		titleItem = VisualText()
		titleItem!.text = "Menu Title"
		titleItem!.layoutFrame = LayoutFrame(leftRatio:0,leftOffset:2,topRatio:0,topOffset:2,rightRatio:1,rightOffset:-2,bottomRatio:0,bottomOffset:20)
		titleItem!.style = UFXStylist.MenuStyle
		addItem(titleItem!)
		}
		
	func addEntry(entry:VisualMenuEntry)
		{
		entries.append(entry)
		entry.container = self
		entry.style = UFXStylist.MenuItemStyle
		addItem(entry)
		}
	func addEntries()
		{
		var entry = VisualMenuEntry()
		entry.text = "Item Number 1"
		addEntry(entry)
		entry = VisualMenuEntry()
		entry.text = "Item Number 2"
		addEntry(entry)
		entry = VisualMenuEntry()
		entry.text = "Item Number 3"
		addEntry(entry)
		}
		
	func setFrameOrigin(origin:CGPoint)
		{
		self.frame = CGRect(origin:origin,size:menuSize)
		}
		
	override func layoutSublayers()
		{
		var newFrame:CGRect
		var myFrame = self.frame
		var size:CGSize
		var offset:CGFloat = 0
		
		titleItem!.frame = titleItem!.layoutFrame.rectInRect(myFrame)
		offset = 50
		for entry in entries
			{
			size = entry.desiredSizeInFrame(myFrame)
			newFrame = CGRect(x:0,y:offset,width:myFrame.size.width,height:size.height)
			entry.frame = newFrame
			offset += size.height
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