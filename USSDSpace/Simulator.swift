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
		newSimulator.setURLString("http://197.96.167.14:8080/bei/ussdhandler?msisdn=27828877777")
		return(newSimulator)
		}
		
	func openWindow()
		{
		nib = NSNib(nibNamed: "SimulatorWindow",bundle:NSBundle.mainBundle())
		nib!.instantiateWithOwner(self,topLevelObjects:array)
		view = SimulatorView(frame:window!.contentView.bounds)
		window!.contentView.addSubview(view!)
		window!.makeKeyAndOrderFront(self)
		}
		
	func setURLString(URLString:String)
		{
		var parser:NSXMLParser?
		var xml:String
		var error:NSErrorPointer = NSErrorPointer()
		
		parser = NSXMLParser(contentsOfURL: NSURL(string:URLString)!)
		if parser != nil
			{
			parser!.delegate = self
			parser!.parse()
			NSLog("ERROR=\(parser!.parserError)")
			}
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