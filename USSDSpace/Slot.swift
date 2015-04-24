//
//  Slot.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class Slot:CALayer
	{
	var outerFrame:CGRect
	var link:SlotLink?
	var sisterSlot:Slot?
	var menuItem:USSDMenuItem?
	private var _isLeft = false
	private var _isRight = false
	
	var zOrder:CGFloat
		{
		get
			{
			return(self.zPosition)
			}
		set
			{
			zPosition = newValue
			if link != nil
				{
				link!.zPosition = newValue
				}
			setNeedsDisplay()
			}
		}
		
	var isLeft:Bool
		{
		get
			{
			return(_isLeft)
			}
		set
			{
			_isLeft = newValue
			_isRight = !_isLeft
			self.contents = self.slotImage
			}
		}
		
		
	var isRight:Bool
		{
		get
			{
			return(_isRight)
			}
		set
			{
			_isRight = newValue
			_isLeft = !_isRight
			self.contents = self.slotImage
			}
		}
	
	var centerPoint:NSPoint
		{
		get
			{
			return(outerFrame.centerPoint)
			}
		}
	
	var slotImage:NSImage
		{
		get
			{
			if _isLeft 
				{
				if isConnected
					{
					return(NSImage(named:"left-full-peg-16x16")!)
					}
				else
					{
					return(NSImage(named:"left-empty-peg-16x16")!)
					}
				}
			else
				{
				if isConnected
					{
					return(NSImage(named:"right-full-peg-16x16")!)
					}
				else
					{
					return(NSImage(named:"right-empty-peg-16x16")!)
					}
				}
			}
		}
		
	var enabled:Bool = true
		{
		didSet
			{
			if !self.enabled
				{
				self.contents = nil
				}
			else
				{
				self.contents = self.slotImage
				}
			}
			
		}
		
	var isConnected:Bool = false
		{
		didSet
			{
			self.enabled = self.isConnected
			sisterSlot!.enabled = !self.isConnected
			}
		}
		
	func adjustSideIfNeeded()
		{
		var targetSlot:TargetSlot
		var myDistance:CGFloat
		var sisterDistance:CGFloat
		var endPoint:CGPoint
		var startPoint:CGPoint
		
		if link == nil
			{
			return
			}
		targetSlot = link!.targetSlot!
		startPoint = outerFrame.centerPoint
		endPoint = targetSlot.outerFrame!.pointOnPerimeterNearestToPoint(startPoint)
		myDistance = startPoint.distanceToPoint(endPoint)
		startPoint = sisterSlot!.outerFrame.centerPoint
		endPoint = targetSlot.outerFrame!.pointOnPerimeterNearestToPoint(startPoint)
		sisterDistance = startPoint.distanceToPoint(endPoint)
		if myDistance <= sisterDistance
			{
			return;
			}
		sisterSlot!.acceptLink(link!)
		link = nil
		isConnected = false
		}
		
	func acceptLink(aLink:SlotLink)
		{
		var startPoint:NSPoint
		var endPoint:NSPoint
		
		link = aLink
		self.isConnected = true
		link!.targetSlot!.sourceSlot = self
		startPoint = outerFrame.centerPoint
		endPoint = link!.targetSlot!.outerFrame!.pointOnPerimeterNearestToPoint(startPoint)
		link!.setLine(startPoint,toPoint:endPoint)
		}
		
	func disconnect(linkLayer:LinkManagementLayer)
		{
		self.isConnected = false
		link!.disconnect(linkLayer)
		sisterSlot!.enabled = true
		enabled = true
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeRect(outerFrame,forKey:"outerFrame")
		coder.encodeBool(isConnected,forKey:"isConnected")
		coder.encodeObject(link,forKey:"link")
		coder.encodeObject(sisterSlot,forKey:"sisterSlot")
		coder.encodeBool(enabled,forKey:"enabled")
		coder.encodeBool(_isLeft,forKey:"isLeft")
		coder.encodeBool(_isRight,forKey:"isRight")
		}
		
	required init(coder aDecoder: NSCoder) 
		{
		outerFrame = CGRect(x:0,y:0,width:0,height:0)
	    super.init(coder:aDecoder)
		outerFrame = aDecoder.decodeRectForKey("outerFrame")
		removeAllAnimations()
		isConnected = aDecoder.decodeBoolForKey("isConnected")
		enabled = aDecoder.decodeBoolForKey("enabled");
		_isLeft = aDecoder.decodeBoolForKey("isLeft")
		_isRight = aDecoder.decodeBoolForKey("isRight")
		self.contents = self.slotImage
		link = aDecoder.decodeObjectForKey("link") as! SlotLink?
		sisterSlot = aDecoder.decodeObjectForKey("sisterSlot") as! Slot?
		}
		
	init(origin:NSPoint)
		{
		outerFrame = CGRect(x:0,y:0,width:16,height:16)
		super.init()
		frame = CGRect(origin:origin,size:CGSize(width:16,height:16))
		outerFrame = frame
		self.contents = self.slotImage
		}
		
	func resetOuterFrame()
		{
		outerFrame = frame
		}
		
	func print()
		{
		NSLog("SLOT(\(frame))")
		}
		
	func setFrameDelta(delta:NSPoint)
		{
		outerFrame.origin = outerFrame.origin.pointByAddingPoint(delta)
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
			adjustSideIfNeeded()
			}
		}
		
	func newLink() -> SlotLink
		{
		var aLink:SlotLink = SlotLink()
		aLink.sourceItem = menuItem
		UFXStylist.styleSlotLink(aLink)
		return(aLink)
		}
		
	override init()
		{
		outerFrame = CGRect(x:0,y:0,width:16,height:16)
		super.init()
		frame = CGRect(x:0,y:0,width:16,height:16)
		outerFrame = frame
		self.contents = self.slotImage
		}
		
	func offsetByPoint(point:NSPoint) -> Slot
		{
		var origin = outerFrame.origin
		var newOrigin = origin.pointByAddingPoint(point)
		
		outerFrame = CGRect(origin:newOrigin,size:CGSize(width: 16,height: 16))
		return(self)
		}
		
	override init(layer:AnyObject?)
		{
		outerFrame = CGRect(x:0,y:0,width:0,height:0)
		super.init(layer:layer)
		}
	}