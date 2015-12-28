//
//  VisualMenuEntry.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/26.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class VisualMenuEntry:VisualItem,NSTextViewDelegate,NSTextDelegate
	{
	internal var labelItem:VisualText = VisualText()
	internal var actualText:String = ""
	private var menuIndex:Int = 0
	private var textView:NSTextView?
	
	var containingMenu:VisualMenu?
	
	override init()
		{
		super.init()
		labelItem.text = "text"
		labelItem.container = self
		labelItem.layoutFrame = LayoutFrame(leftRatio:0,leftOffset:14,topRatio:0,topOffset:2,rightRatio:1,rightOffset:-14,bottomRatio:1,bottomOffset:0)
		addSublayer(labelItem)
		markForLayout()
		markForDisplay()
		self.styling = UFXStylist.menuItemStyle()
		}
		
	override init(layer:AnyObject)
		{
		super.init(layer:layer)
		}
		
	required init?(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
		labelItem = aDecoder.decodeObjectForKey("labelItem") as! VisualText
		actualText = aDecoder.decodeObjectForKey("actualText") as! String
		menuIndex = aDecoder.decodeIntegerForKey("menuIndex")
		markForLayout()
		markForDisplay()
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeObject(labelItem,forKey:"labelItem")
		coder.encodeObject(actualText,forKey:"actualText")
		coder.encodeInteger(menuIndex,forKey:"menuIndex")
		}
		
	override func hitTest(point:CGPoint) -> CALayer?
		{
		if CGRectContainsPoint(self.frame,point)
			{
			return(self)
			}
		return(nil)
		}
		
	override func asJSONString() -> String
		{
		return("{ \"type\":\"menuEntry\",\"uuid\": \"\(uuid)\", \"text\": \"\(text)\", \"menuIndex\": \(menuIndex)}");
		}
		
	func editTextInView(view:NSView)
		{
		var editFrame = self.frameAsViewFrame()
		editFrame.size.width -= 34
		editFrame.origin.x += 16
		textView = NSTextView(frame:editFrame)
		textView!.string = self.text
		textView!.font = UFXStylist.MenuItemFont;
		textView!.delegate = self
		textView!.fieldEditor = true
		view.addSubview(textView!)
		view.window!.makeKeyAndOrderFront(nil)
		view.window!.makeFirstResponder(textView)
		}
		
	func textDidEndEditing(notification:NSNotification) 
		{
		var oldText:String = self.text
		let newText:String = textView!.string!
		
		self.text = newText
		textView!.removeFromSuperview()
		textView = nil
		self.container.markForLayout()
		}
		
	override func handleDoubleClickAtPoint(point:CGPoint,inView:DesignView)
		{
		editTextInView(inView)
		}
		
	func slotWasLinked(slot:VisualSlot)
		{
		}
		
	func slotWasUnLinked(slot:VisualSlot)
		{
		}
		
	override func setIndex(index:Int)
		{
		menuIndex = index
		labelItem.text = displayText
		}
		
	var text:String
		{
		get
			{
			return(actualText)
			}
		set
			{
			actualText = newValue
			labelItem.text = displayText
			}
		}
		
	var displayText:String
		{
		get
			{
			return("\(menuIndex).\(actualText)")
			}
		}
		
	override func desiredSizeInFrame(frame:CGRect) -> CGSize
		{
		var revisedFrame = self.layoutFrame.rectInRect(frame)
		revisedFrame.size.width -= 34
		var aSize = labelItem.desiredSizeInFrame(revisedFrame)
		aSize.width += 32
		aSize.height = maximum(aSize.height,b: 16)
		return(aSize)
		}
		
	override func applyStyling()
		{
		labelItem.styling = self.styling
		}
		
	override func drawInContext(context:CGContext)
		{
		CGContextSaveGState(context)
		CGContextSetGrayStrokeColor(context,0.4,1.0)
		CGContextSetLineWidth(context,1)
		CGContextBeginPath(context)
		CGContextMoveToPoint(context,0,0)
		CGContextAddLineToPoint(context,CGRectGetMaxX(self.bounds),0)
		CGContextMoveToPoint(context,0,CGRectGetMaxY(self.bounds)-1)
		CGContextMoveToPoint(context,CGRectGetMaxX(self.bounds),CGRectGetMaxY(self.bounds)-1)
		CGContextStrokePath(context)
		}
	}