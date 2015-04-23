//
//  NSLineSegment.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/08.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Cocoa

class NSLineSegment: NSObject 
	{
	var startPoint:NSPoint = NSPoint(x:0,y:0)
	var endPoint:NSPoint = NSPoint(x:0,y:0)

	init(start:NSPoint,end:NSPoint)
		{
		startPoint = start
		endPoint = end
		}
	
	func midPoint() -> NSPoint
		{
		var midPoint = NSPoint(x:0,y:0)
	
		midPoint.x = ( startPoint.x + endPoint.x ) * 0.5
		midPoint.y = ( startPoint.y + endPoint.y ) * 0.5
		return(midPoint)
		}

	func numbersHaveSameSign(first:CGFloat,second:CGFloat) -> Bool
		{
		if first < 0 && second < 0
			{
			return(true)
			}
		else if first >= 0 && second >= 0
			{
			return(true)
			}
		else
			{
			return(false)
			}
		}
		
	func pointOfIntersectionWithLine(other:NSLineSegment) -> NSPoint?
		{
		var x1:CGFloat = 0
		var x2:CGFloat = 0
		var x3:CGFloat = 0
		var x4:CGFloat = 0
		var y1:CGFloat = 0
		var y2:CGFloat = 0
		var y3:CGFloat = 0
		var y4:CGFloat = 0
		var a1:CGFloat = 0
		var a2:CGFloat = 0
		var b1:CGFloat = 0
		var b2:CGFloat = 0
		var c1:CGFloat = 0
		var c2:CGFloat = 0
		var r1:CGFloat = 0
		var r2:CGFloat = 0
		var r3:CGFloat = 0
		var r4:CGFloat = 0
		var denom:CGFloat = 0
		var offset:CGFloat = 0
		var num:CGFloat = 0
		var point:NSPoint = NSPoint(x:0,y:0)
		
		x1 = startPoint.x
		y1 = startPoint.y
		x2 = endPoint.x
		y2 = endPoint.y
		x3 = other.startPoint.x
		y3 = other.startPoint.y
		x4 = other.endPoint.x
		y4 = other.endPoint.y
		/* Compute a1, b1, c1, where line joining points 1 and 2
		* is "a1 x  +  b1 y  +  c1  =  0".
		*/
		a1 = y2 - y1;
		b1 = x1 - x2;
		c1 = x2 * y1 - x1 * y2;
		/* Compute r3 and r4.
		*/
		r3 = a1 * x3 + b1 * y3 + c1;
		r4 = a1 * x4 + b1 * y4 + c1;
		/* Check signs of r3 and r4.  If both point 3 and point 4 lie on
		* same side of line 1, the line segments do not intersect.
		*/
		if r3 != 0 && r4 != 0 && numbersHaveSameSign(r3,second: r4)
			{
			return(nil);
			}
		/* Compute a2, b2, c2 */
		a2 = y4 - y3;
		b2 = x3 - x4;
		c2 = x4 * y3 - x3 * y4;
		/* Compute r1 and r2 */
		r1 = a2 * x1 + b2 * y1 + c2;
		r2 = a2 * x2 + b2 * y2 + c2;
		/* Check signs of r1 and r2.  If both point 1 and point 2 lie
		* on same side of second line segment, the line segments do
		* not intersect.
		*/
		if r1 != 0 && r2 != 0 && numbersHaveSameSign(r1,second: r2)
			{
			return(nil)
			}
		/* Line segments intersect: compute intersection point. 
		*/
		denom = a1 * b2 - a2 * b1;
		if denom == 0 
			{
			return(nil)
			}
		offset = denom < 0 ? -denom / 2 : denom / 2
		/* The denom/2 is to get rounding instead of truncating.  It
		 * is added or subtracted to the numerator, depending upon the
		 * sign of the numerator.
		 */
		num = b1 * c2 - b2 * c1
		point.x = ( num < 0 ? num - offset : num + offset ) / denom
		num = a2 * c1 - a1 * c2
		point.y = ( num < 0 ? num - offset : num + offset ) / denom;
		return(point)
		}
	}
