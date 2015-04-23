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
			if isConnected 
				{
				self.contents = self.slotImage
				sisterSlot!.enabled = false
				}
			else
				{
				self.contents = nil
				sisterSlot!.enabled = true
				}
			}
		}
		
	func adjustSideAccordingToTargetSlot(targetSlot:TargetSlot)
		{
		var sisterSlotDistance:CGFloat
		var myDistance:CGFloat
		var minX:CGFloat
		var maxX:CGFloat
		var x1:CGFloat
		var x2:CGFloat
		
		x1 = sisterSlot!.outerFrame.centerPoint.x
		x2 = targetSlot.outerFrame!.centerPoint.x
		minX = x1 < x2 ? x1 : x2
		maxX = x1 > x2 ? x1 : x2
		sisterSlotDistance = maxX - minX
		x1 = outerFrame.centerPoint.x
		minX = x1 < x2 ? x1 : x2
		maxX = x1 > x2 ? x1 : x2
		myDistance = maxX - minX
		if myDistance < sisterSlotDistance
			{
			return
			}
		menuItem!.swapSlotAndFrames(self,slot2: sisterSlot!)
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
		if !isConnected
			{
			return
			}
		var origin = outerFrame.origin
		origin = origin.pointByAddingPoint(delta)
		outerFrame.origin = origin
		if link != nil
			{
			link!.setStart(outerFrame.centerPoint)
			}
		}
		
	func newLink() -> SlotLink
		{
		return(SlotLink())
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