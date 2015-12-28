//
//  NSColorExtensions.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/22.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit

extension NSColor
	{
	class func colorWithUnscaled(red:CGFloat,green:CGFloat,blue:CGFloat) -> NSColor
		{
		return(NSColor(red:red/255.0,green:green/255.0,blue:blue/255.0,alpha:1.0))
		}
		
	class func percentGray(percentage:CGFloat) -> NSColor
		{
		return(NSColor(calibratedWhite:percentage,alpha:1.0))
		}
		
	func lighter() -> NSColor
		{
		return(adjustSaturation(-0.03,brightness:0.08))
		}
		
	func adjustSaturation(saturation:CGFloat,brightness:CGFloat) -> NSColor
		{
		var a:CGFloat = 0
		var h:CGFloat = 0
		var s:CGFloat = 0
		var b:CGFloat = 0

		getHue(&h,saturation:&s,brightness:&b,alpha:&a)
		return(NSColor(hue: h,saturation: s+maximum(0.005,b: minimum(saturation,b: 1.0)),brightness: b+maximum(0.005,b: minimum(brightness,b: 1.0)),alpha: a))
		}
		
	func withAlpha(alpha:CGFloat) -> NSColor
		{
		var r:CGFloat = 0
		var g:CGFloat = 0
		var b:CGFloat = 0
		var a:CGFloat = 0
		
		getRed(&r,green:&g,blue:&b,alpha:&a)
		return(NSColor(red: r,green: g,blue:b,alpha:alpha))
		}
		
	}