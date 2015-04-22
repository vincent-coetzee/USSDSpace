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

class SlotLink:NSObject
	{
	var startPoint:NSPoint = NSPoint(x:0,y:0)
	var endPoint:NSPoint = NSPoint(x:0,y:0)
	var shapeLayer:CAShapeLayer = CAShapeLayer()
	var link:NSBezierPath = NSBezierPath()
	var lineWidth:CGFloat = 4
	var lineColor:NSColor = UFXStylist.LinkLineColor
	var shapeFrame:CGRect = CGRect(x:0,y:0,width:0,height:0)
	var targetMenu:USSDMenu?
	var targetSlot:TargetSlot?
	
	func disconnect(linkLayer:LinkManagementLayer)
		{
		linkLayer.removeLink(self)
		targetMenu!.removeLinkedTargetSlot(targetSlot!)
		}
		
	func encodeWithCoder(coder:NSCoder)
		{
		coder.encodePoint(startPoint,forKey:"startPoint")
		coder.encodePoint(endPoint,forKey:"endPoint")
		coder.encodeObject(shapeLayer,forKey:"shapeLayer")
		coder.encodeRect(shapeFrame,forKey:"shapeFrame")
		coder.encodeObject(link,forKey:"link")
		coder.encodeObject(targetMenu,forKey:"targetMenu")
		coder.encodeObject(targetSlot,forKey:"targetSlot")
		}
		
	required init(coder aDecoder: NSCoder) 
		{
	    startPoint = aDecoder.decodePointForKey("startPoint")
		endPoint = aDecoder.decodePointForKey("endPoint")
		shapeLayer = aDecoder.decodeObjectForKey("shapeLayer") as! CAShapeLayer
		shapeFrame = aDecoder.decodeRectForKey("shapeFrame")
		link = aDecoder.decodeObjectForKey("link") as! NSBezierPath
		targetMenu = aDecoder.decodeObjectForKey("targetMenu") as? USSDMenu
		targetSlot = aDecoder.decodeObjectForKey("targetSlot") as! TargetSlot?
		shapeLayer.lineCap = kCALineCapRound
		shapeLayer.strokeColor = lineColor.CGColor
		shapeLayer.fillColor = lineColor.CGColor
		}
		
	override init()
		{
		super.init()
		shapeLayer.strokeColor = lineColor.CGColor
		shapeLayer.fillColor = lineColor.CGColor
		shapeLayer.lineWidth = lineWidth
		shapeLayer.removeAllAnimations()
		shapeLayer.lineCap = kCALineCapRound
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

		vertex = subtractPoints(endPoint,startPoint)
		angle = radiansToDegrees(theta(vertex))
		link = NSBezierPath()
		link.moveToPoint(startPoint)
		link.lineToPoint(endPoint)
		link.moveToPoint(addPoints(endPoint,makePolarPoint(0,angle)))
		link.lineToPoint(addPoints(endPoint,makePolarPoint(12,angle+160.0)))
		link.lineToPoint(addPoints(endPoint,makePolarPoint(12,angle-160.0)))
		shapeLayer.path = link.CGPath
//		shapeFrame = link.bounds
//		shapeLayer.frame = shapeFrame
		shapeLayer.setNeedsDisplay()
		}
		
	func radiansToDegrees(r:CGFloat) -> CGFloat
		{
		return(CGFloat(r)*(CGFloat(180.0)/CGFloat(M_PI)))
		}
		
	func degreesToRadians(d:CGFloat) -> CGFloat
		{
		return(CGFloat(d*(CGFloat(M_PI)/CGFloat(180.0))))
		}
		
	func subtractPoints(s:NSPoint,_ f:NSPoint) -> NSPoint
		{
		return(NSPoint(x:s.x - f.x,y:s.y - f.y))
		}
	
	func addPoints(s:NSPoint,_ f:NSPoint) -> NSPoint
		{
		return(NSPoint(x:s.x+f.x,y:s.y+f.y))
		}
		
	func theta(point:NSPoint) -> CGFloat
		{
		var tan:CGFloat
		var theta:CGFloat
		
		if (point.x == 0)
			{
			return(point.y >= 0 ?  1.5708  :  4.71239);
			}
		else
			{
			tan = CGFloat(point.y)/CGFloat(point.x)
			theta = atan(tan)
			if point.x >= CGFloat(0) 
				{
				if point.y >= CGFloat(0) 
					{
					return(theta)
					}
				else
					{
					return(degreesToRadians(CGFloat(360))+theta)
					}
				}
			else
				{
				return(self.degreesToRadians(CGFloat(180))+theta)
				}
			}
		}

	func makePolarPoint(r:Int,_ theta:CGFloat) -> NSPoint
		{
		var rho:CGFloat
		var radians:CGFloat
		
		rho=CGFloat(r)
		radians = theta*CGFloat(M_PI)/CGFloat(180.0)
		return(NSPoint(x:rho*cos(radians),y:rho*sin(radians)))
		}	
	}