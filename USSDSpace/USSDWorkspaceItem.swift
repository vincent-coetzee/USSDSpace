//
//  USSDWorkspaceItem.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/25.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class USSDWorkspaceItem:USSDPlaceHolderItem
	{
	let workspaceSize = CGSize(width:32,height:32)
	
	var actualWorkspace:USSDWorkspace?
	
	override func setFrameOrigin(origin:CGPoint)
		{
		var rect = self.frame
		var delta:NSPoint
		
		delta = origin.pointBySubtractingPoint(frame.origin)
		rect.size = workspaceSize
		rect.origin = origin
		self.frame = rect
		rightSource.setFrameDelta(delta)
		}
		
	override func initSlots()
		{
		leftSource.removeFromSuperlayer()
		rightSource.removeFromSuperlayer()
		rightSource = WorkspaceSlot()
		leftSource.menuItem = self
		addSublayer(rightSource)
		rightSource.frame = self.bounds
		rightSource.menuItem = self
		leftSource.sisterSlot = rightSource
		rightSource.sisterSlot = leftSource
		rightSource.menuItem = self
		leftSource.menuItem = self
		self.shadowRadius = 3
		self.shadowOpacity = 0.5
		self.shadowOffset = CGSize(width:3,height:3)
		}
		
	override var frame:NSRect
		{
		get
			{
			return(super.frame)
			}
		set
			{
			let newRect = CGRect(origin:newValue.origin,size:CGSize(width:32,height:32))
			super.frame = newRect
			leftSource.frame = self.bounds
			}
		}
		
	override func isWorkspaceItem() -> Bool
		{
		return(true)
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		}
		
	override init()
		{
		super.init()
		initSlots()
		}
		
//	var menu:USSDMenu?
//		{
//		get
//			{
//			return(nil)
//			}
//		set
//			{
//			}
//		}
		
	override init(layer:AnyObject)
		{
		let incomingLayer = (layer as! USSDWorkspaceItem)
		super.init(layer:incomingLayer)
		leftSource = incomingLayer.leftSource
		rightSource = incomingLayer.rightSource
		if rightSource.isConnected
			{
			rightSource.link!.sourceItem = self
			rightSource.link!.setLine(rightSource.link!.startPoint,toPoint: rightSource.link!.endPoint)
			}
		}
		
	required init?(coder aDecoder: NSCoder) 
		{
		super.init(coder:aDecoder)
		}
	
	override class func newLeftSlot() -> Slot
		{
		return(Slot())
		}
		
	override class func newRightSlot() -> Slot
		{
		var aSlot:Slot
		
		aSlot = WorkspaceSlot()
		aSlot.isRight = true
		return(aSlot)
		}
		
	override func loadIntoLayer(menuLayer:CALayer,linkLayer:LinkManagementLayer)
		{
		menuLayer.addSublayer(self)
		rightSource.menuItem = self
		if rightSource.isConnected
			{
			rightSource.menuItem = self
			linkLayer.addLink(rightSource.link!)
			}
		layoutInFrame(menuView!.bounds)
		if rightSource.isConnected
			{
			rightSource.link!.setLine(rightSource.link!.startPoint,toPoint: rightSource.link!.endPoint)
			}
		setNeedsLayout()
		setNeedsDisplay()
		}
		
	override func layoutInFrame(aFrame:CGRect)
		{
		var newFrame = aFrame
		newFrame.origin.x = CGRectGetMinX(aFrame) - workspaceSize.width/2
		newFrame.origin.y = CGRectGetMinY(aFrame) + aFrame.size.height/2 - workspaceSize.height/2
		newFrame.size = workspaceSize
		self.frame = newFrame
		rightSource.frame = CGRect(origin:CGPoint(x:0,y:0),size:workspaceSize)
		}
		
	override func sourceSlotSet() -> SlotSet
		{
		let slotSet = SlotSet()
		
		slotSet.addSlot(rightSource)
		rightSource.resetOuterFrame()
		slotSet.offsetSlotsByPoint(self.frame.origin)
		return(slotSet)
		}
	}