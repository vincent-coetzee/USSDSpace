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
		
	func reset()
		{
		for link in links
			{
			link.shapeLayer.removeFromSuperlayer()
			}
		links = [SlotLink]()
		if potentialLink != nil
			{
			potentialLink!.shapeLayer.removeFromSuperlayer()
			potentialLink = nil
			}
		}

	required init(coder aDecoder: NSCoder) 
		{
	    fatalError("init(coder:) has not been implemented")
		}
		
	func addLink(link:SlotLink)
		{
		links.append(link)
		var shapeLayer = link.shapeLayer
		addSublayer(shapeLayer)
		shapeLayer.frame = link.shapeLayerFrame()
		shapeLayer.setNeedsDisplay()
		}
		
	func removeLink(link:SlotLink)
		{
		link.shapeLayer.removeFromSuperlayer()
		var index = find(links,link)
		if index != nil
			{
			links.removeAtIndex(index!)
			}
		}
		
	func removePotentialLink(link:SlotLink)
		{
		link.shapeLayer.removeFromSuperlayer()
		potentialLink = nil
		}
		
	func addPotentialLink(link:SlotLink)
		{
		potentialLink = link
		var shapeLayer = link.shapeLayer
		addSublayer(shapeLayer)
		shapeLayer.frame = link.shapeLayerFrame()
		shapeLayer.setNeedsDisplay()
		}
	}