//
//  VisualActionLink.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/27.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class VisualActionLink:VisualLink
	{
	var bubbleLayer:CALayer = CALayer()
	var bubbleRect:CGRect?
	
	required convenience init(coder aDecoder: NSCoder) 
		{
		self.init(coder:aDecoder)
		bubbleLayer = aDecoder.decodeObjectForKey("bubbleLayer") as! CALayer
		bubbleRect = aDecoder.decodeRectForKey("bubbleRect")
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeObject(bubbleLayer,forKey:"bubbleLayer")
		coder.encodeRect(bubbleRect,forKey:"bubbleRect")
		}
		
	override func updateDisplay()
		{
		var vertex:NSPoint
		var angle:CGFloat
		var path:NSBezierPath
		var segment:NSLineSegment
		var midPoint:CGPoint
		var rect:CGRect
		
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
		segment = NSLineSegment(start: sourcePoint,end:targetPoint)
		midPoint = segment.midPoint()
		path.moveToPoint(midPoint)
		rect = CGRect(x:midPoint.x-15,y:midPoint.y-15,width:30,height:30)
		path.appendBezierPathWithOvalInRect(rect)
		bubbleLayer.frame = rect
		bubbleRect = rect
		displayLayer.path = path.CGPath
		displayLayer.setNeedsDisplay()
		CATransaction.commit()
		}
		
	override func applyStyle()
		{
		linkColor = UFXStylist.ActionSlotLinkColor
		bubbleLayer.contents = NSImage(named:"ActiveItemBall-24x24")
		super.applyStyle()
		}
		
	override func addToLayer(layer:CALayer)
		{
		super.addToLayer(layer)
		layer.addSublayer(bubbleLayer)
		}
		
	override func removeFromLayer(layer:CALayer)
		{
		super.removeFromLayer(layer)
		bubbleLayer.removeFromSuperlayer()
		}
	}