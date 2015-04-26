//
//  VisualElement.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/26.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class VisualItem:CALayer,VisualContainer
	{
	private var parent:VisualContainer?
	private var frameDependents:VisualItemSet = VisualItemSet()
	
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
		
	var centerPoint:CGPoint
		{
		get
			{
			var aFrame = self.frame
			return(CGPoint(x:CGRectGetMidX(aFrame),y:CGRectGetMidY(aFrame)))
			}
		}
		
	var layoutFrame:LayoutFrame
		{
		didSet
			{
			if self.parent != nil
				{
				self.container.markForLayout()
				}
			}
		}
		
	var container:VisualContainer
		{
		get
			{
			return(parent!)
			}
		set
			{
			parent = newValue
			}
		}
		
	var containerView:DesignView
		{
		get
			{
			return(self.container.containerView)
			}
		}
		
	var isView:Bool
		{
		get
			{
			return(false)
			}
		}
		
	var topItem:VisualItem?
		{
		get
			{
			if self.container.isView
				{
				return(self)
				}
			return(parent!.topItem)
			}
		}
		
	func desiredSizeInFrame(frame:CGRect) -> CGSize
		{
		return(CGSize(width:-1,height:-1))
		}
		
	var workspace:USSDWorkspace?
		{
		get
			{
			return(self.containerView.workspace)
			}
		}
		
	var shadow:Shadow
		{
		get
			{
			return(Shadow())
			}
		set
			{
			newValue.setOnLayer(self)
			}
		}
		
	override init()
		{
		layoutFrame = LayoutFrame()
		super.init()
		self.borderWidth = 1
		self.borderColor = NSColor.blackColor().CGColor
		}

	required init(coder aDecoder: NSCoder) 
		{
		layoutFrame = LayoutFrame()
	    super.init(coder:aDecoder)
		parent = aDecoder.decodeObjectForKey("parent") as! VisualContainer?
		layoutFrame = aDecoder.decodeObjectForKey("layoutFrame") as! LayoutFrame
		}
		
	func addItem(item:VisualItem)
		{
		item.container = self
		addSublayer(item)
		}
		
	func frameChanged()
		{
		}
		
	func markForDisplay()
		{
		setNeedsDisplay()
		}
		
	func markForLayout()
		{
		setNeedsLayout()
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeObject(parent as! VisualItem,forKey:"parent")
		coder.encodeObject(layoutFrame,forKey:"layoutFrame")
		}
		
	override func layoutSublayers()
		{
		var theFrame:CGRect
		
		theFrame = self.frame
		for child in self.sublayers
			{
			var item = child as! VisualItem
			item.frame = item.layoutFrame.rectInRect(theFrame)
			}
		}
	}