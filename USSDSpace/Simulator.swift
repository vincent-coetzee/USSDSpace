//
//  Simulator.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/22.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class Simulator:NSObject,NSXMLParserDelegate
	{
	@IBOutlet var window:SimulatorWindow?
	var view:SimulatorView?
	var nib:NSNib?
	var array:AutoreleasingUnsafeMutablePointer<NSArray?> = AutoreleasingUnsafeMutablePointer<NSArray?>()
	var menu:SimulatorMenu?
	
	class func openNewSimulator() -> Simulator
		{
		var newSimulator:Simulator
		var nib:NSNib
		
		newSimulator = Simulator()
		newSimulator.openWindow()
		newSimulator.setURLString("http://197.96.167.14:8080/bei/ussdhandler")
		return(newSimulator)
		}
		
	func openWindow()
		{
		nib = NSNib(nibNamed: "SimulatorWindow",bundle:NSBundle.mainBundle())
		nib!.instantiateWithOwner(self,topLevelObjects:array)
		view = SimulatorView(frame:window!.contentView.bounds)
		view!.controller = self
		window!.contentView.addSubview(view!)
		window!.makeKeyAndOrderFront(self)
		}
		
	func sendReply(reply:String)
		{
		var menu:SimulatorMenu
		var callback:String?
		
		menu = view!.currentMenu!
		if menu.isDataEntryMenu()
			{
			callback = menu.menuItemCallbackStringAtCommand(0)
			}
		else
			{
			if reply >= "0" || reply <= "99"
				{
				var commandIndex = reply.toInt()
				callback = menu.menuItemCallbackStringAtCommand(commandIndex!)
				}
			}
		if callback == nil
			{
			return
			}
		view!.hideKeyboard(true)
		setURLString(callback!)
		}
		
	func setURLString(URLString:String)
		{
		var parser:NSXMLParser?
		var xml:String
		var error:NSErrorPointer = NSErrorPointer()
		var callback:CallbackURL
		
		callback = CallbackURL(base: URLString)
		callback.setValue("Vodacom",forKey:"provider")
		callback.setValue("27828877777",forKey:"msisdn")
		parser = NSXMLParser(contentsOfURL:callback.finalURL())
		if parser != nil
			{
			parser!.delegate = self
			parser!.parse()
			NSLog("ERROR=\(parser!.parserError)")
			}
		view!.currentMenu = menu!
		}
		
	func parser(parser: NSXMLParser,didStartElement elementName: String,namespaceURI: String?,qualifiedName: String?,attributes attributeDict: [NSObject : AnyObject])
		{
		NSLog("ELEMENT=\(elementName)")
		NSLog("ATTRIBUTES=\(attributeDict)")
		if elementName == "headertext"
			{
			menu = SimulatorMenu(parser: parser)
			}
		}
	}