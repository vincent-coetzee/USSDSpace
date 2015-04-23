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
		
	required init(coder aDecoder: NSCoder) 
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
		
	override init()
		{
		super.init()
		alignmentMode = kCAAlignmentCenter
		wrapped = true
		truncationMode = kCATruncationNone
		removeAllAnimations()
		uuid = USSDWorkspace.newUUIDString()
		}
		
	override init(layer:AnyObject?)
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