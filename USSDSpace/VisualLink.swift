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

class VisualLink:NSObject
	{
	private var sourceItem:VisualItem?
	private var targetItem:VisualItem?
	private var displayLayer:CAShapeLayer = CAShapeLayer()
	private var sourcePoint:CGPoint
	private var targetPoint:CGPoint
	private var linkColor:NSColor
	private var lineWidth:CGFloat 
	private var shadowOffset:CGSize
	private var shadowOpacity:CGFloat
	private var shadowRadius:CGFloat
	private var shadowColor:NSColor
	
	override init()
		{
		sourcePoint = CGPoint(x:0,y:0)
		targetPoint = sourcePoint
		shadowOffset = CGSize(width:2,height:2)
		shadowRadius = 2
		shadowOpacity = 0.6
		shadowColor = NSColor.blackColor()
		linkColor = NSColor.grayColor()
		lineWidth = 4
		super.init()
		applyStyle()
		}
		
	convenience init(coder aDecoder: NSCoder) 
		{
		self.init(coder:aDecoder)
		sourcePoint = aDecoder.decodePointForKey("sourcePoint")
		targetPoint = aDecoder.decodePointForKey("targetPoint")
		displayLayer = aDecoder.decodeObjectForKey("displayLayer") as! CAShapeLayer
		linkColor = aDecoder.decodeObjectForKey("linkColor") as! NSColor
		sourceItem = aDecoder.decodeObjectForKey("sourceItem") as! VisualItem?
		targetItem = aDecoder.decodeObjectForKey("targetItem") as! VisualItem?
		lineWidth = CGFloat(aDecoder.decodeDoubleForKey("lineWidth"))
		shadowOffset = aDecoder.decodeSizeForKey("shadowOffset")
		shadowOpacity = CGFloat(aDecoder.decodeDoubleForKey("shadowOpacity"))
		shadowColor = aDecoder.decodeObjectForKey("shadowColor") as! NSColor
		shadowRadius = CGFloat(aDecoder.decodeDoubleForKey("shadowRadius"))
		applyStyle()
		}
		
	func applyStyle()
		{
		displayLayer.lineWidth = lineWidth
		displayLayer.fillColor = linkColor.CGColor
		displayLayer.strokeColor = linkColor.CGColor
		displayLayer.shadowColor = shadowColor.CGColor
		displayLayer.shadowOffset = shadowOffset
		displayLayer.shadowOpacity = Float(shadowOpacity)
		displayLayer.shadowRadius = shadowRadius
		}
		
	func encodeWithCoder(coder:NSCoder)
		{
		coder.encodePoint(sourcePoint,forKey:"sourcePoint")
		coder.encodePoint(targetPoint,forKey:"targetPoint")
		coder.encodeObject(displayLayer,forKey:"displayLayer")
		coder.encodeObject(linkColor,forKey:"linkColor")
		coder.encodeObject(shadowColor,forKey:"shadowColor")
		coder.encodeObject(sourceItem,forKey:"sourceItem")
		coder.encodeObject(targetItem,forKey:"targetItem")
		coder.encodeDouble(Double(lineWidth),forKey:"lineWidth")
		coder.encodeSize(shadowOffset,forKey:"shadowOffset")
		coder.encodeDouble(Double(shadowRadius),forKey:"shadowRadius")
		coder.encodeDouble(Double(shadowOpacity),forKey:"shadowOpacity")
		}
		
	func setSourceItem(item:VisualItem)
		{
		sourceItem = item
		if sourceItem != nil
			{
			sourcePoint = sourceItem!.centerPoint
			}
		if sourceItem != nil && targetItem != nil
			{
			updateDisplay()
			}
		}
		
	func setTargetItem(item:VisualItem)
		{
		targetItem = item
		if sourceItem != nil
			{
			targetPoint = targetItem!.centerPoint
			}
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
		
	func sourceFrameChanged()
		{
		sourcePoint = sourceItem!.centerPoint
		updateDisplay()
		}
		
	func targetFrameChanged()
		{
		targetPoint = targetItem!.frame.pointOnPerimeterNearestToPoint(sourcePoint)
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