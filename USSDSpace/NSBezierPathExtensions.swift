//
//  NSBezierPath+CGPath.swift
//  AlaCarte
//
//  Created by Vincent Coetzee on 2015/04/04.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit

extension NSBezierPath 
	{
	
	var CGPath: CGPathRef {
	
		get {
			return self.transformToCGPath()
		}
	}
	
	/// Transforms the NSBezierPath into a CGPathRef
	///
	/// - returns: The transformed NSBezierPath
	private func transformToCGPath() -> CGPathRef {
		
		// Create path
		let path = CGPathCreateMutable()
		let points = UnsafeMutablePointer<NSPoint>.alloc(3)
		let numElements = self.elementCount
		
		if numElements > 0 {
			
			var didClosePath = true
			
			for index in 0..<numElements {
				
				let pathType = self.elementAtIndex(index, associatedPoints: points)
				
				switch pathType {
					
				case .MoveToBezierPathElement:
					CGPathMoveToPoint(path, nil, points[0].x, points[0].y)
				case .LineToBezierPathElement:
					CGPathAddLineToPoint(path, nil, points[0].x, points[0].y)
					didClosePath = false
				case .CurveToBezierPathElement:
					CGPathAddCurveToPoint(path, nil, points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y)
					didClosePath = false
				case .ClosePathBezierPathElement:
					CGPathCloseSubpath(path)
					didClosePath = true
				}
			}
			
			if !didClosePath { CGPathCloseSubpath(path) }
		}
		
		points.dealloc(3)
		return path
	}
}