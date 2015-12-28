//
//  WorkspaceSlot.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/25.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class WorkspaceSlot:Slot
	{
	override init()
		{
		super.init()
		self.removeAllAnimations()
		}

	required init?(coder aDecoder: NSCoder)
		{
	    super.init(coder:aDecoder)
		self.removeAllAnimations()
		}
		
	override var slotImage:NSImage? 
		{
		get
			{
			return(NSImage(named:"WorkspaceProxy-32x32"))
			}
		set
			{
			}
		}
		
	override var isConnected:Bool
		{
		didSet
			{
			if self.isConnected
				{
				((self.menuItem!) as! USSDWorkspaceItem).actualWorkspace!.startMenu = link!.targetMenu!
				}
			}
		}
		
	override var frame:NSRect
		{
		get
			{
			return(super.frame)
			}
		set
			{
			var newRect = newValue
			newRect.size = CGSize(width:32,height:32)
			super.frame = newRect
			if link != nil
				{
				var endPoint:CGPoint
				var startPoint:CGPoint
				
				startPoint = outerFrame.centerPoint
				endPoint = link!.targetSlot!.outerFrame!.pointOnPerimeterNearestToPoint(startPoint)
				link!.setLine(startPoint,toPoint:endPoint)
				}
			}
		}
		
	override func setFrameDelta(delta:NSPoint)
		{
		outerFrame.origin = outerFrame.origin.pointByAddingPoint(delta)
		outerFrame.size = CGSize(width:32,height:32)
		if !isConnected
			{
			return
			}
		if link != nil
			{
			var endPoint:CGPoint
			var startPoint:CGPoint
			
			startPoint = outerFrame.centerPoint
			endPoint = link!.targetSlot!.outerFrame!.pointOnPerimeterNearestToPoint(startPoint)
			link!.setLine(startPoint,toPoint:endPoint)
			}
		}
		
	override init(origin:NSPoint)
		{
		super.init()
		outerFrame = CGRect(x:0,y:0,width:32,height:32)
		frame = CGRect(origin:origin,size:CGSize(width:32,height:32))
		outerFrame = frame
		self.contents = self.slotImage
		}
		
	override init(layer:AnyObject)
		{
		super.init(layer:layer)
		outerFrame = CGRect(x:0,y:0,width:32,height:32)
		}
		
	override func offsetByPoint(point:NSPoint) -> Slot
		{
		let origin = outerFrame.origin
		let newOrigin = origin.pointByAddingPoint(point)
		outerFrame = CGRect(origin:newOrigin,size:CGSize(width: 32,height: 32))
		return(self)
		}
		
	override func newLink() -> SlotLink
		{
		let aLink:ActionSlotLink = ActionSlotLink()
		aLink.removeAllAnimations()
		aLink.sourceItem = menuItem
		aLink.bubbleLayer!.contents = NSImage(named:"StartMenuBall-24x24")
		UFXStylist.styleStartMenuLink(aLink)
		return(aLink)
		}
	}