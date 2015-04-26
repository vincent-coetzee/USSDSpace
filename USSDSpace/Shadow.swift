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
		
	func setOnLayer(layer:CALayer)
		{
		layer.shadowRadius = radius
		layer.shadowColor = color.CGColor
		layer.shadowOpacity = Float(opacity)
		layer.shadowOffset = offset
		}
	}