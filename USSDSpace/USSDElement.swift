//
//  USSDElement.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class USSDElement:USSDItem
	{
	var desiredHeight:CGFloat = 0
	var selected:Bool = false
	var uuid:String = ""
	
	var menuName:String
		{
		get
			{
			return(uuid)
			}
		set
			{
			}
		}
		
	func sizeToFitInWidth(width:CGFloat) -> CGFloat
		{
		return(0)
		}
	
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeDouble(Double(desiredHeight),forKey:"desiredHeight")
		coder.encodeBool(selected,forKey:"selected")
		coder.encodeObject(uuid,forKey:"UUID")
		}
		
	func asJSONString() -> String
		{
		return("{\"type\":\"\(self.dynamicType)\", \"uuid\":\"\(uuid)\"}")
		}
		
	func recalibrate()
		{
//		imageLayer.removeFromSuperlayer()
//		imageLayer = CALayer()
//		self.insertSublayer(imageLayer,below:menuNameLayer)
//		imageLayer.contents = menuImage
//		imageLayer.frame = CGRect(origin:CGPoint(x:0,y:0),size:menuSize)
//		self.frame = CGRect(origin:self.frame.origin,size:menuSize)
//		self.setNeedsLayout()
//		self.setNeedsDisplay()
		}
		
	required init?(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
		alignmentMode = kCAAlignmentCenter
		wrapped = true
		truncationMode = kCATruncationNone
		removeAllAnimations()
		desiredHeight = CGFloat(aDecoder.decodeDoubleForKey("desiredHeight"))
		selected = aDecoder.decodeBoolForKey("selected")
		uuid = aDecoder.decodeObjectForKey("UUID") as! String
		}
		
	func itemContainingPoint(point:NSPoint) -> USSDMenuEntry?
		{
		return(nil)
		}
		
	override init()
		{
		super.init()
		alignmentMode = kCAAlignmentCenter
		wrapped = true
		truncationMode = kCATruncationNone
		removeAllAnimations()
		uuid = USSDWorkspace.newUUIDString()
		}
		
	func startDrag()
		{
		self.shadowColor = NSColor.blackColor().CGColor
		self.shadowRadius = 4
		self.shadowOffset = CGSize(width:3,height:3)
		self.shadowOpacity = 0.9
		self.zPosition = zDrag
		}
		
	func endDrag()
		{
		self.shadowColor = NSColor.blackColor().CGColor
		self.shadowRadius = 2
		self.shadowOffset = CGSize(width:2,height:2)
		self.shadowOpacity = 0.6
		self.zPosition = zMenu
		}
		
	func sourceSlotSet() -> SlotSet
		{
		let slotSet = SlotSet()
		return(slotSet)
		}
		
	func removeLinkedTargetSlot(targetSlot:TargetSlot)
		{
//		var index = find(linkedTargetSlots,targetSlot)
//		if index != nil
//			{
//			linkedTargetSlots.removeAtIndex(index!)
//			}
		}
		
	func addIncomingSlotLink(link:SlotLink,fromSlot:Slot)
		{
//		var targetSlot:TargetSlot
//		
//		targetSlot = TargetSlot()
//		targetSlot.link = link
//		targetSlot.sourceSlot = fromSlot
//		targetSlot.link!.targetMenu = self
//		fromSlot.link = link
//		linkedTargetSlots.append(targetSlot)
//		link.targetSlot = targetSlot
//		targetSlot.setMenuFrame(frame)
		}
		
	
	func loadIntoLayer(menuLayer:CALayer,linkLayer:LinkManagementLayer)
		{
		menuLayer.addSublayer(self)
		}
		
	override init(layer:AnyObject)
		{
		super.init(layer:layer)
		alignmentMode = kCAAlignmentCenter
		wrapped = true
		truncationMode = kCATruncationNone
		removeAllAnimations()
		uuid = USSDWorkspace.newUUIDString()
		}
		
	func setFrameDelta(delta:NSPoint)
		{
		}
		
	func handleClick(point:NSPoint,inView:DesignView)
		{
		}
		
	override func isWorkspaceItem() -> Bool
		{
		return(false)
		}
		
	func frameContainsPoint(point:NSPoint) -> Bool
		{
		return(CGRectContainsPoint(self.frame,point))
		}
		
	func setFrameOrigin(origin:CGPoint)
		{
		var oldFrame:CGRect = self.frame
		oldFrame.origin = origin
		self.frame = oldFrame
		}
		
	override func select()
		{
		selected = true
		UFXStylist.styleElementAsSelected(self)
		}
		
	override func deselect()
		{
		selected = false
		UFXStylist.styleElementAsNotSelected(self)
		}
	}