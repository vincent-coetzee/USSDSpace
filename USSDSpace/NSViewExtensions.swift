//
//  NSViewExtensions.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/23.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit

extension NSView
	{
	func layerFromContents() -> CALayer
		{
		let newLayer:CALayer = CALayer()
		let imageRep = self.bitmapImageRepForCachingDisplayInRect(self.bounds)
		
		newLayer.bounds = self.bounds
		cacheDisplayInRect(self.bounds,toBitmapImageRep: imageRep!)
		newLayer.contents = imageRep
		return(newLayer)
		}
	}