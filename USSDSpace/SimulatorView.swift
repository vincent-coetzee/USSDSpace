//
//  SimulatorView.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/22.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class SimulatorView:NSView,NSTextViewDelegate,NSTextDelegate
	{
	private var menuLayer = CALayer()
	private var keyboardLayer:CALayer = CALayer()
	private var entryField:NSTextView = NSTextView(frame:NSRect(x:0,y:0,width:0,height:0))
	private var characterCountLayer = CATextLayer()
	private var dismissButton = NSButton(frame:NSRect(x:0,y:0,width:0,height:0))
	private var replyButton = NSButton(frame:NSRect(x:0,y:0,width:0,height:0))
	private var rightButton = NSButton(frame:NSRect(x:0,y:0,width:0,height:0))
	private var leftButton = NSButton(frame:NSRect(x:0,y:0,width:0,height:0))
	
	private let KeyboardAdjustmentHeight:CGFloat = 97
	
	var controller:Simulator?
	
	var currentMenu:SimulatorMenu?
		{
		didSet
			{
			updateMenuLayer()
			}
		}
		
	override var flipped:Bool
		{
		get
			{
			return(true)
			}
		}
	
	override init(frame:NSRect)
		{
		super.init(frame:frame)
		commonInit()
		}

	required init?(coder: NSCoder) 
		{
	    super.init(coder:coder)
		commonInit()
		}
		
	func textDidChange(notification: NSNotification)
		{
		var remainder:Int = 182
		var string:String
		
		remainder = count(entryField.string!)
		remainder = 182 - remainder
		characterCountLayer.string = NSString(format:"%ld characters remaining",remainder)
		}
		
	func textDidEndEditing(notification:NSNotification) 
		{
		onReplySend(self)
		}
		
	func hideKeyboard(move:Bool)
		{
		characterCountLayer.hidden = true
		keyboardLayer.hidden = true
		if move
			{
			var menuFrame = menuLayer.frame
			menuFrame.origin.y += KeyboardAdjustmentHeight
			menuLayer.frame = menuFrame
			}
		replyButton.hidden = false
		dismissButton.hidden = false
		entryField.removeFromSuperview()
		rightButton.hidden = true
		leftButton.hidden = true
		}
		
	func showKeyboard()
		{
		characterCountLayer.hidden = false
		keyboardLayer.hidden = false
		replyButton.hidden = true
		dismissButton.hidden = true
		entryField.string = ""
		self.addSubview(entryField)
		configureEntryField()
		self.window!.makeKeyAndOrderFront(nil)
		self.window!.makeFirstResponder(entryField)
		rightButton.hidden = false
		leftButton.hidden = false
		var menuFrame = menuLayer.frame
		menuFrame.origin.y -= KeyboardAdjustmentHeight
		menuLayer.frame = menuFrame
		}
		
	func commonInit()
		{
		wantsLayer = true
		menuLayer.borderWidth = 3
		menuLayer.borderColor = NSColor.redColor().CGColor
		self.layer!.addSublayer(menuLayer)
		needsLayout = true
		needsDisplay = true
		keyboardLayer.contents = NSImage(named:"Keyboard-236x137")
		self.layer!.addSublayer(keyboardLayer)
		characterCountLayer.string = "182 characters remaining"
		characterCountLayer.alignmentMode = kCAAlignmentCenter
		characterCountLayer.font = UFXStylist.SimulatorFontName
		characterCountLayer.fontSize = UFXStylist.SimulatorFontSize
		self.layer!.addSublayer(characterCountLayer)
		initButtons()
		hideKeyboard(false)
		doInitialLayout()
		}
		
	func configureEntryField()
		{
		entryField.textColor = UFXStylist.SimulatorTextColor
		entryField.font = UFXStylist.SimulatorFont
		entryField.drawsBackground = false
		entryField.delegate = self
		entryField.fieldEditor = true
		entryField.layer!.borderColor = UFXStylist.SimulatorTextColor.CGColor
		entryField.layer!.borderWidth = 1
		entryField.layer!.cornerRadius = 6
		}
		
	func initButtons()
		{
		dismissButton.bordered = false
		replyButton.bordered = false
//		dismissButton.attributedTitle = UFXStylist.styledSimulatorButtonText("Dismiss")
		dismissButton.setButtonType(NSButtonType.MomentaryChangeButton)
		dismissButton.image = NSImage(named:"WhiteButton-107x42")
		dismissButton.imagePosition = NSCellImagePosition.ImageOnly
		dismissButton.alignment = NSTextAlignment.CenterTextAlignment
		dismissButton.target = self
		dismissButton.action = "onDismiss:"
		self.addSubview(dismissButton)
//		replyButton.attributedTitle = UFXStylist.styledSimulatorButtonText("Reply")
		replyButton.setButtonType(NSButtonType.MomentaryChangeButton)
		replyButton.image = NSImage(named:"BlackButton-107x42")
		replyButton.imagePosition = NSCellImagePosition.ImageOnly
		replyButton.alignment = NSTextAlignment.CenterTextAlignment
		replyButton.target = self
		replyButton.action = "onReply:"
		self.addSubview(replyButton)
		UFXStylist.styleTopSimulatorButton(leftButton,text: "Cancel")
		leftButton.target = self
		leftButton.action = "onCancelSend:"
		leftButton.hidden = true
		self.addSubview(leftButton)
		UFXStylist.styleTopSimulatorButton(rightButton,text: "Reply")
		rightButton.target = self
		rightButton.action = "onReplySend:"
		rightButton.hidden = true
		self.addSubview(rightButton)
		}
		
	func onDismiss(sender:AnyObject?)
		{
		controller!.sendDismiss()
		}
		
	func onReply(sender:AnyObject?)
		{
		showKeyboard()
		}
		
	func onReplySend(sender:AnyObject?)
		{
		var commandString:String
		var callback:String?
		
		commandString = entryField.string!
		controller!.sendReply(commandString)
		}
		
	func onCancelSend(sender:AnyObject?)
		{
		hideKeyboard(true)
		}
		
	func resetMenuLayerFrame()
		{
		var someBounds:NSRect
		var origin:NSPoint
		var extent:NSSize
		
		someBounds = bounds
		origin = someBounds.origin
		extent = someBounds.size
		origin.x += 30
		extent.width = 236
		origin.y += 107
		extent.height = 399
		menuLayer.frame = NSRect(origin:origin,size:extent)
		}
		
	func doInitialLayout()
		{
		var someBounds:NSRect
		var origin:NSPoint
		var extent:NSSize
		
		someBounds = bounds
		origin = someBounds.origin
		extent = someBounds.size
		origin.x += 30
		extent.width = 236
		origin.y += 107
		extent.height = 399
		menuLayer.frame = NSRect(origin:origin,size:extent)
		keyboardLayer.frame = NSRect(x:29,y:371,width:236,height:137)
		entryField.frame = NSRect(x:32,y:327,width:230,height:36)
		characterCountLayer.frame = NSRect(x:32,y:356,width:230,height:24)
		dismissButton.frame = NSRect(x:29+10,y:420,width:107,height:42)
		replyButton.frame = NSRect(x:29+10+107+4,y:420,width:107,height:42)
		leftButton.frame = NSRect(x:29,y:107,width:50,height:16)
		rightButton.frame = NSRect(x:236-rightButton.attributedTitle.width()+20,y:107,width:rightButton.attributedTitle.width()+10,height:16)
		}
		
	func updateMenuLayer()
		{
		resetMenuLayerFrame()
		hideKeyboard(false)
		if menuLayer.sublayers != nil
			{
			for aLayer in menuLayer.sublayers
				{
				aLayer.removeFromSuperlayer()
				}
			}
		currentMenu!.addToLayer(menuLayer,inWidth:236,inHeight:399)
		}
	}