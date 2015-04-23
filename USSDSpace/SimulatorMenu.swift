//
//  SimultorMenu.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/22.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
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
	var height:CGFloat = 0
	
	init(parser:NSXMLParser)
		{
		super.init()
		self.parser = parser
		oldDelegate = parser.delegate
		parser.delegate = self
		}
		
	func addToLayer(layer:CALayer,inWidth:CGFloat,inHeight:CGFloat)
		{
		var totalHeight:CGFloat = 0
		var padding:CGFloat
		var offset:CGFloat
		var newWidth:CGFloat
		var xOffset:CGFloat
		
		newWidth = inWidth - 10
		xOffset = 5
		height = title!.heightInWidth(newWidth,withFont: UFXStylist.SimulatorFont!)
		totalHeight += height
		menuLayer = CATextLayer()
		menuLayer!.wrapped = true
		menuLayer!.string = title
		UFXStylist.styleSimulatorLayer(menuLayer!)
		layer.addSublayer(menuLayer)
		for item in items
			{
			item.addToLayer(layer,inWidth:inWidth)
			totalHeight += item.height
			}
		padding = (inHeight - totalHeight)/2 - 20
		offset = padding
		menuLayer!.frame = CGRect(x:xOffset,y:offset,width:newWidth,height:height)
		offset += height
		for item in items
			{
			if item.display
				{
				item.menuItemLayer!.frame = CGRect(x:xOffset,y:offset,width:newWidth,height:item.height)
				offset += item.height
				}
			}
		layer.setNeedsDisplay()
		}
		
	func itemContainingPoint(point:NSPoint) -> SimulatorMenuItem?
		{
		for item in items
			{
			if item.display
				{
				NSLog("COMPARING \(point) AND \(item.menuItemLayer!.frame)")
				if CGRectContainsPoint(item.menuItemLayer!.frame,point)
					{
					return(item)
					}
				}
			}
		return(nil)
		}
		
	func parser(parser: NSXMLParser, foundCharacters string: String?)
		{
		if string != nil
			{
			if currentItem != nil
				{
				currentItem!.title = string!
				}
			else
				{
				title = string
				}
			}
		}
		
	func isDataEntryMenu() -> Bool
		{
		return(items.count == 1 && !items[0].display)
		}
		
	func menuItemCallbackStringAtCommand(command:Int) -> String?
		{
		if items.count == 1
			{
			return(base:items[0].callback!)
			}
		for item in items
			{
			if item.command == command
				{
				return(item.callback!)
				}
			}
		return(nil)
		}
		
	func parser(parser: NSXMLParser,didStartElement elementName: String,namespaceURI: String?,qualifiedName: String?,attributes attributeDict: [NSObject : AnyObject])
		{
		var item:SimulatorMenuItem
		
		if elementName == "option"
			{
			item = SimulatorMenuItem(order:attributeDict["order"]! as! String,display:attributeDict["display"]! as! String,command:attributeDict["command"]! as! String,callback:attributeDict["callback"]! as! String)
			items.append(item)
			currentItem = item
			
			}
		}
	}