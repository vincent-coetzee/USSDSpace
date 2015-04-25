//
//  USSDItem.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/23.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class USSDItem:CATextLayer,Selectable
	{
	let zBackground:CGFloat = -1000
	let zMenu:CGFloat = 0
	let zLink:CGFloat = 1000
	let zDrag:CGFloat = 2000
	
	var isSelected:Bool = false
	var menuView:DesignView?
	
	override init()
		{
		super.init()
//		self.zOrder = zMenu
		}

	required init(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
		self.borderWidth = 0
		self.borderColor = nil
//		self.zOrder = zMenu
		}
		
	override init(layer:AnyObject?)
		{
		super.init(layer:layer)
//		self.zOrder = zMenu
		}
		
	var zOrder:CGFloat
		{
		get
			{
			return(self.zPosition)
			}
		set
			{
			zPosition = newValue
			setNeedsDisplay()
			}
		}
		
	func updateAfterEdit()
		{
		}
		
	func popupMenu() -> NSMenu?
		{
		return(nil)
		}
		
	func select()
		{
		}
		
	func deselect()
		{
		}
		
		func isMenu() -> Bool
		{
		return(false)
		}
		
	func isMenuItem() -> Bool
		{
		return(false)
		}
		
	func isMenuTitleItem() -> Bool
		{
		return(false)
		}
		
	func isMenuActionItem() -> Bool
		{
		return(false)
		}
		
	func isWorkspaceItem() -> Bool
		{
		return(false)
		}
		
	override func contentsAreFlipped() -> Bool
		{
		return(true)
		}
		
	override var geometryFlipped:Bool
		{
		get
			{
			return(true)
			}
		set
			{
			}
		}
	}