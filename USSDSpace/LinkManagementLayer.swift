//
//  LinkManagementLayer.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class LinkManagementLayer:CALayer
	{
	private var potentialLink:SlotLink?
	private var links:[SlotLink] = [SlotLink]()
	var visualLinks:[VisualLink] = [VisualLink]()
	
	override func contentsAreFlipped() -> Bool
		{
		return(true)
		}
		
	override var geometryFlipped:Bool
		{
		get
			{
			return(true)
			}
		set
			{
			}
		}
		
	override init()
		{
		super.init()
		self.removeAllAnimations()
		}
		
	override init(layer:AnyObject)
		{
		super.init(layer:layer)
		}
		
	func linkContainingPoint(point:NSPoint) -> SlotLink?
		{
		for link in links
			{
			if link.containsPoint(point)
				{
				return(link)
				}
			}
		return(nil)
		}
		
	func addVisualLink(link:VisualLink)
		{
		CATransaction.begin()
		CATransaction.setValue(kCFBooleanTrue,forKey:kCATransactionDisableActions)
		visualLinks.append(link)
		link.addToLayer(self)
		CATransaction.commit()
		}
		
	func removeVisualLink(link:VisualLink)
		{
		var index = find(visualLinks,link)
		if index != nil
			{
			CATransaction.begin()
			CATransaction.setValue(kCFBooleanTrue,forKey:kCATransactionDisableActions)
			link.removeFromLayer(self)
			visualLinks.removeAtIndex(index!)
			CATransaction.commit()
			}
		}
		
	func reset()
		{
		for link in visualLinks
			{
			link.removeFromLayer(self)
			}
		visualLinks = [VisualLink]()
		for link in links
			{
			link.shapeLayer.removeFromSuperlayer()
			link.bubbleLayer!.removeFromSuperlayer()
			}
		links = [SlotLink]()
		if potentialLink != nil
			{
			potentialLink!.shapeLayer.removeFromSuperlayer()
			potentialLink!.bubbleLayer!.removeFromSuperlayer()
			potentialLink = nil
			}
		}

	required init(coder aDecoder: NSCoder) 
		{
	    fatalError("init(coder:) has not been implemented")
		}
		
	func addLink(link:SlotLink)
		{
		CATransaction.begin()
		CATransaction.setValue(kCFBooleanTrue,forKey:kCATransactionDisableActions)
		links.append(link)
		var shapeLayer = link.shapeLayer
		addSublayer(shapeLayer)
		addSublayer(link.bubbleLayer)
		shapeLayer.frame = link.shapeLayerFrame()
		shapeLayer.setNeedsDisplay()
		CATransaction.commit()
		}
		
	func removeLink(link:SlotLink)
		{
		CATransaction.begin()
		CATransaction.setValue(kCFBooleanTrue,forKey:kCATransactionDisableActions)
		link.shapeLayer.removeFromSuperlayer()
		link.bubbleLayer!.removeFromSuperlayer()
		var index = find(links,link)
		if index != nil
			{
			links.removeAtIndex(index!)
			}
		CATransaction.commit()
		}
		
	func removePotentialLink(link:SlotLink)
		{
		link.shapeLayer.removeFromSuperlayer()
		link.bubbleLayer!.removeFromSuperlayer()
		setNeedsDisplay()
		potentialLink = nil
		}
		
//	override func drawInContext(context:CGContext!)
//		{
//		var pathToBeDrawn:CGPathRef
//		var	bubbleImage:NSImage?
//		
//		NSLog("drawInContext")
//		CGContextSaveGState(context)
//		if potentialLink != nil
//			{
//			pathToBeDrawn = potentialLink!.link.CGPath
//			CGContextSetShadowWithColor(context,CGSize(width:2,height:2),2,NSColor.blackColor().CGColor)
//			CGContextSetLineCap(context,kCGLineCapRound)
//			CGContextSetLineWidth(context,4)
//			CGContextSetStrokeColorWithColor(context,UFXStylist.StartMenuLinkColor.CGColor)
//			CGContextSetFillColorWithColor(context,UFXStylist.StartMenuLinkColor.CGColor)
//			CGContextBeginPath(context)
//			CGContextAddPath(context,pathToBeDrawn)
//			CGContextDrawPath(context,kCGPathFillStroke)
//			if potentialLink!.bubbleImage != nil && savedBubbleImage != nil
//				{  
//				var imageRect:CGRect = potentialLink!.bubbleRect!  
//				var imageSize = imageRect.size
//				CGContextTranslateCTM(context,0,imageSize.height);
//				CGContextScaleCTM(context,1.0,-1.0);
//				CGContextDrawImage(context,imageRect,savedBubbleImage);
//				CGContextScaleCTM(context, 1.0, -1.0);
//				CGContextTranslateCTM(context, 0, -imageRect.size.height);
//				}
//			}
//		CGContextRestoreGState(context)
//		}
		
	func addPotentialLink(link:SlotLink)
		{
		CATransaction.begin()
		CATransaction.setValue(kCFBooleanTrue,forKey:kCATransactionDisableActions)
		potentialLink = link
//		if potentialLink!.bubbleImage != nil
//			{
//			var imageRect = NSRect(origin:NSPoint(x:0,y:0),size:potentialLink!.bubbleRect!.size)
//			savedBubbleImage = potentialLink!.bubbleImage!.CGImageForProposedRect(&imageRect,context:nil,hints:nil)?.takeUnretainedValue()
//			}
		var shapeLayer = link.shapeLayer
		addSublayer(shapeLayer)
		addSublayer(link.bubbleLayer)
		shapeLayer.frame = link.shapeLayerFrame()
		shapeLayer.setNeedsDisplay()
		link.parentLayer = self
		CATransaction.commit()
		}
	}