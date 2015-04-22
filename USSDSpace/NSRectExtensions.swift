//
//  NSRectExtensions.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation

extension NSRect
	{
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