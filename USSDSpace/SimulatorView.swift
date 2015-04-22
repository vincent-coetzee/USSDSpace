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

class SimulatorView:NSView
	{
	private var menuLayer:CALayer = CALayer()
	private var keyboardLayer:CALayer = CALayer()
	private var entryField:NSTextField = NSTextField(frame:NSRect(x:0,y:0,width:0,height:0))
	private var characterCountLayer = CATextLayer()
	private var dismissButton:NSButton = NSButton(frame:NSRect(x:0,y:0,width:0,height:0))
	private var replyButton:NSButton = NSButton(frame:NSRect(x:0,y:0,width:0,height:0))
	
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
		
	func hideKeyboard()
		{
		entryField.hidden = true
		characterCountLayer.hidden = true
		keyboardLayer.hidden = true
		}
		
	func showKeyboard()
		{
		entryField.hidden = false
		characterCountLayer.hidden = false
		keyboardLayer.hidden = false
		}
		
	func commonInit()
		{
		wantsLayer = true
		menuLayer.backgroundColor = NSColor.redColor().CGColor
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
		self.addSubview(entryField)
		entryField.font = UFXStylist.SimulatorFont
		entryField.textColor = UFXStylist.SimulatorTextColor
		entryField.bordered = false
		entryField.drawsBackground = false
		entryField.layer!.borderColor = UFXStylist.SimulatorTextColor.CGColor
		entryField.layer!.borderWidth = 1
		entryField.layer!.cornerRadius = 6
		initButtons()
		hideKeyboard()
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
		dismissButton.action = "onDismiss"
		self.addSubview(dismissButton)
//		replyButton.attributedTitle = UFXStylist.styledSimulatorButtonText("Reply")
		replyButton.setButtonType(NSButtonType.MomentaryChangeButton)
		replyButton.image = NSImage(named:"BlackButton-107x42")
		replyButton.imagePosition = NSCellImagePosition.ImageOnly
		replyButton.alignment = NSTextAlignment.CenterTextAlignment
		dismissButton.target = self
		dismissButton.action = "onReply"
		self.addSubview(replyButton)
		}
		
	func onDismiss(sender:AnyObject?)
		{
		}
		
	func onReply(sender:AnyObject?)
		{
		showKeyboard()
		}
		
	override func layout()
		{
		var someBounds:NSRect
		var origin:NSPoint
		var extent:NSSize
		
		super.layout()
		someBounds = bounds
		origin = someBounds.origin
		extent = someBounds.size
		origin.x += 30
		extent.width = 236
		origin.y += 107
		extent.height = 399
		menuLayer.frame = NSRect(origin:origin,size:extent)
		keyboardLayer.frame = NSRect(x:29,y:371,width:236,height:137)
		entryField.frame = NSRect(x:32,y:327,width:230,height:24)
		characterCountLayer.frame = NSRect(x:32,y:356,width:230,height:24)
		dismissButton.frame = NSRect(x:29+10,y:420,width:107,height:42)
		replyButton.frame = NSRect(x:29+10+107+4,y:420,width:107,height:42)
		}
		
	func updateMenuLayer()
		{
		}
	}