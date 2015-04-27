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
	var link:VisualLink?
	
	var slotImage:NSImage = NSImage(named:"socket-empty-16x16")!
	var containingMenuEntry:VisualMenuEntry?
	var linkCreationClosure:(()-> VisualLink)?
	
	override init()
		{
		super.init()
		self.contents = slotImage
		linkCreationClosure = {() in return(VisualLink())}
		}

	required init(coder aDecoder: NSCoder) 
		{
	    super.init(coder: aDecoder)
		link = aDecoder.decodeObjectForKey("link") as? VisualLink
		slotImage = (aDecoder.decodeObjectForKey("slotImage") as? NSImage)!
		containingMenuEntry = aDecoder.decodeObjectForKey("containingMenuEntry") as? VisualMenuEntry
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeObject(link,forKey:"link")
		coder.encodeObject(slotImage,forKey:"slotImage")
		coder.encodeObject(containingMenuEntry,forKey:"containingMenuEntry")
		}
		
		
	func newLink() -> VisualLink
		{
		var aLink = linkCreationClosure!()
		aLink.setSource(self)
		return(aLink)
		}
		
	var enabled:Bool = false
		{
		didSet
			{
			if self.enabled 
				{
				slotImage = link != nil ? NSImage(named:"socket-full-16x16")! : NSImage(named:"socket-empty-16x16")!
				self.contents = slotImage
				}
			else
				{
				self.contents = nil
				}
			}
		}
		
	override func handleMouseDownAtPoint(point:CGPoint,inView:DesignView)
		{
		var aLink:VisualLink
		
		self.printHierarchy()
		if self.link != nil
			{
			self.link!.disconnect(inView)
			self.link = nil
			(self.containerItem as! VisualMenuEntry).slotWasUnLinked(self)
			}
		aLink = newLink()
		inView.addLink(aLink)
		loopUntilMouseUp(inView,closure: { (point:NSPoint,atEnd:Bool) in
			if atEnd
				{
				var targetItem = inView.items.itemContainingPoint(point)
				if targetItem != nil
					{
					aLink.setTarget(targetItem!.topItem!)
					self.link = aLink
					(self.containerItem as! VisualMenuEntry).slotWasLinked(self)
					}
				else
					{
					inView.removeLink(aLink)
					}
				}
			else
				{
				aLink.setDirectTargetPoint(point)
				}
			})
		}
	}