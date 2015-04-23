//
//  USSDActionMenuItem.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/11.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class OldUSSDActionMenuItem:USSDMenuEntry,NSPopoverDelegate
	{
	let slotSize = CGSize(width:12,height:12)
	var actionSlot:ActionSlot = ActionSlot(rect: CGRect(x:130,y:0,width:12,height:12))
	var actionItemEditor:ActionItemEditor?
	
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeObject(actionSlot,forKey:"actionSlot")
		}
		
	required init(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
		actionSlot = aDecoder.decodeObjectForKey("actionSlot") as! ActionSlot
		}
		
	override func asJSONString() -> String
		{
		var aString:String = ""
		
		aString = "{ \"type\": \"\(self.dynamicType)\", \"uuid\":\"\(uuid)\", \"itemIndex\": \(menuIndex), \"text\": \"\(text)\","
		actionSlot.menu = self.menu()
		aString += actionSlot.asJSONString()
		aString += " }"
		return(aString)
		}
		
	override var displayText:String
		{
		get
			{
			return("\(menuIndex).\(text)")
			}
		}
		
	override func setFrameDelta(delta:NSPoint)
		{
		}
		
	override func addSourceSlotsToSet(set:SlotSet)
		{
		}
		
	override func isMenuActionItem() -> Bool
		{
		return(true)
		}
		
	override func isMenuItem() -> Bool
		{
		return(true)
		}
		
	override func loadIntoLayer(menuLayer:CALayer,linkLayer:LinkManagementLayer)
		{
		}
		
	override func layoutInFrame(aFrame:CGRect)
		{
		var newRect:CGRect 
		
		self.frame = aFrame;
		newRect = CGRect(x:self.bounds.size.width,y:0,width:12,height:12)
		actionSlot.outerFrame = newRect
		actionSlot.frame = newRect
		actionSlot.backgroundColor = NSColor.redColor().CGColor
		setNeedsDisplay()
		}
		
	override func frameContainsPoint(point:NSPoint) -> Bool
		{
		var extendedFrame:CGRect
		
		extendedFrame = self.frame
		extendedFrame.size.width += 12
		return(CGRectContainsPoint(extendedFrame,point))
		}
		
//	override func handleClick(point:NSPoint,inView:DesignView)
//		{
//		var myFrame:CGRect
//		var innerPoint = point.pointBySubtractingPoint(self.menu().frame.origin)
//		
//		actionSlot.menu = self.menu()
//		innerPoint = innerPoint.pointBySubtractingPoint(self.frame.origin)
//		if CGRectContainsPoint(actionSlot.frame,innerPoint)
//			{
//			myFrame = self.frame
//			myFrame.origin = myFrame.origin.pointByAddingPoint(self.menu().frame.origin)
//			actionItemEditor = ActionItemEditor()
//			actionItemEditor!.openOnRect(myFrame,inView:inView,actionItem:self)
//			}
//		}
		
	func popoverDidClose(note:NSNotification)
		{
		actionItemEditor = nil
		}
	
	override func layoutSublayers()
		{
		var newRect:CGRect
		var someBounds:CGRect
		
		super.layoutSublayers()
		someBounds = self.bounds
		newRect = CGRect(x:someBounds.size.width,y:0,width:12,height:12)
		actionSlot.outerFrame = newRect
		actionSlot.frame = newRect
		setNeedsDisplay()
		}
		
	override init()
		{
		super.init()
		addSublayer(actionSlot)
		}
		
	override init(layer:AnyObject?)
		{
		super.init(layer:layer)
		var slotLayer = layer as! USSDActionMenuItem
		actionSlot = slotLayer.actionSlot
		addSublayer(actionSlot)
		setNeedsLayout()
		}
		
	override init(text:String)
		{
		super.init(text:text)
		addSublayer(actionSlot)
		setNeedsLayout()
		}
	}