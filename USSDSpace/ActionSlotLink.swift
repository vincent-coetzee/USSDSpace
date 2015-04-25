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
	var editor:ActionItemEditor?
	
	override func calculateBoundsAndUpdateTarget()
		{
		var vertex:NSPoint
		var angle:CGFloat
		var segment:NSLineSegment
		var midPoint:NSPoint
		var rect:CGRect
		var myBounds:CGRect
		
		CATransaction.begin()
		CATransaction.setValue(kCFBooleanTrue,forKey:kCATransactionDisableActions)
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
		bubbleLayer!.frame = rect
		bubbleRect = rect
		link.appendBezierPathWithOvalInRect(rect)
		shapeLayer.path = link.CGPath
		shapeLayer.setNeedsDisplay()
		CATransaction.commit()
		}
		
	override init()
		{
		super.init()
		bubbleImage = NSImage(named:"ActiveItemBall-24x24")
		bubbleLayer!.frame = CGRect(x:0,y:0,width:24,height:24)
		bubbleLayer!.contents = bubbleImage
		}

	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		}
		
	required init(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
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