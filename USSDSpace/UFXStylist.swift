//
//  UFXStylist.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class UFXStylist:NSObject
	{
	static var MenuItemFontName:String = "MuseoSans-500"
	static var MenuItemFontSize:CGFloat = 10
	static var MenuItemFont = NSFont(name:"MuseoSans-500",size:10)
	static var MenuItemTextColor:NSColor = NSColor.blackColor()
	static var SelectionColor:NSColor = NSColor.darkGrayColor()
	static var DeselectionColor:NSColor = NSColor.clearColor()
	static var LinkLineColor:NSColor = NSColor.lightGrayColor()
	static var SlotMenuImage = NSImage(named:"socket-action-empty-16x16")
	static var SimulatorFontName = "Helvetica"
	static var SimulatorFontSize:CGFloat = 13
	static var SimulatorFont = NSFont(name:UFXStylist.SimulatorFontName,size:UFXStylist.SimulatorFontSize)
	static var SimulatorTextColor = NSColor.whiteColor()
	static var SimulatorButtonFont = NSFont(name:"Helvetica Bold",size:14)
	
	static func styleMenuEntry(item:USSDMenuEntry)
		{
		item.font = MenuItemFont
		item.fontSize = MenuItemFontSize
		item.foregroundColor = MenuItemTextColor.CGColor
		}
		
	static func styleSimulatorLayer(layer:CATextLayer)
		{
		layer.font = SimulatorFontName
		layer.foregroundColor = SimulatorTextColor.CGColor
		layer.fontSize = SimulatorFontSize
		layer.alignmentMode = kCAAlignmentCenter
		}
		
	static func styledSimulatorButtonText(text:String) -> NSAttributedString
		{
		if text == "Dismiss"
			{
			var attributes:[String: AnyObject] = [String:AnyObject]()
			
			attributes[NSFontAttributeName] = UFXStylist.SimulatorButtonFont
			attributes[NSForegroundColorAttributeName] = NSColor.blackColor()
			return(NSAttributedString(string: text,attributes:attributes))
			}
		else
			{
			var attributes:[String: AnyObject] = [String:AnyObject]()
			
			attributes[NSFontAttributeName] = UFXStylist.SimulatorButtonFont
			attributes[NSForegroundColorAttributeName] = NSColor.whiteColor()
			return(NSAttributedString(string: text,attributes:attributes))
			}
		}
		
	static func styleLayerAsMenuName(layer:CATextLayer)
		{
		layer.font = NSFont(name:"MuseoSans-900",size:13)
		layer.fontSize = 14
		layer.foregroundColor = NSColor.grayColor().CGColor
		layer.alignmentMode = kCAAlignmentCenter
		}
		
	static func styleElementAsSelected(element:USSDElement)
		{
		element.backgroundColor = SelectionColor.CGColor
		}
		
	static func styleElementAsNotSelected(element:USSDElement)
		{
		element.backgroundColor = DeselectionColor.CGColor
		}
		
	static func styleMenu(menu:USSDMenu)
		{
		menu.borderWidth = 2
		menu.cornerRadius = 10
		menu.borderColor = NSColor.clearColor().CGColor
		}
		
	static func dumpAllFontNames()
    {
    var allNames = [String]()
    for familyName in NSFontManager.sharedFontManager().availableFontFamilies
        {
        for fonts in NSFontManager.sharedFontManager().availableMembersOfFontFamily(familyName as! String)!
            {
            if fonts.count > 0
                {
                allNames.append(fonts[0] as! String)
                }
            }
        }
		var sortedAllNames = sorted(allNames,<)
	
		for name in sortedAllNames
			{
			NSLog("\(name)")
			}
		}
	}