//
//  USSDEntryFieldMenuItem.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/23.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class USSDEntryFieldMenuItem:USSDActionMenuItem
	{
	override func editTextInView(view:NSView)
		{
		}
		
	override func asJSONString() -> String
		{
		var aString:String = ""
		
		aString = "{ \"type\": \"\(self.dynamicType)\", \"uuid\":\"\(uuid)\", \"itemIndex\": \(menuIndex), \"text\": \"\"}"
		return(aString)
		}
	}