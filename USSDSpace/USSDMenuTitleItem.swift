//
//  USSDMenuTitleItem.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class USSDMenuTitleItem:USSDMenuEntry
	{
	override var displayText:String
		{
		get
			{
			return(text)
			}
		}
		
	override func layoutInFrame(frame:CGRect)
		{
		self.frame = frame;
		}
		
	override func isMenuTitleItem() -> Bool
		{
		return(true)
		}
		
	override init(text:String)
		{
		super.init(text:text)
		UFXStylist.styleMenuEntry(self)
		}
		
	override init()
		{
		super.init()
		UFXStylist.styleMenuEntry(self)
		}
		
	override init(layer:AnyObject?)
		{
		super.init(layer:layer)
		UFXStylist.styleMenuEntry(self)
		}

	required init(coder aDecoder: NSCoder) 
		{
		super.init(coder:aDecoder)
		}
	}