//
//  VisualTextItem.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/26.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class VisualText:VisualItem
	{
	private var textLayer:CATextLayer = CATextLayer()
	private var realFont:NSFont?
	
	var text:String
		{
		get
			{
			return(textLayer.string as! String)
			}
		set
			{
			textLayer.string = newValue
			}
		}
		
	var textFont:NSFont
		{
		get
			{
			if realFont != nil
				{
				return(realFont!)
				}
			else
				{
				return(textLayer.font as! NSFont)
				}
			}
		}
		
	override var style:[NSObject:AnyObject]!
		{
		set
			{
			textLayer.style = newValue
			}
		get
			{
			return(textLayer.style)
			}
		}
		
	override func desiredSizeInFrame(frame:CGRect) -> CGSize
		{
		return(CGSize(width:frame.size.width,height:self.text.heightInWidth(frame.size.width,withFont:self.textFont)))
		}
			
	override init()
		{
		super.init()
		addSublayer(textLayer)
		self.style = UFXStylist.MenuItemStyle
		}

	required init(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
		textLayer = aDecoder.decodeObjectForKey("textLayer") as! CATextLayer
		}
		
	override func layoutSublayers()
		{
		textLayer.frame = self.bounds
		}
	}