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
	
	var startMenu:USSDElement?
	var elements:[USSDElement] = [USSDElement]()
	var workspacePath:String?
	var campaignName:String = "WORKS"
	var nextMenuNumber:Int = 1
	var designViewFrame:CGRect = CGRect(x:0,y:0,width:0,height:0)
	var windowFrame:CGRect = CGRect(x:0,y:0,width:0,height:0)
	var workspaceName = USSDWorkspace.newUUIDString()
	var workspaceItem:USSDWorkspaceItem?
	
	override func asJSONString() -> String
		{
		var targetUUID:String
		
		targetUUID = startMenu == nil ? "" : startMenu!.uuid
		var aString:String = "{\"name\":\"\(workspaceName)\",\"uuid\":\"\(uuid)\",\"startMenuUUID\":\"\(targetUUID)\","
		var menuStrings:[String] = [String]()
		
		for element in elements
			{
			menuStrings.append(element.asJSONString())
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
		workspace.recalibrate()
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
		for element in elements
			{
			if element.menuName == name
				{
				return(element.uuid)
				}
			}
		return("0000-0000-0000-0000")
		}
		
	func saveOnPath(path:String) -> Bool
		{
		NSLog("\(JSONParser.formatJSON(asJSONString()))")
		workspacePath = path
		return(NSKeyedArchiver.archiveRootObject(self,toFile:path))
		}
		
	override init()
		{
		elements = [USSDElement]()
		workspaceName = "Workspace"
		super.init()
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeObject(startMenu,forKey:"startMenu")
		coder.encodeObject(elements,forKey:"elements")
		coder.encodeObject(workspaceName,forKey:"workspaceName")
		coder.encodeInteger(nextMenuNumber,forKey:"nextMenuNumber")
		coder.encodeObject(workspacePath,forKey:"workspacePath")
		coder.encodeRect(designViewFrame,forKey:"designViewFrame")
		coder.encodeRect(windowFrame,forKey:"windowFrame")
		coder.encodeObject(workspaceItem,forKey:"workspaceItem")
		}
		
	required init(coder aDecoder: NSCoder) 
		{
		super.init(coder:aDecoder)
		startMenu = aDecoder.decodeObjectForKey("startMenu") as! USSDMenu?
		elements = aDecoder.decodeObjectForKey("elements") as! [USSDElement]
		workspaceName = (aDecoder.decodeObjectForKey("workspaceName") as? String)!
		nextMenuNumber = aDecoder.decodeIntegerForKey("nextMenuNumber")
		workspacePath = aDecoder.decodeObjectForKey("workspacePath") as? String
		designViewFrame = aDecoder.decodeRectForKey("designViewFrame")
		windowFrame = aDecoder.decodeRectForKey("windowFrame")
		workspaceItem = (aDecoder.decodeObjectForKey("workspaceItem") as? USSDWorkspaceItem)!
		}
		
	override func recalibrate()
		{
		for element in elements
			{
			element.recalibrate()
			}
		}
		
	func addMenu(menu:USSDElement)
		{
		elements.append(menu)
		}
		
	func allMenuNames() -> [String]
		{
		var names = [String]()
		
		for element in elements
			{
			names.append(element.menuName)
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