//
//  NSPointExtensions.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 Olamide. All rights reserved.
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
	}