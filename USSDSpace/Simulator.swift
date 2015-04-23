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
	@IBOutlet var contextWindow:NSWindow?
	@IBOutlet var viewMenu:NSMenu?
	@IBOutlet var contextView:NSView?
	@IBOutlet var USSDSessionField:NSTextField?
	@IBOutlet var MSISDNField:NSTextField?
	@IBOutlet var startURLField:NSTextField?
	@IBOutlet var shortCodeField:NSTextField?
	@IBOutlet var sourceIPRewriteField:NSTextField?
	@IBOutlet var targetIPRewriteField:NSTextField?
	@IBOutlet var providerField:NSTextField?
	
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
		
	@IBAction func onContextOk(sender:AnyObject?)
		{
		window!.makeKeyAndOrderFront(self)
		contextWindow!.close()
		setCallback(targetURL!)
		}
		
	@IBAction func onContextCancel(sender:AnyObject?)
		{
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
		initTextFields()
		window!.contentView.addSubview(view!)
		}
		
	func initTextFields()
		{
		USSDSessionField!.stringValue = "23B1456792B2"
		MSISDNField!.stringValue = "27828877777"
		startURLField!.stringValue = targetURL!.baseURL
		shortCodeField!.stringValue = "*120*33248#"
		sourceIPRewriteField!.stringValue = "197.96.167.14"
		targetIPRewriteField!.stringValue = "10.1.7.1"
		providerField!.stringValue = "Vodacom"
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
		xml = service.fetchXMLAtURL(callback.finalURL().absoluteString!)!
		parser = NSXMLParser(data:xml.dataUsingEncoding(NSUTF8StringEncoding)!)
		if parser != nil
			{
			parser!.delegate = self
			parser!.parse()
			if parser!.parserError != nil
				{
				var newError:NSErrorPointer = NSErrorPointer()
				
				NSLog("ERROR = \(parser!.parserError)")
				NSLog("LINENUMBER = \(parser!.lineNumber)")
				NSLog("COLUMN = \(parser!.columnNumber)")
				NSLog("\((xml as NSString).substringFromIndex(parser!.columnNumber))")
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