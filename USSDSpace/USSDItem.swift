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