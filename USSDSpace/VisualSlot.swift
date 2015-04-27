//
//  VisualSlot.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/26.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class VisualSlot:VisualItem
	{
	private var link:VisualLink?
	
	var slotImage:NSImage = NSImage(named:"socket-empty-16x16")!
		
	override init()
		{
		super.init()
		self.contents = slotImage
		}

	required init(coder aDecoder: NSCoder) 
		{
	    fatalError("init(coder:) has not been implemented")
		}
		
	func newLink() -> VisualLink
		{
		var aLink = VisualLink()
		aLink.setSourceItem(self)
		return(aLink)
		}
		
	override func handleMouseDownAtPoint(point:CGPoint,inView:DesignView)
		{
		var aLink:VisualLink
		
		self.printHierarchy()
		if self.link != nil
			{
			self.link!.disconnect(inView)
			}
		aLink = newLink()
		inView.addLink(aLink)
		loopUntilMouseUp(inView,closure: { (point:NSPoint,atEnd:Bool) in
			if atEnd
				{
				var targetItem = inView.items.itemContainingPoint(point)
				if targetItem != nil
					{
					aLink.setTargetItem(targetItem!.topItem!)
					self.link = aLink
					}
				else
					{
					inView.removeLink(aLink)
					}
				}
			else
				{
				aLink.setTargetPoint(point)
				}
			})
		}
	}