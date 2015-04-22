//
//  Workspace.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class USSDWorkspace:USSDElement
	{
	var selectedMenu:USSDMenu?
	var selectedElement:USSDElement?
	
	var startMenu:USSDMenu?
	var menus:[String:USSDMenu] = [String:USSDMenu]()
	var workspacePath:String?
	var campaignName:String = "CAMP"
	var nextMenuNumber:Int = 1
	var designViewFrame:CGRect = CGRect(x:0,y:0,width:0,height:0)
	var windowFrame:CGRect = CGRect(x:0,y:0,width:0,height:0)
	var workspaceName = USSDWorkspace.newUUIDString()
	
	override func asJSONString() -> String
		{
		var targetUUID:String
		
		targetUUID = startMenu == nil ? "" : startMenu!.uuid
		var aString:String = "{\"name\":\"\(workspaceName)\",\"uuid\":\"\(uuid)\",\"startMenuUUID\":\"\(targetUUID)\","
		var menuStrings:[String] = [String]()
		
		for (key,menu) in menus
			{
			menuStrings.append(menu.asJSONString())
			}
		var menusString = (menuStrings as NSArray).componentsJoinedByString(",")
		aString += "\"menus\":[\(menusString)]"
		aString += "}"
		return(aString)
		}
		
	static func loadFromPath(path:String) -> USSDWorkspace
		{
		var workspace:USSDWorkspace
		
		workspace = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! USSDWorkspace
		workspace.workspaceName = path.lastPathComponent
		return(workspace)
		}
		
	static func newUUIDString() -> String
		{
		var uuid = CFUUIDCreate(kCFAllocatorDefault)
		var uuidString = CFUUIDCreateString(kCFAllocatorDefault,uuid)
		return(String(uuidString))
		}
		
	func menuUUIDForMenuName(name:String) -> String
		{
		if name == "NULL-MENU"
			{
			return("0000-0000-0000-0000")
			}
		NSLog("menu name = \(name)")
		for (key,menu) in menus
			{
			NSLog("key = \(key) menu name = \(menu.menuName)")
			}
		return(menus[name]!.uuid)
		}
		
	func menuNameForMenuUUID(aUUID:String) -> String?
		{
		if aUUID == "0000-0000-0000-0000"
			{
			return("NULL-MENU")
			}
		for (key,menu) in menus
			{
			if menu.uuid == aUUID
				{
				return(menu.menuName)
				}
			}
		return(nil)
		}
		
	func saveOnPath(path:String) -> Bool
		{
		NSLog("\(JSONParser.formatJSON(asJSONString()))")
		workspacePath = path
		return(NSKeyedArchiver.archiveRootObject(self,toFile:path))
		}
		
	override init()
		{
		menus = [String:USSDMenu]()
		workspaceName = "Workspace"
		super.init()
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeObject(startMenu,forKey:"startMenu")
		coder.encodeObject(menus,forKey:"menus")
		coder.encodeObject(workspaceName,forKey:"workspaceName")
		coder.encodeInteger(nextMenuNumber,forKey:"nextMenuNumber")
		coder.encodeObject(workspacePath,forKey:"workspacePath")
		coder.encodeRect(designViewFrame,forKey:"designViewFrame")
		coder.encodeRect(windowFrame,forKey:"windowFrame")
		}
		
	required init(coder aDecoder: NSCoder) 
		{
		super.init(coder:aDecoder)
		startMenu = aDecoder.decodeObjectForKey("startMenu") as! USSDMenu?
		menus = aDecoder.decodeObjectForKey("menus") as! [String:USSDMenu]
		workspaceName = (aDecoder.decodeObjectForKey("workspaceName") as? String)!
		nextMenuNumber = aDecoder.decodeIntegerForKey("nextMenuNumber")
		workspacePath = aDecoder.decodeObjectForKey("workspacePath") as? String
		designViewFrame = aDecoder.decodeRectForKey("designViewFrame")
		windowFrame = aDecoder.decodeRectForKey("windowFrame")
		}
		
	func addMenu(menu:USSDMenu)
		{
		menus[menu.menuName] = menu
		menu.workspace = self
		}
		
	func allMenuNames() -> [String]
		{
		var names = [String]()
		
		for (key,menu) in menus
			{
			names.append(menu.menuName)
			}
		return(sorted(names,<))
		}
		
	func nextMenuName() -> String
		{
		var aName = "\(campaignName)-\(nextMenuNumber++)"
		return(aName)
		}
		
	func deployToURL(URL:NSURL)
		{
		
		}
	}