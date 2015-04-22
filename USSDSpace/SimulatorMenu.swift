//
//  SimultorMenu.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/22.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit

class SimulatorMenu:NSObject,NSXMLParserDelegate
	{
	var oldDelegate:NSXMLParserDelegate?
	var parser:NSXMLParser?
	var title:String?
	var menu:SimulatorMenu?
	var items:[SimulatorMenuItem] = [SimulatorMenuItem]()
	var currentItem:SimulatorMenuItem?
	var menuLayer:CATextLayer?
	
	init(parser:NSXMLParser)
		{
		super.init()
		self.parser = parser
		oldDelegate = parser.delegate
		parser.delegate = self
		}
		
	func addToLayer(layer:CALayer)
		{
		menuLayer = CATextLayer()
		
		}
		
	func parser(parser: NSXMLParser, foundCharacters string: String?)
		{
		if string != nil
			{
			if currentItem != nil
				{
				currentItem!.title = string
				NSLog("SET MENU ITEM TITLE TO \(currentItem!.title)")
				}
			else
				{
				title = string
				NSLog("SET MENU TITLE TO \(title)")
				}
			}
		}
		
	func parser(parser: NSXMLParser,didStartElement elementName: String,namespaceURI: String?,qualifiedName: String?,attributes attributeDict: [NSObject : AnyObject])
		{
		var item:SimulatorMenuItem
		
		NSLog("ELEMENT=\(elementName)")
		NSLog("ATTRIBUTES=\(attributeDict)")
		if elementName == "option"
			{
			item = SimulatorMenuItem(order:attributeDict["order"]! as! String,display:attributeDict["display"]! as! String,command:attributeDict["command"]! as! String,callback:attributeDict["callback"]! as! String)
			items.append(item)
			currentItem = item
			}
		}
	}