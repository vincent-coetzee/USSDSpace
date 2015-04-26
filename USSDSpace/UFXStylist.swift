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
	static var MenuItemFontSize:CGFloat = 9
	static var MenuItemFont = NSFont(name:"LucidaGrande",size:9)
	static var MenuItemTextColor:NSColor = NSColor.blackColor()
	static var MenuNameFontName = "MuseoSans-900"
	static var MenuNameFontSize:CGFloat = 12
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
	static var ActionSlotLinkColor = NSColor.colorWithUnscaled(248,green:179,blue:168)
	static var SlotLinkColor = NSColor.colorWithUnscaled(180,green:210,blue:180)
	static var DataSlotLinkColor = NSColor.colorWithUnscaled(255,green:201,blue:111)
	static var StartMenuLinkColor = NSColor.colorWithUnscaled(208,green:180,blue:209)
	static var MenuItemStyle:[NSObject:AnyObject]?
	static var MenuStyle:[NSObject:AnyObject]?
	
	class func menuItemStyle() -> [NSObject:AnyObject]
		{
		if MenuItemStyle == nil
			{
			MenuItemStyle = [NSObject:AnyObject]()
			MenuItemStyle!["foregroundColor"] = NSColor.blackColor().CGColor
			MenuItemStyle!["font"] = "MuseoSans-300"
			MenuItemStyle!["fontSize"] = 11
			}
		return(MenuItemStyle!)
		}
		
	class func menuStyle() -> [NSObject:AnyObject]
		{
		if MenuStyle == nil
			{
			MenuStyle = [NSObject:AnyObject]()
			MenuStyle!["foregroundColor"] = NSColor.blackColor().CGColor
			MenuStyle!["font"] = "MuseoSans-700"
			MenuItemStyle!["fontSize"] = 13
			}
		return(MenuStyle!)
		}
		
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
		
	static func styleActionSlotLink(link:ActionSlotLink)
		{
		link.lineColor = ActionSlotLinkColor
		link.initStyle()
		}
		
	static func styleStartMenuLink(link:ActionSlotLink)
		{
		link.lineColor = StartMenuLinkColor
		link.initStyle()
		}
		
	static func styleSlotLink(link:SlotLink)
		{
		link.lineColor = SlotLinkColor
		link.initStyle()
		}
		
	static func styleDataEntrySlotLink(link:ActionSlotLink)
		{
		link.lineColor = DataSlotLinkColor
		link.initStyle()
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