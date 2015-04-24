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

class USSDActionMenuItem:USSDMenuItem,NSPopoverDelegate
	{
	var actionType = "INVOKE"
	var actionTargetName = "NULL"
	
	override class func newLeftSlot() -> Slot
		{
		var aSlot:ActionSlot
		
		aSlot = ActionSlot()
		aSlot.isLeft = true
		return(aSlot)
		}
		
	override class func newRightSlot() -> Slot
		{
		var aSlot:ActionSlot
		
		aSlot = ActionSlot()
		aSlot.isRight = true
		return(aSlot)
		}
		
	func connectedActionSlot() -> ActionSlot?
		{
		return(self.connectedSlot() as! ActionSlot?)
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeObject(actionType,forKey:"actionType")
		coder.encodeObject(actionTargetName,forKey:"actionTargetName")
		}
		
	required init(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
		actionType = aDecoder.decodeObjectForKey("actionType") as! String
		actionTargetName = aDecoder.decodeObjectForKey("actionTargetName") as! String
		}
		
	override func asJSONString() -> String
		{
		var aString:String = ""
		var nextMenu:String = self.connectedActionSlot() != nil ? self.connectedActionSlot()!.link!.targetMenu!.uuid : ""
		
		aString = "{ \"type\": \"\(self.dynamicType)\", \"uuid\":\"\(uuid)\", \"itemIndex\": \(menuIndex), \"text\": \"\(text)\",\"actionType\":\"\(actionType)\",\"actionTargetName\":\"\(actionTargetName)\""
		if nextMenu != ""
			{
			aString += ",\"nextMenuUUID\":\"\(nextMenu)\""
			}
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
		
	override func isMenuActionItem() -> Bool
		{
		return(true)
		}
		
	override func isMenuItem() -> Bool
		{
		return(true)
		}
		
	override func frameContainsPoint(point:NSPoint) -> Bool
		{
		var extendedFrame:CGRect
		
		extendedFrame = self.frame
		extendedFrame.size.width += 12
		return(CGRectContainsPoint(extendedFrame,point))
		}
		
	override func handleClick(point:NSPoint,inView:DesignView)
		{
		}
		
	func popoverDidClose(note:NSNotification)
		{
		}
//		
	override init()
		{
		super.init()
//		addSublayer(actionSlot)
		}
		
	override init(layer:AnyObject?)
		{
		super.init(layer:layer)
		var slotLayer = layer as! USSDActionMenuItem
//		addSublayer(actionSlot)
		setNeedsLayout()
		}
		
	override init(text:String)
		{
		super.init(text:text)
//		addSublayer(actionSlot)
		setNeedsLayout()
		}
	}