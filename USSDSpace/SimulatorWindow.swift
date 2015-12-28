//
//  SimulatorWindow.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/22.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class SimulatorWindow:NSWindow
	{
	override init(contentRect: NSRect,styleMask windowStyle: Int,backing bufferingType: NSBackingStoreType,`defer` deferCreation: Bool)
		{
		super.init(contentRect: contentRect,styleMask:windowStyle,backing:bufferingType,`defer`:deferCreation)
		self.opaque = false
		self.backgroundColor = NSColor.clearColor()
		self.movableByWindowBackground = true
		}

	required init?(coder: NSCoder) 
		{
	    super.init(coder:coder)
		self.opaque = false
		self.backgroundColor = NSColor.clearColor()
		self.movableByWindowBackground = true
		}

	override var canBecomeKeyWindow:Bool
		{
		get
			{
			return(true)
			}
		}
		
	override var contentView:NSView?
		{
		get
			{
			return(super.contentView)
			}
		set
			{
			let newView = newValue 
			newView!.wantsLayer = true
			newView!.layer!.masksToBounds = true
			newView!.layer!.contents = NSImage(named:"Back")
			super.contentView = newView
			}
		}
	}