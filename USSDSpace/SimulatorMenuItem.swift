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
	var title:String?
	var order:Int?
	var display:Bool?
	var command:Int?
	var callback:String?
	
	init(order:String,display:String,command:String,callback:String)
		{
		super.init()
		self.order = order.toInt()!
		self.display = display == "true" 
		self.command = command.toInt()!
		self.callback = callback
		}
	}