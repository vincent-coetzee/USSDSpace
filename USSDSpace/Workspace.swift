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

class Workspace:NSObject
	{
	var startItem:VisualItem?
	var items:VisualItemSet = VisualItemSet()
	var workspacePath:String?
	var campaignName:String = "WORKS"
	var nextMenuNumber:Int = 1
	var designViewFrame:CGRect = CGRect(x:0,y:0,width:0,height:0)
	var windowFrame:CGRect = CGRect(x:0,y:0,width:0,height:0)
	var workspaceName = USSDWorkspace.newUUIDString()
	var workspaceItem:USSDWorkspaceItem?
	var visualLinks:[VisualLink] = [VisualLink]()
	var uuid:String = Workspace.newUUIDString()
	
	func asJSONString() -> String
		{
		var targetUUID:String
		
		targetUUID = startItem == nil ? "" : startItem!.uuid
		var aString:String = "{\"type\":\"workspace\",\"name\":\"\(workspaceName)\",\"uuid\":\"\(uuid)\",\"startMenuUUID\":\"\(targetUUID)\","
		var menuStrings:[String] = [String]()
		
		for item in items
			{
			menuStrings.append(item.asJSONString())
			}
		let menusString = (menuStrings as NSArray).componentsJoinedByString(",")
		aString += "\"menus\":[\(menusString)]"
		aString += "}"
		return(aString)
		}
		
	static func loadFromPath(path:String) -> Workspace
		{
		var workspace:Workspace
		
		workspace = NSKeyedUnarchiver.unarchiveObjectWithFile(path) as! Workspace
		workspace.workspaceName = NSURL.fileURLWithPath(path).lastPathComponent!
		return(workspace)
		}
		
	static func newUUIDString() -> String
		{
		let uuid = CFUUIDCreate(kCFAllocatorDefault)
		let uuidString = CFUUIDCreateString(kCFAllocatorDefault,uuid)
		return(String(uuidString))
		}
		
	func saveOnPath(path:String) -> Bool
		{
		NSLog("\(asJSONString())")
		workspacePath = path
		return(NSKeyedArchiver.archiveRootObject(self,toFile:path))
		}
		
	override init()
		{
		workspaceName = "Workspace"
		super.init()
		}
		
	func encodeWithCoder(coder:NSCoder)
		{
		coder.encodeObject(startItem,forKey:"startItem")
		coder.encodeObject(items,forKey:"items")
		coder.encodeObject(workspaceName,forKey:"workspaceName")
		coder.encodeInteger(nextMenuNumber,forKey:"nextMenuNumber")
		coder.encodeObject(workspacePath,forKey:"workspacePath")
		coder.encodeRect(designViewFrame,forKey:"designViewFrame")
		coder.encodeRect(windowFrame,forKey:"windowFrame")
//		coder.encodeObject(workspaceItem,forKey:"workspaceItem")
		coder.encodeObject(visualLinks,forKey:"visualLinks")
		}
		
	init(coder aDecoder: NSCoder) 
		{
		startItem = aDecoder.decodeObjectForKey("startItem") as! VisualItem?
		items = aDecoder.decodeObjectForKey("items") as! VisualItemSet
		workspaceName = (aDecoder.decodeObjectForKey("workspaceName") as? String)!
		nextMenuNumber = aDecoder.decodeIntegerForKey("nextMenuNumber")
		workspacePath = aDecoder.decodeObjectForKey("workspacePath") as? String
		designViewFrame = aDecoder.decodeRectForKey("designViewFrame")
		windowFrame = aDecoder.decodeRectForKey("windowFrame")
//		workspaceItem = (aDecoder.decodeObjectForKey("workspaceItem") as? USSDWorkspaceItem)!
		visualLinks = aDecoder.decodeObjectForKey("visualLinks") as! [VisualLink]
		}
		
	func addItem(item:VisualItem)
		{
		items.addItem(item)
		if startItem == nil
			{
			startItem = item
			}
		}
		
	func nextMenuName() -> String
		{
		let aName = "\(campaignName)-\(nextMenuNumber++)"
		return(aName)
		}
		
	func deployToURL(URL:NSURL)
		{
		
		}
	}