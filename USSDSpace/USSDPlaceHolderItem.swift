//
//  USSDPackageActivity.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/25.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class USSDPlaceHolderItem:USSDMenuItem
	{
	private let activitySize = CGSize(width:160,height:28)
	private var innerLayer:CALayer = CALayer()
	
	var linkedTargetSlots:[TargetSlot] = [TargetSlot]()
	var package:RemoteUSSDPackage?

	override init()
		{
		super.init()
		addSublayer(innerLayer)
		innerLayer.backgroundColor = NSColor.whiteColor().CGColor
		innerLayer.borderWidth = 2
		innerLayer.borderColor = NSColor.grayColor().CGColor
		innerLayer.shadowRadius = 2
		innerLayer.shadowOpacity = 0.5
		innerLayer.shadowOffset = CGSize(width: 2,height: 2)
		initSlots()
		self.borderWidth = 0
		}
		
	override init(layer:AnyObject?)
		{
		super.init(layer:layer)
		addSublayer(innerLayer)
		innerLayer.backgroundColor = NSColor.whiteColor().CGColor
		innerLayer.borderWidth = 2
		innerLayer.borderColor = NSColor.grayColor().CGColor
		innerLayer.shadowRadius = 2
		innerLayer.shadowOpacity = 0.5
		self.shadowOffset = CGSize(width: 2,height: 2)
		initSlots()
		self.borderWidth = 0
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeObject(innerLayer,forKey:"innerLayer")
		}
	override func addIncomingSlotLink(link:SlotLink,fromSlot:Slot)
		{
		var targetSlot:TargetSlot
		
		targetSlot = TargetSlot()
		targetSlot.link = link
		targetSlot.sourceSlot = fromSlot
		targetSlot.link!.targetMenu = self
		fromSlot.link = link
		linkedTargetSlots.append(targetSlot)
		link.targetSlot = targetSlot
		targetSlot.setMenuFrame(frame)
		}
		
	override func initSlots()
		{
		super.initSlots()
		leftSource.menuItem = self
		rightSource.menuItem = self
		self.borderWidth = 0
		self.borderColor = NSColor.clearColor().CGColor
		}
		
	override func setFrameOrigin(origin:CGPoint)
		{
		var delta:NSPoint
		
		delta = origin.pointBySubtractingPoint(frame.origin)
		self.frame = CGRect(origin:origin,size:activitySize)
		for slot in linkedTargetSlots
			{
			slot.setMenuFrame(frame)
			}
		leftSource.setFrameDelta(delta)
		rightSource.setFrameDelta(delta)
		}

	required init(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
		innerLayer = aDecoder.decodeObjectForKey("innerLayer") as! CALayer
		}
	
	override func sourceSlotSet() -> SlotSet
		{
		var slotSet = SlotSet()
		
		slotSet.addSlot(leftSource)
		slotSet.addSlot(rightSource)
		leftSource.resetOuterFrame()
		rightSource.resetOuterFrame()
		slotSet.offsetSlotsByPoint(self.frame.origin)
		return(slotSet)
		}
		
	override func layoutSublayers()
		{
		var someBounds = bounds
		var half:CGFloat
		var rect:CGRect
		
		half = someBounds.size.height/2 - 8
		rect = CGRect(x:0,y:half,width:16,height:16)
		leftSource.frame = rect
		rect = CGRect(x:frame.size.width-16,y:half,width:16,height:16)
		rightSource.frame = rect
		rect = self.bounds
		rect.origin.x += 16
		rect.size.width -= 32;
		innerLayer.frame = rect
		}
		
	override func layoutInFrame(frame:CGRect)
		{
		var rect:CGRect
		var half:CGFloat
		
		self.frame = frame;
		half = frame.size.height/2 - 8
		rect = CGRect(x:0,y:half,width:16,height:16)
		leftSource.frame = rect
		rect = CGRect(x:frame.size.width-16,y:half,width:16,height:16)
		rightSource.frame = rect
		rect = self.bounds
		rect.origin.x += 16
		rect.size.width -= 32;
		innerLayer.frame = rect
		}
	}