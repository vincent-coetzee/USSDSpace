//
//  VisualLink.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/26.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class VisualLink:VisualItem
	{
	var sourceItem:VisualItem?
	var targetItem:VisualItem?
	var displayLayer:CAShapeLayer = CAShapeLayer()
	var sourcePoint:CGPoint = CGPoint(x:0,y:0)
	var targetPoint:CGPoint = CGPoint(x:0,y:0)
	var linkColor:NSColor = NSColor.blackColor()
	var lineWidth:CGFloat = 1
	var linkShadow:Shadow = Shadow()
	
	override init()
		{
		sourcePoint = CGPoint(x:0,y:0)
		targetPoint = sourcePoint
		linkShadow.offset = CGSize(width:2,height:2)
		linkShadow.radius = 2
		linkShadow.opacity = 0.6
		linkShadow.color = NSColor.blackColor()
		linkColor = UFXStylist.SlotLinkColor
		lineWidth = 4
		super.init()
		applyStyle()
		}
		
	required init(coder aDecoder: NSCoder) 
		{
		super.init(coder: aDecoder)
		sourcePoint = aDecoder.decodePointForKey("sourcePoint")
		targetPoint = aDecoder.decodePointForKey("targetPoint")
		displayLayer = aDecoder.decodeObjectForKey("displayLayer") as! CAShapeLayer
		linkColor = aDecoder.decodeObjectForKey("linkColor") as! NSColor
		sourceItem = aDecoder.decodeObjectForKey("sourceItem") as! VisualItem?
		targetItem = aDecoder.decodeObjectForKey("targetItem") as! VisualItem?
		lineWidth = CGFloat(aDecoder.decodeDoubleForKey("VL.lineWidth"))
		linkShadow = aDecoder.decodeObjectForKey("linkShadow") as! Shadow
		linkShadow.setOnLayer(displayLayer)
		applyStyle()
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodePoint(sourcePoint,forKey:"sourcePoint")
		coder.encodePoint(targetPoint,forKey:"targetPoint")
		coder.encodeObject(displayLayer,forKey:"displayLayer")
		coder.encodeObject(linkColor,forKey:"linkColor")
		coder.encodeObject(sourceItem,forKey:"sourceItem")
		if targetItem == nil
			{
			NSLog("halt")
			}
		coder.encodeObject(targetItem,forKey:"targetItem")
		coder.encodeDouble(Double(lineWidth),forKey:"VL.lineWidth")
		coder.encodeObject(linkShadow,forKey:"linkShadow")
		}
		
	func closestSlotToTarget(slot1:VisualSlot,slot2:VisualSlot) -> VisualSlot
		{
		var targetSlot:TargetSlot
		var slot1Distance:CGFloat
		var slot2Distance:CGFloat
		var sisterDistance:CGFloat
		var startPoint:CGPoint
		var aStartPoint:CGPoint
		
		aStartPoint = slot1.frameAsViewFrame().centerPoint
		slot1Distance = aStartPoint.distanceToPoint(targetPoint)
		aStartPoint = slot2.frameAsViewFrame().centerPoint
		slot2Distance = aStartPoint.distanceToPoint(targetPoint)
		if slot1Distance < slot2Distance
			{
			return(slot1)
			}
		else
			{
			return(slot2)
			}
		}
		
	func applyStyle()
		{
		displayLayer.lineWidth = lineWidth
		displayLayer.fillColor = linkColor.CGColor
		displayLayer.strokeColor = linkColor.CGColor
		displayLayer.shadowColor = linkShadow.color.CGColor
		displayLayer.shadowOffset = linkShadow.offset
		displayLayer.shadowOpacity = Float(linkShadow.opacity)
		displayLayer.shadowRadius = linkShadow.radius
		displayLayer.lineCap = kCALineCapRound
		displayLayer.borderColor = NSColor.cyanColor().CGColor
		displayLayer.borderWidth = 5
		}
		
	func setSource(item:VisualItem)
		{
		sourceItem = item
		sourceItem!.topItem!.addFrameDependent(self)
		sourcePoint = sourceItem!.frameAsViewFrame().centerPoint
		if sourceItem != nil && targetItem != nil
			{
			updateDisplay()
			}
		}
		
	func disconnect(view:DesignView)
		{
		view.removeLink(self)
		sourceItem!.topItem!.removeFrameDependent(self)
		targetItem!.removeFrameDependent(self)
		sourceItem = nil
		targetItem = nil
		}
		
	func setTarget(item:VisualItem)
		{
		targetItem = item
		targetItem!.addFrameDependent(self)
		targetPoint = targetItem!.frameAsViewFrame().pointOnPerimeterNearestToPoint(sourcePoint)
		if sourceItem != nil && targetItem != nil
			{
			updateDisplay()
			}
		}
		
	func addToLayer(layer:CALayer)
		{
		layer.addSublayer(displayLayer)
		}
		
	func removeFromLayer(layer:CALayer)
		{
		displayLayer.removeFromSuperlayer()
		}
		
	func setDirectTargetPoint(point:CGPoint)
		{
		targetPoint = point
		updateDisplay()
		}
		
	override func frameChanged(item:VisualItem)
		{
		sourcePoint = sourceItem!.frameAsViewFrame().centerPoint
		targetPoint = targetItem!.frameAsViewFrame().pointOnPerimeterNearestToPoint(sourcePoint)
		sourceItem!.adjustForLinkChanges(self,source:sourceItem!,target:targetItem!)
		updateDisplay()
		}
		
	func sourceFrameChanged()
		{
		sourcePoint = sourceItem!.centerPoint
		updateDisplay()
		}
		
	func targetFrameChanged()
		{
		targetPoint = targetItem!.frameAsViewFrame().pointOnPerimeterNearestToPoint(sourcePoint)
		updateDisplay()
		}
		
	func updateDisplay()
		{
		var vertex:NSPoint
		var angle:CGFloat
		var path:NSBezierPath
		
		CATransaction.begin()
		CATransaction.setValue(kCFBooleanTrue,forKey:kCATransactionDisableActions)
		vertex = targetPoint.pointBySubtractingPoint(sourcePoint)
		angle = NSPoint.radiansToDegrees(vertex.theta())
		path = NSBezierPath()
		path.moveToPoint(sourcePoint)
		path.lineToPoint(targetPoint)
		path.moveToPoint(targetPoint.pointByAddingPoint(CGPoint(rho:0,theta:angle)))
		path.lineToPoint(targetPoint.pointByAddingPoint(CGPoint(rho:12,theta:angle+160.0)))
		path.lineToPoint(targetPoint.pointByAddingPoint(CGPoint(rho:12,theta:angle-160.0)))
		displayLayer.path = path.CGPath
		displayLayer.setNeedsDisplay()
		CATransaction.commit()
		}
	}