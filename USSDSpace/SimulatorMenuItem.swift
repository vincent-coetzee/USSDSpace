//
//  SimulatorMenuItem.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/22.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit

class SimulatorMenuItem:NSObject,NSXMLParserDelegate
	{
	var title:String = ""
	var order:Int = 1
	var display:Bool = true
	var command:Int = 0
	var callback:String?
	var height:CGFloat = 0
	var menuItemLayer:CATextLayer?
	
	init(order:String,display:String,command:String,callback:String)
		{
		super.init()
		self.order = order.toInt()!
		self.display = display == "true" 
		self.command = command.toInt()!
		self.callback = callback
		}
		
	func addToLayer(layer:CALayer,inWidth:CGFloat)
		{
		var label:String
		
		if !display
			{
			height = 0
			return
			}
		NSLog("****\(title)****")
		label = "\(command).\(title)"
		menuItemLayer = CATextLayer()
		menuItemLayer!.wrapped = true
		menuItemLayer!.string = label
		height = label.heightInWidth(inWidth,withFont: UFXStylist.SimulatorFont!)
		layer.addSublayer(menuItemLayer)
		UFXStylist.styleSimulatorLayer(menuItemLayer!)
		}
	}