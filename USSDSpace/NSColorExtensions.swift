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
	}