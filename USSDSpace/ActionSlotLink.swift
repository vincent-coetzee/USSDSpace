//
//  ActionSlotLink.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/23.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class ActionSlotLink:SlotLink
	{
	override func calculateBoundsAndUpdateTarget()
		{
		var vertex:NSPoint
		var angle:CGFloat
		var segment:NSLineSegment
		var midPoint:NSPoint
		var rect:CGRect
		
		vertex = subtractPoints(endPoint,startPoint)
		angle = radiansToDegrees(theta(vertex))
		link = NSBezierPath()
		link.moveToPoint(startPoint)
		link.lineToPoint(endPoint)
		link.moveToPoint(addPoints(endPoint,makePolarPoint(0,angle)))
		link.lineToPoint(addPoints(endPoint,makePolarPoint(12,angle+160.0)))
		link.lineToPoint(addPoints(endPoint,makePolarPoint(12,angle-160.0)))
		segment = NSLineSegment(start: startPoint,end:endPoint)
		midPoint = segment.midPoint()
		link.moveToPoint(midPoint)
		rect = CGRect(x:midPoint.x-10,y:midPoint.y-10,width:20,height:20)
		link.appendBezierPathWithOvalInRect(rect)
		shapeLayer.path = link.CGPath
//		shapeFrame = link.bounds
//		shapeLayer.frame = shapeFrame
		lineColor = UFXStylist.SelectionColor 
		shapeLayer.setNeedsDisplay()
		}
	}