//
//  Shadow.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/27.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit

class Shadow:NSObject
	{
	var radius:CGFloat
	var offset:CGSize
	var opacity:CGFloat
	var color:NSColor
	
	override init()
		{
		radius = 5
		offset = CGSize(width:0,height:0)
		opacity = 0.6
		color = NSColor.blackColor()
		}
		
	init(coder aDecoder:NSCoder)
		{
		radius = CGFloat(aDecoder.decodeDoubleForKey("Shadow.radius"))
		offset = aDecoder.decodeSizeForKey("Shadow.offset")
		opacity = CGFloat(aDecoder.decodeDoubleForKey("Shadow.opacity"))
		color = aDecoder.decodeObjectForKey("Shadow.color") as! NSColor
		}
		
	func encodeWithCoder(coder:NSCoder)
		{
		coder.encodeDouble(Double(radius),forKey:"Shadow.radius")
		coder.encodeSize(offset,forKey:"Shadow.offset")
		coder.encodeDouble(Double(opacity),forKey:"Shadow.opacity")
		coder.encodeObject(color,forKey:"Shadow.color")
		}
		
	func setOnLayer(layer:CALayer)
		{
		layer.shadowRadius = radius
		layer.shadowColor = color.CGColor
		layer.shadowOpacity = Float(opacity)
		layer.shadowOffset = offset
		}
	}