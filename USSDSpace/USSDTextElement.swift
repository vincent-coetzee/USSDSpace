//
//  USSDTextElement.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class USSDTextElement:USSDElement
	{
	override init()
		{
		super.init()
		}
		
	override init(layer:AnyObject?)
		{
		super.init(layer:layer)
		}
		
	var text:String = ""
		{
		didSet
			{
			string = displayText
			setNeedsDisplay()
			}
		}
		
	var displayText:String
		{
		get
			{
			return(text)
			}
		}
		
	init(text:String)
		{
		super.init()
		self.text = text
		}

	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeObject(text,forKey:"text")
		}
		
	required init(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
		self.text = aDecoder.decodeObjectForKey("text") as! String
		self.string = self.displayText
		}
	}