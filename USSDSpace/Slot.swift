//
//  Slot.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class Slot:CALayer
	{
	var outerFrame:CGRect
	var link:SlotLink?
	var sisterSlot:Slot?
	
	var centerPoint:NSPoint
		{
		get
			{
			return(outerFrame.centerPoint)
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
				if isConnected
					{
					self.contents = NSImage(named:"socket-full-16x16")
					}
				else
					{
					self.contents = NSImage(named:"socket-empty-16x16")
					}
				}
			}
			
		}
		
	var isConnected:Bool = false
		{
		didSet
			{
			if isConnected 
				{
				self.contents = NSImage(named:"socket-full-16x16")
				sisterSlot!.enabled = false
				}
			else
				{
				self.contents = NSImage(named:"socket-empty-16x16")
				sisterSlot!.enabled = true
				}
			}
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
		}
		
	required init(coder aDecoder: NSCoder) 
		{
		outerFrame = CGRect(x:0,y:0,width:0,height:0)
	    super.init(coder:aDecoder)
		outerFrame = aDecoder.decodeRectForKey("outerFrame")
		removeAllAnimations()
		isConnected = aDecoder.decodeBoolForKey("isConnected")
		if isConnected 
			{
			self.contents = NSImage(named:"socket-full-16x16")
			}
		else
			{
			self.contents = NSImage(named:"socket-empty-16x16")
			}
		link = aDecoder.decodeObjectForKey("link") as! SlotLink?
		sisterSlot = aDecoder.decodeObjectForKey("sisterSlot") as! Slot?
		enabled = aDecoder.decodeBoolForKey("enabled");
		}
		
	init(origin:NSPoint)
		{
		outerFrame = CGRect(x:0,y:0,width:16,height:16)
		super.init()
		frame = CGRect(origin:origin,size:CGSize(width:16,height:16))
		outerFrame = frame
		self.contents = NSImage(named:"socket-empty-16x16")
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
		
	override init()
		{
		outerFrame = CGRect(x:0,y:0,width:16,height:16)
		super.init()
		frame = CGRect(x:0,y:0,width:16,height:16)
		outerFrame = frame
		self.contents = NSImage(named:"socket-empty-16x16")
		}
		
	func offsetByPoint(point:NSPoint) -> Slot
		{
		var origin = outerFrame.origin
		var newOrigin = origin.pointByAddingPoint(point)
		
		outerFrame = CGRect(origin:newOrigin,size:CGSize(width: 16,height: 16))
		return(self)
		}
	}