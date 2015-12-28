//
//  USSDMenuNameItem.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/15.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class USSDMenuNameItem:USSDMenuEntry
	{
	override init()
		{
		super.init()
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		}
		
	required init?(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
		}
	
	override init(text:String)
		{
		super.init(text:text)
		}
		
	override init(layer:AnyObject)
		{
		super.init(layer:layer)
		UFXStylist.styleLayerAsMenuName(self)
		}
	}