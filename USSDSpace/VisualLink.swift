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
	private var sourceItem:VisualItem?
	private var targetItem:VisualItem?
	private var displayLayer:CAShapeLayer = CAShapeLayer()
	private var sourcePoint:CGPoint
	private var targetPoint:CGPoint
	private var linkColor:NSColor
	private var lineWidth:CGFloat 
	internal var linkShadow:Shadow = Shadow()
	
	override init()
		{
		sourcePoint = CGPoint(x:0,y:0)
		targetPoint = sourcePoint
		linkShadow.offset = CGSize(width:2,height:2)
		linkShadow.radius = 2
		linkShadow.opacity = 0.6
		linkShadow.color = NSColor.blackColor()
		linkColor = NSColor.lightGrayColor()
		lineWidth = 4
		super.init()
		applyStyle()
		}
		
	convenience required init(coder aDecoder: NSCoder) 
		{
		self.init(coder:aDecoder)
		sourcePoint = aDecoder.decodePointForKey("sourcePoint")
		targetPoint = aDecoder.decodePointForKey("targetPoint")
		displayLayer = aDecoder.decodeObjectForKey("displayLayer") as! CAShapeLayer
		linkColor = aDecoder.decodeObjectForKey("linkColor") as! NSColor
		sourceItem = aDecoder.decodeObjectForKey("sourceItem") as! VisualItem?
		targetItem = aDecoder.decodeObjectForKey("targetItem") as! VisualItem?
		lineWidth = CGFloat(aDecoder.decodeDoubleForKey("lineWidth"))
		linkShadow = aDecoder.decodeObjectForKey("linkShadow") as! Shadow
		linkShadow.setOnLayer(displayLayer)
		applyStyle()
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
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodePoint(sourcePoint,forKey:"sourcePoint")
		coder.encodePoint(targetPoint,forKey:"targetPoint")
		coder.encodeObject(displayLayer,forKey:"displayLayer")
		coder.encodeObject(linkColor,forKey:"linkColor")
		coder.encodeObject(shadowColor,forKey:"shadowColor")
		coder.encodeObject(sourceItem,forKey:"sourceItem")
		coder.encodeObject(targetItem,forKey:"targetItem")
		coder.encodeDouble(Double(lineWidth),forKey:"lineWidth")
		coder.encodeObject(linkShadow,forKey:"linkShadow")
		}
		
	func setSourceItem(item:VisualItem)
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
		
	func setTargetItem(item:VisualItem)
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
		
	func setTargetPoint(point:CGPoint)
		{
		targetPoint = point
		updateDisplay()
		}
		
	override func frameChanged(item:VisualItem)
		{
		if item == sourceItem!.topItem
			{
			sourcePoint = sourceItem!.frameAsViewFrame().centerPoint
			updateDisplay()
			}
		else if item == targetItem!
			{
			targetPoint = targetItem!.frameAsViewFrame().pointOnPerimeterNearestToPoint(sourcePoint)
			updateDisplay()
			}
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