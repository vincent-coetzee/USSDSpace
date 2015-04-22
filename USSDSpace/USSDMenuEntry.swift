//
//  USSDMenuItem.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class USSDMenuEntry:USSDTextElement,NSTextViewDelegate,NSTextDelegate
	{
	var textView:NSTextView?
	
	var menuIndex:Int = 0
		{
		didSet
			{
			string = displayText
			setNeedsDisplay()
			}
		}
		
	var workspace:USSDWorkspace
		{
		get
			{
			return(self.menu().workspace)!
			}
		}
		
	func editTextInView(view:NSView)
		{
		var editFrame = self.frame.rectByAddingPointToOrigin(self.menu().frame.origin)
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
		var newText:String = textView!.string!
		
		self.text = newText
		var aMenu = self.menu()
		textView!.removeFromSuperview()
		textView = nil
		aMenu.setNeedsLayout()
		aMenu.setNeedsDisplay()
		}
		
	func addSourceSlotsToSet(set:SlotSet)
		{
		}
		
	func textView(aTextView: NSTextView, aSelector: Selector) -> Bool
		{
		if aSelector == Selector("insertNewline:") 
			{
			aTextView.insertNewlineIgnoringFieldEditor(nil)
			return(true)
			}
		return(false)
		}
		
	 func control(control: NSControl,textView:NSTextView,command: Selector) -> Bool
		{
		var returnValue:Bool = false
		if command == Selector("insertNewline:") 
			{
			returnValue = true
			textView.insertNewlineIgnoringFieldEditor(nil)
			}
		return(returnValue)
		}
	 
	 override func sizeToFitInWidth(width:CGFloat) -> CGFloat
		{
		var aHeight = TextHelper.heightOfString(self.displayText,forWidth:width,withFont: UFXStylist.MenuItemFont!)
		desiredHeight = aHeight
		return(aHeight)
		}
		
	func menu() -> USSDMenu	
		{
		return(superlayer as! USSDMenu)
		}
		
	func layoutInFrame(frame:CGRect)
		{
		self.frame = frame;
		}
		
	func loadIntoLayer(menuLayer:CALayer,linkLayer:LinkManagementLayer)
		{
		}
		
	override init()
		{
		super.init()
		UFXStylist.styleMenuEntry(self)
		}
	
	override init(layer:AnyObject?)
		{
		super.init(layer:layer)
		UFXStylist.styleMenuEntry(self)
		}
		
	override init(text:String)
		{
		super.init(text:text)
		UFXStylist.styleMenuEntry(self)
		}

	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeInteger(menuIndex,forKey:"menuIndex")
		}
		
	required init(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
		menuIndex = aDecoder.decodeIntegerForKey("menuIndex")
		UFXStylist.styleMenuEntry(self)
		}
	}