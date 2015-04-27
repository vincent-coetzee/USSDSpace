//
//  VisualElement.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/26.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class VisualItem:CALayer,VisualContainer
	{
	private var parent:VisualContainer?
	private var _styling:[NSObject:AnyObject?]?
	
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
		
	override init(layer:AnyObject?)
		{
		layoutFrame = LayoutFrame()
		super.init(layer:layer)
		}
		
	func loopUntilMouseUp(inView:DesignView,closure: (point:CGPoint,atEnd:Bool) -> ())
		{
		var continueToLoop:Bool = true
		var mask:NSEventMask = NSEventMask.LeftMouseUpMask | NSEventMask.LeftMouseDraggedMask
		
		while continueToLoop == true
			{
			var localEvent = inView.window!.nextEventMatchingMask(Int(mask.rawValue))!
			let point = inView.convertPoint(localEvent.locationInWindow,fromView:nil)
			CATransaction.begin()
			CATransaction.setValue(kCFBooleanTrue,forKey:kCATransactionDisableActions)
			if localEvent.type == NSEventType.LeftMouseDragged
				{
				inView.autoscroll(localEvent)
				closure(point: point,atEnd:false)
				}
			else if localEvent.type == NSEventType.LeftMouseUp
				{
				continueToLoop = false
				closure(point:point,atEnd:true)
				}
			CATransaction.commit()
			}
		}
		
	func addFrameDependent(dependent:VisualItem)
		{
		}
		
	func removeFrameDependent(dependent:VisualItem)
		{
		}
		
	func setIndex(index:Int)
		{
		}
		
	var centerPointInView:CGPoint
		{
		get
			{
			return(self.frameAsViewFrame().centerPoint)
			}
		}
		
	func frameAsViewFrame() -> CGRect
		{
		var rect:CGRect = self.frame
		var aContainer = self.container
		
		while !aContainer.isView
			{
			var anItem = aContainer as! VisualItem
			rect.origin = rect.origin.pointByAddingPoint(anItem.frame.origin)
			aContainer = aContainer.container
			}
		return(rect)
		}
		
	func printHierarchy()
		{
		var anItem:VisualContainer
		
		anItem = self
		do
			{
			var avi:VisualItem
			avi = anItem as! VisualItem
			NSLog("\(anItem.dynamicType)(\(avi.frame.origin.x),\(avi.frame.origin.y))")
			anItem = anItem.container
			}
		while !anItem.isView
		NSLog("MY-FRAME = \(self.frame)")
		NSLog("VIEW-FRAME = \(self.frameAsViewFrame())")
		}
		
	var styling:[NSObject:AnyObject?]?
		{
		get
			{
			return(_styling)
			}
		set
			{
			_styling = newValue
			applyStyling()
			}
		}
		
	func applyStyling()
		{
		}
		
	var centerPoint:CGPoint
		{
		get
			{
			var aFrame = self.frame
			return(CGPoint(x:CGRectGetMidX(aFrame),y:CGRectGetMidY(aFrame)))
			}
		}
		
	var layoutFrame:LayoutFrame = LayoutFrame()
		{
		didSet
			{
			if self.parent != nil
				{
				self.container.markForLayout()
				}
			}
		}
		
	var container:VisualContainer
		{
		get
			{
			return(parent!)
			}
		set
			{
			parent = newValue
			}
		}
		
	var containerView:DesignView
		{
		get
			{
			return(self.container.containerView)
			}
		}
		
	var isView:Bool
		{
		get
			{
			return(false)
			}
		}
		
	var topItem:VisualItem?
		{
		get
			{
			if self.container.isView
				{
				return(self)
				}
			return(parent!.topItem)
			}
		}
		
	func desiredSizeInFrame(frame:CGRect) -> CGSize
		{
		return(CGSize(width:-1,height:-1))
		}
		
	var workspace:USSDWorkspace?
		{
		get
			{
			return(self.containerView.workspace)
			}
		}
		
	var shadow:Shadow
		{
		get
			{
			return(Shadow())
			}
		set
			{
			newValue.setOnLayer(self)
			}
		}
		
	override init()
		{
		layoutFrame = LayoutFrame()
		super.init()
		self.borderWidth = 1
		self.borderColor = NSColor.blackColor().CGColor
		}

	required init(coder aDecoder: NSCoder) 
		{
		layoutFrame = LayoutFrame()
	    super.init(coder:aDecoder)
		parent = aDecoder.decodeObjectForKey("parent") as! VisualContainer?
		layoutFrame = aDecoder.decodeObjectForKey("layoutFrame") as! LayoutFrame
		}
		
	func addItem(item:VisualItem)
		{
		item.container = self
		addSublayer(item)
		}
		
	func frameChanged(item:VisualItem)
		{
		}
		
	func markForDisplay()
		{
		setNeedsDisplay()
		}
		
	func markForLayout()
		{
		setNeedsLayout()
		}
		
	func handleMouseDownAtPoint(point:CGPoint,inView:DesignView)
		{
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeObject(parent as! VisualItem,forKey:"parent")
		coder.encodeObject(layoutFrame,forKey:"layoutFrame")
		}
		
	override func layoutSublayers()
		{
		var theFrame:CGRect
		
		theFrame = self.bounds
		if self.sublayers != nil
			{
			for child in self.sublayers
				{
				var item = child as! VisualItem
				item.frame = item.layoutFrame.rectInRect(theFrame)
				}
			}
		}
	}