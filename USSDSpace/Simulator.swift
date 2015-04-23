//
//  Simulator.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/22.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class Simulator:NSObject,NSXMLParserDelegate
	{
	@IBOutlet var window:SimulatorWindow?
	@IBOutlet var viewMenu:NSMenu?
	
	var view:SimulatorView?
	var nib:NSNib?
	var array:AutoreleasingUnsafeMutablePointer<NSArray?> = AutoreleasingUnsafeMutablePointer<NSArray?>()
	var menu:SimulatorMenu?
	var masterController:DesignController?
	var targetURL:CallbackURL?
	
	class func openNewSimulatorOn(startURL:String = "http://197.96.167.14:8080/bei/ussdhandler") -> Simulator
		{
		var newSimulator:Simulator
		var nib:NSNib
		var callback:CallbackURL
		callback = CallbackURL(base:startURL)
		callback.setValue("*120*33248#",forKey:"request")
		newSimulator = Simulator(startURL:callback)
		newSimulator.openWindow()
		return(newSimulator)
		}
		
	func closeWindow()
		{
		view = nil
		nib = nil
		array = nil
		menu = nil
		window!.close()
		}
		
	func openWindow()
		{
		nib = NSNib(nibNamed: "SimulatorWindow",bundle:NSBundle.mainBundle())
		nib!.instantiateWithOwner(self,topLevelObjects:array)
		view = SimulatorView(frame:window!.contentView.bounds)
		view!.menu = viewMenu!
		view!.controller = self
		window!.contentView.addSubview(view!)
		window!.makeKeyAndOrderFront(self)
		setCallback(targetURL!)
		}
		
	init(startURL:CallbackURL)
		{
		targetURL = startURL
		}
		
	func sendDismiss()
		{
		if masterController != nil
			{
			masterController!.closeSimulator(self)
			}
		else
			{
			closeWindow()
			}
		}
		
	func sendReply(reply:String)
		{
		var menu:SimulatorMenu
		var callback:String?
		var callbackURL:CallbackURL
		
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
		callbackURL = CallbackURL(base:callback!)
		callbackURL.setValue(reply,forKey:"request")
		setCallback(callbackURL)
		}
		
	func setCallback(callback:CallbackURL)
		{
		var parser:NSXMLParser?
		var xml:String
		var error:NSErrorPointer = NSErrorPointer()
		var service:USSDEngineService
		
		callback.setValue("Vodacom",forKey:"provider")
		callback.setValue("27828877777",forKey:"msisdn")
		service = USSDEngineService()
		xml = service.fetchXMLAtURL(callback.finalURL().absoluteString!)
		parser = NSXMLParser(data:(xml as! NSString).dataUsingEncoding(NSUTF8StringEncoding)!)
		if parser != nil
			{
			parser!.delegate = self
			parser!.parse()
			if parser!.parserError != nil
				{
				NSLog("ERROR = \(parser!.parserError)")
				}
			else
				{
				view!.currentMenu = menu!
				}
			}
		}
		
	func parser(parser: NSXMLParser,didStartElement elementName: String,namespaceURI: String?,qualifiedName: String?,attributes attributeDict: [NSObject : AnyObject])
		{
		if elementName == "headertext"
			{
			menu = SimulatorMenu(parser: parser)
			}
		}
	}