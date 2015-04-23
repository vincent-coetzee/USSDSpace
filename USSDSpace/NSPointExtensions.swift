//
//  NSPointExtensions.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation

extension NSPoint
	{
	func pointBySubtractingPoint(point:NSPoint) -> NSPoint
		{
		return(NSPoint(x:self.x-point.x,y:self.y-point.y))
		}
		
	func pointByAddingPoint(point:NSPoint) -> NSPoint
		{
		return(NSPoint(x:self.x + point.x,y:self.y + point.y))
		}
		
	func distanceToPoint(point:NSPoint) -> CGFloat
		{
		var aFloat:CGFloat = hypot(point.x - self.x,point.y - self.y)
		return(aFloat)
		}
	}