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
		
	override func hitTest(point:CGPoint) -> CALayer?
		{
		if CGRectContainsPoint(self.frame,point)
			{
			return(self)
			}
		return(nil)
		}
		
	override func applyStyling()
		{
		var fontName:String = self.styling!["fontName"] as! String
		var fontSize = self.styling!["fontSize"] as! NSNumber
		var size:CGFloat = CGFloat(fontSize.doubleValue)
		textLayer.font = NSFont(name:fontName,size:size)
		textLayer.fontSize = size
		textLayer.foregroundColor = self.styling!["foregroundColor"]! as! CGColor
		}
		
	override func desiredSizeInFrame(frame:CGRect) -> CGSize
		{
		return(CGSize(width:frame.size.width,height:self.text.heightInWidth(frame.size.width,withFont:self.textFont)))
		}
			
	override init()
		{
		super.init()
		addSublayer(textLayer)
		textLayer.alignmentMode = kCAAlignmentCenter
		textLayer.wrapped = true
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