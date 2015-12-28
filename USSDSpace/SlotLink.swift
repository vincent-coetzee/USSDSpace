//
//  ActiveLink.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class SlotLink:USSDItem
	{
	var startPoint:NSPoint = NSPoint(x:0,y:0)
	var endPoint:NSPoint = NSPoint(x:0,y:0)
	var shapeLayer:CAShapeLayer = CAShapeLayer()
	var link:NSBezierPath = NSBezierPath()
	var lineWidth:CGFloat = 4
	var lineColor:NSColor = UFXStylist.LinkLineColor
	var shapeFrame:CGRect = CGRect(x:0,y:0,width:0,height:0)
	var targetMenu:USSDElement?
	var targetSlot:TargetSlot?
	var oldLineColor:NSColor?
	var sourceItem:USSDItem?
	var parentLayer:CALayer?
	var bubbleImage:NSImage?
	var bubbleRect:CGRect?
	var bubbleLayer:CALayer?
	
	func disconnect(linkLayer:LinkManagementLayer)
		{
		linkLayer.removeLink(self)
		targetMenu!.removeLinkedTargetSlot(targetSlot!)
		}
		
	override func select()
		{
		if !isSelected
			{
			oldLineColor = lineColor
			lineColor = UFXStylist.SelectionColor
			shapeLayer.strokeColor = lineColor.CGColor
			shapeLayer.fillColor = lineColor.CGColor
			isSelected = true
			setLine(startPoint,toPoint:endPoint)
			}
		}
		
	override func deselect()
		{
		if isSelected
			{
			lineColor = oldLineColor!
			shapeLayer.strokeColor = lineColor.CGColor
			shapeLayer.fillColor = lineColor.CGColor
			isSelected = false
			setLine(startPoint,toPoint:endPoint)
			}
		}
		
	func editLinkInView(aView:NSView)
		{
		}
		
	func closeEditor()
		{
		}
		
	func initStyle()
		{
		shapeLayer.lineCap = kCALineCapRound
		shapeLayer.strokeColor = lineColor.CGColor
		shapeLayer.fillColor = lineColor.CGColor
		shapeLayer.shadowColor = NSColor.blackColor().CGColor
		shapeLayer.shadowRadius = 2
		shapeLayer.shadowOffset = CGSize(width:2,height:2)
		shapeLayer.shadowOpacity = 0.6
		shapeLayer.lineWidth = lineWidth
		shapeLayer.removeAllAnimations()
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		coder.encodePoint(startPoint,forKey:"startPoint")
		coder.encodePoint(endPoint,forKey:"endPoint")
		coder.encodeObject(shapeLayer,forKey:"shapeLayer")
		coder.encodeRect(shapeFrame,forKey:"shapeFrame")
		coder.encodeObject(link,forKey:"link")
		coder.encodeObject(targetMenu,forKey:"targetMenu")
		coder.encodeObject(targetSlot,forKey:"targetSlot")
		coder.encodeObject(lineColor,forKey:"lineColor")
		}
		
	required init?(coder aDecoder: NSCoder) 
		{
		super.init(coder:aDecoder)
	    startPoint = aDecoder.decodePointForKey("startPoint")
		endPoint = aDecoder.decodePointForKey("endPoint")
		shapeLayer = aDecoder.decodeObjectForKey("shapeLayer") as! CAShapeLayer
		shapeFrame = aDecoder.decodeRectForKey("shapeFrame")
		link = aDecoder.decodeObjectForKey("link") as! NSBezierPath
		targetMenu = aDecoder.decodeObjectForKey("targetMenu") as? USSDMenu
		targetSlot = aDecoder.decodeObjectForKey("targetSlot") as! TargetSlot?
		lineColor = aDecoder.decodeObjectForKey("lineColor") as! NSColor
		initStyle()
		}
		
	override func containsPoint(point:NSPoint) -> Bool
		{
		if link.containsPoint(point)
			{
			return(true)
			}
		return(false)
		}
		
	override init()
		{
		super.init()
		initStyle()
		bubbleLayer = CALayer()
		}
		
	func shapeLayerFrame() -> CGRect
		{
		return(CGRect(x:0,y:0,width:0,height:0))
		}
		
	func setLine(fromPoint:NSPoint,toPoint:NSPoint)
		{
		startPoint = fromPoint
		endPoint = toPoint
		calculateBoundsAndUpdateTarget()
		}
		
	func setStart(start:NSPoint)
		{
		startPoint = start
		calculateBoundsAndUpdateTarget()
		}
		
	func setEnd(end:NSPoint)
		{
		endPoint = end
		calculateBoundsAndUpdateTarget()
		}
		
	func setLine(line:NSLineSegment)	
		{
		setLine(line.startPoint,toPoint: line.endPoint)
		}
		
	func calculateBoundsAndUpdateTarget()
		{
		var vertex:NSPoint
		var angle:CGFloat
		
		CATransaction.begin()
		CATransaction.setValue(kCFBooleanTrue,forKey:kCATransactionDisableActions)
		vertex = endPoint.pointBySubtractingPoint(startPoint)
		angle = NSPoint.radiansToDegrees(vertex.theta())
		link = NSBezierPath()
		link.moveToPoint(startPoint)
		link.lineToPoint(endPoint)
		link.moveToPoint(endPoint.pointByAddingPoint(CGPoint(rho:0,theta:angle)))
		link.lineToPoint(endPoint.pointByAddingPoint(CGPoint(rho:12,theta:angle+160.0)))
		link.lineToPoint(endPoint.pointByAddingPoint(CGPoint(rho:12,theta:angle-160.0)))
		shapeLayer.path = link.CGPath
		shapeLayer.setNeedsDisplay()
		CATransaction.commit()
		}	
	}