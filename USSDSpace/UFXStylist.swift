//
//  UFXStylist.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class UFXStylist:NSObject
	{
	static var MenuItemFontName:String = "LucidaGrande"
	static var MenuItemFontSize:CGFloat = 11
	static var MenuItemFont = NSFont(name:"LucidaGrande",size:11)
	static var MenuItemTextColor:NSColor = NSColor.blackColor()
	static var MenuNameFontName = "MuseoSans-900"
	static var MenuNameFontSize:CGFloat = 13
	static var MenuNameTextColor = NSColor.blackColor()
	static var SelectionColor:NSColor = NSColor.colorWithUnscaled(102,green:201,blue:250)
	static var DeselectionColor:NSColor = NSColor.clearColor()
	static var LinkLineColor:NSColor = NSColor.lightGrayColor()
	static var SlotMenuImage = NSImage(named:"socket-action-empty-16x16")
	static var SimulatorFontName = "Helvetica"
	static var SimulatorFontSize:CGFloat = 13
	static var SimulatorFont = NSFont(name:UFXStylist.SimulatorFontName,size:UFXStylist.SimulatorFontSize)
	static var SimulatorTextColor = NSColor.whiteColor()
	static var SimulatorButtonFont = NSFont(name:"Helvetica",size:15)
	static var SimulatorTopButtonFont = NSFont(name:"Helvetica",size:13)
	static var SimulatorTopButtonColor:NSColor = NSColor.colorWithUnscaled(0.0,green:36.0,blue:214.0)
	
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
		
	static func styleTopSimulatorButton(button:NSButton,text:String)
		{
		var attributes:[String: AnyObject] = [String:AnyObject]()
			
		attributes[NSFontAttributeName] = UFXStylist.SimulatorTopButtonFont
		attributes[NSForegroundColorAttributeName] = SimulatorTopButtonColor
		button.bordered = false
		button.setButtonType(NSButtonType.MomentaryChangeButton)
		button.alignment = NSTextAlignment.CenterTextAlignment
		button.attributedTitle = NSAttributedString(string: text,attributes:attributes)
		}
		
	static func styleLayerAsMenuName(layer:CATextLayer)
		{
		layer.font = MenuNameFontName
		layer.fontSize = MenuNameFontSize
		layer.foregroundColor = MenuNameTextColor.CGColor
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
		menu.shadowColor = NSColor.blackColor().CGColor
		menu.shadowRadius = 2
		menu.shadowOffset = CGSize(width:2,height:2)
		menu.shadowOpacity = 0.6
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