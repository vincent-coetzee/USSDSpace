//
//  VisualSlot.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/26.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class VisualSlot:VisualItem
	{
	private var link:VisualLink?
	
	var slotImage:NSImage = NSImage(named:"socket-empty-16x16")!
		
	override init()
		{
		super.init()
		self.contents = slotImage
		}

	required init(coder aDecoder: NSCoder) 
		{
	    fatalError("init(coder:) has not been implemented")
		}
	}