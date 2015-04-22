//
//  USSDElement.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class USSDElement:CATextLayer,Selectable
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
		
	func isMenu() -> Bool
		{
		return(false)
		}
		
	func isMenuItem() -> Bool
		{
		return(false)
		}
		
	func isMenuTitleItem() -> Bool
		{
		return(false)
		}
		
	func isMenuActionItem() -> Bool
		{
		return(false)
		}
		
	override func contentsAreFlipped() -> Bool
		{
		return(true)
		}
		
	override var geometryFlipped:Bool
		{
		get
			{
			return(true)
			}
		set
			{
			}
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
		
	func select()
		{
		selected = true
		UFXStylist.styleElementAsSelected(self)
		}
		
	func deselect()
		{
		selected = false
		UFXStylist.styleElementAsNotSelected(self)
		}
	}