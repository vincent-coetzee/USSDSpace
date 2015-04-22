//
//  ErrorSheet.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/22.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit

class ErrorSheet:NSThread
	{
	@IBOutlet var window:NSWindow?
	@IBOutlet var headingText:NSTextField?
	@IBOutlet var messageText:NSTextField?
	@IBOutlet var mainWindow:NSWindow?
	
	var headingContent:String?
	var messageContent:String?
	var nib:NSNib?
	var array:AutoreleasingUnsafeMutablePointer<NSArray?> = AutoreleasingUnsafeMutablePointer<NSArray?>()
	
	init(heading:String,message:String)
		{
		super.init()
		headingContent = heading
		messageContent = message
		mainWindow = (NSApplication.sharedApplication().delegate as! AppDelegate).window
		dispatch_async(dispatch_get_main_queue()) 
			{
			() -> Void in
			self.loadNib()
			}
		}
		
	func loadNib()
		{
		self.nib = NSNib(nibNamed:"ErrorSheet",bundle:NSBundle.mainBundle())
		self.nib!.instantiateWithOwner(self,topLevelObjects:array)
		self.headingText!.stringValue = headingContent!
		self.messageText!.stringValue = messageContent!
		self.mainWindow!.beginSheet(window!,completionHandler:
			{(modalResponse:NSModalResponse) in 
			self.nib = nil
			self.array = nil	
			})
		}
		
	@IBAction func onDismiss(sender:AnyObject?)
		{
		mainWindow!.endSheet(window!,returnCode:NSModalResponseStop)
		}
	}