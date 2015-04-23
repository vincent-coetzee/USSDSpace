//
//  NSRectExtensions.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation

func maximum(a:CGFloat,b:CGFloat) -> CGFloat
	{
	return(a < b ? b : a)
	}
	
func minimum(a:CGFloat,b:CGFloat) -> CGFloat
	{
	return(a < b ? a : b)
	}
	
func clamp(x:CGFloat,lower:CGFloat,upper:CGFloat) -> CGFloat
	{
	return(maximum(lower,minimum(upper,x)))
	}
	
extension NSRect
	{
//	func pointOnPerimeterNearestToPoint(point:NSPoint) -> NSPoint
//		{
//		var r:CGFloat
//		var b:CGFloat
//		var dl:CGFloat
//		var dr:CGFloat
//		var dt:CGFloat
//		var db:CGFloat
//		var m:CGFloat
//		
//		r = CGRectGetMinX(self) + self.size.width
//		b = CGRectGetMinY(self) + self.size.height
//		dl = fabs(point.x - CGRectGetMinX(self))
//		dr = fabs(point.x - CGRectGetMaxX(self))
//		dt = fabs(point.y - CGRectGetMinY(self))
//		db = fabs(point.y - CGRectGetMaxY(self))
//		m = minimum(minimum(dl,dr),minimum(dt,db))
//		if m == dt
//			{
//			return(NSPoint(x:point.x,y:CGRectGetMinY(self)))
//			}
//		if m == db 
//			{
//			return(NSPoint(x:point.x,y:CGRectGetMaxY(self)))
//			}
//		if m == dl
//			{
//			return(NSPoint(x:CGRectGetMinX(self),y:point.y))
//			}
//		return(NSPoint(x:CGRectGetMaxX(self),y:point.y))
//		}
				
	func pointOnPerimeterNearestToPoint(point:NSPoint) -> NSPoint
		{
		var x = point.x
		var y = point.y
		var l = CGRectGetMinX(self)
		var r = CGRectGetMaxX(self)
		var t = CGRectGetMinY(self)
		var b = CGRectGetMaxY(self)
		var inside = true
		
		if x < l 
			{
			x = l
			inside = false
			}
		if x > r
			{
			x = r
			inside = false
			}
		if y < t
			{
			y = t
			inside = false
			}
		if y > b
			{
			y = b
			inside = false
			}
		if inside
			{
			var dt = fabs(y - t)
			var db = fabs(y - b)
			var dl = fabs(x - l)
			var dr = fabs(x - r)
			if dt <= db && dt <= dl && dt <= dr
				{
				y = t
				}
			else if db <= dl && db <= dr
				{
				y = b
				}
			else if dl <= dr
				{
				x = l
				}
			else
				{
				x = r
				}
			}
		return(NSPoint(x:x,y:y))
		}
		
	func rectByAddingPointToOrigin(point:NSPoint) -> NSRect
		{
		return(NSRect(origin:self.origin.pointByAddingPoint(point),size:self.size))
		}
		
	var centerPoint:NSPoint
		{
		get
			{
			return(NSPoint(x:CGRectGetMidX(self),y:CGRectGetMidY(self)))
			}
		}
		
	var topLeft:NSPoint
		{
		get
			{
			return(NSPoint(x:CGRectGetMinX(self),y:CGRectGetMinY(self)))
			}
		}
		
	var topRight:NSPoint
		{
		get
			{
			return(NSPoint(x:CGRectGetMaxX(self),y:CGRectGetMinY(self)))
			}
		}
		
	var bottomRight:NSPoint
		{
		get
			{
			return(NSPoint(x:CGRectGetMaxX(self),y:CGRectGetMaxY(self)))
			}
		}
		
	var bottomLeft:NSPoint
		{
		get
			{
			return(NSPoint(x:CGRectGetMinX(self),y:CGRectGetMaxY(self)))
			}
		}
		
	var leftEdge:NSLineSegment
		{
		get
			{
			return(NSLineSegment(start:topLeft,end:bottomLeft))
			}
		}
		
	var topEdge:NSLineSegment
		{
		get
			{
			return(NSLineSegment(start:topLeft,end:topRight))
			}
		}	
		
	var rightEdge:NSLineSegment
		{
		get
			{
			return(NSLineSegment(start:topRight,end:bottomRight))
			}
		}	
		
	var bottomEdge:NSLineSegment
		{
		get
			{
			return(NSLineSegment(start:bottomLeft,end:bottomRight))
			}
		}
		
	func pointOfIntersectionWithLine(line:NSLineSegment) -> NSPoint?
		{
		var point = line.pointOfIntersectionWithLine(leftEdge)
		if point != nil
			{
			return(point!)
			}
		point = line.pointOfIntersectionWithLine(topEdge)
		if point != nil
			{
			return(point!)
			}
		point = line.pointOfIntersectionWithLine(rightEdge)
		if point != nil
			{
			return(point!)
			}
		point = line.pointOfIntersectionWithLine(bottomEdge)
		if point != nil
			{
			return(point!)
			}
		return(nil)
		}
	}