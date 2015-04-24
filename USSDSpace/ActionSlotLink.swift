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
	var bubbleRect:CGRect?
	var editor:ActionItemEditor?
	
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
		link.lineToPoint(addPoints(endPoint,makePolarPoint(0,angle)))
		segment = NSLineSegment(start: startPoint,end:endPoint)
		midPoint = segment.midPoint()
		link.moveToPoint(midPoint)
		rect = CGRect(x:midPoint.x-15,y:midPoint.y-15,width:30,height:30)
		bubbleRect = rect
		link.appendBezierPathWithOvalInRect(rect)
		shapeLayer.path = link.CGPath
		shapeLayer.setNeedsDisplay()
		}
		
	override func closeEditor()
		{
		sourceItem!.updateAfterEdit()
		editor!.close()
		editor = nil
		}
		
	override func editLinkInView(aView:NSView)
		{
		editor = ActionItemEditor()
		editor!.openOnRect(bubbleRect!,inView:aView,actionItem:(sourceItem as! USSDActionMenuItem))
		}
	}