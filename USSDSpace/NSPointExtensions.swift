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
		let aFloat:CGFloat = hypot(point.x - self.x,point.y - self.y)
		return(aFloat)
		}
		
	static func radiansToDegrees(r:CGFloat) -> CGFloat
		{
		return(CGFloat(r)*(CGFloat(180.0)/CGFloat(M_PI)))
		}
		
	static func degreesToRadians(d:CGFloat) -> CGFloat
		{
		return(CGFloat(d*(CGFloat(M_PI)/CGFloat(180.0))))
		}
		
	func theta() -> CGFloat
		{
		var tan:CGFloat
		var theta:CGFloat
		
		if (self.x == 0)
			{
			return(self.y >= 0 ?  1.5708  :  4.71239);
			}
		else
			{
			tan = CGFloat(self.y)/CGFloat(self.x)
			theta = atan(tan)
			if self.x >= CGFloat(0) 
				{
				if self.y >= CGFloat(0) 
					{
					return(theta)
					}
				else
					{
					return(self.dynamicType.degreesToRadians(CGFloat(360))+theta)
					}
				}
			else
				{
				return(self.dynamicType.degreesToRadians(CGFloat(180))+theta)
				}
			}
		}
		
	init(rho:CGFloat,theta:CGFloat)
		{
		var radians:CGFloat
		
		radians = theta*CGFloat(M_PI)/CGFloat(180.0)
		self.init(x:rho*cos(radians),y:rho*sin(radians))
		}
	}