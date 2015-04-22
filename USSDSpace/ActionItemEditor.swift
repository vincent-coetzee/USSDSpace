//
//  ActionItemEditor.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/15.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit

class ActionItemEditor:NSObject
	{
	@IBOutlet var nameField:NSTextField?
	@IBOutlet var labelField:NSTextField?
	@IBOutlet var view:NSView?
	@IBOutlet var menuNameButton:NSPopUpButton?
	@IBOutlet var actionNameButton:NSPopUpButton?
	
	var valueName:String?
	var actionItem:USSDActionMenuItem?
	var nib:NSNib?
	var array:AutoreleasingUnsafeMutablePointer<NSArray?> = AutoreleasingUnsafeMutablePointer<NSArray?>()
	var popover:NSPopover?
	var controller:NSViewController?
	var rectView:NSView?
	var slotNextMenuName = ""
	var slotValueName = ""
	var slotActionTypeName = ""
	var actionType:Int = 1
	var slotActionType:ActionSlot.ActionType?
	
	func openOnRect(rect:CGRect,inView:NSView,actionItem:USSDActionMenuItem)
		{
		self.actionItem = actionItem
		nib = NSNib(nibNamed: "ActionItemEditorView",bundle:NSBundle.mainBundle())
		nib!.instantiateWithOwner(self,topLevelObjects:array)
		nameField!.stringValue = "onNothing"
		setMenuNames()
		controller = NSViewController()
		controller!.view = view!
		controller!.preferredContentSize = view!.frame.size
		popover = NSPopover()
		popover!.delegate = actionItem
		popover!.contentViewController = controller
		rectView = NSView(frame: rect)
		inView.addSubview(rectView!)
		popover!.showRelativeToRect(rectView!.bounds,ofView:rectView!,preferredEdge:NSMaxXEdge)
		slotActionType = actionItem.actionSlot.actionType
		self.actionItem = actionItem
		setAction()
		}
		
	@IBAction func onInvokeMethodSelected(sender:AnyObject?)
		{
		labelField!.stringValue = "Method Name :"
		slotActionTypeName = "Invoke Method"
		actionType = 1
		}
		
	@IBAction func onSaveSelectedIndexSelected(sender:AnyObject?)
		{
		labelField!.stringValue = "Variable Name :"
		actionType = 2
		slotActionTypeName = "Save Selected Index"
		}
		
	@IBAction func onSaveSelectedTextSelected(sender:AnyObject?)
		{
		labelField!.stringValue = "Variable Name :"
		actionType = 3
		slotActionTypeName = "Save Selected Text"
		}
	
	func setAction()
		{
		switch(slotActionType!)
			{
		case let .Invoke(key,methodName,menuName):
			actionNameButton!.selectItemWithTitle("Invoke Method")
			nameField!.stringValue = methodName
			slotActionTypeName = "Invoke Method"
			slotNextMenuName = actionItem!.menu().menuNameForMenuUUID(menuName)
			menuNameButton!.selectItemWithTitle(slotNextMenuName)
			slotValueName = methodName
		case let .SaveIndex(key,methodName,menuName):
			actionNameButton!.selectItemWithTitle("Save Selected Index")
			nameField!.stringValue = methodName
			slotNextMenuName = actionItem!.menu().menuNameForMenuUUID(menuName)
			menuNameButton!.selectItemWithTitle(slotNextMenuName)
			slotActionTypeName = "Save Selected Index"
			slotValueName = methodName
		case let .SaveIndex(key,methodName,menuName):
			actionNameButton!.selectItemWithTitle("Save Selected Text")
			nameField!.stringValue = methodName
			slotNextMenuName = actionItem!.menu().menuNameForMenuUUID(menuName)
			menuNameButton!.selectItemWithTitle(slotNextMenuName)
			slotActionTypeName = "Save Selected Text"
			slotValueName = methodName
		default:
			break;
			}
		}
		
	func updateSlot()
		{
		var menuUUID:String
		
		slotValueName = nameField!.stringValue
		menuUUID = actionItem!.menu().menuUUIDForMenuName(slotNextMenuName)
		switch(slotActionTypeName)
			{
			case "Invoke Method":
				actionItem!.actionSlot.actionType = ActionSlot.ActionType.Invoke(actionType,slotValueName,menuUUID)
			case "Save Selected Index":
				actionItem!.actionSlot.actionType = ActionSlot.ActionType.SaveIndex(actionType,slotValueName,menuUUID)
			case "Save Selected Text":
				actionItem!.actionSlot.actionType = ActionSlot.ActionType.SaveText(actionType,slotValueName,menuUUID)
			default:
				break
			}
		}
		
	func setMenuNames()
		{
		menuNameButton!.removeAllItems()
		for name in actionItem!.workspace.allMenuNames()
			{
			var menuItem:NSMenuItem?
			
			menuNameButton!.addItemWithTitle(name)
			menuItem = menuNameButton!.itemWithTitle(name)
			menuItem!.action = "onNextMenuNameSelected:"
			menuItem!.target = self
			}
		}
		
	func onNextMenuNameSelected(sender:AnyObject?)
		{
		var menuItemSender:NSMenuItem?
		
		menuItemSender = sender as! NSMenuItem?
		slotNextMenuName = menuItemSender!.title
		}
		
	func close()
		{
		popover!.close()
		rectView!.removeFromSuperview()
		rectView = nil
		array = nil
		controller = nil
		nib = nil
		popover = nil
		}
		
	@IBAction func onOK(sender:AnyObject?)
		{
		updateSlot()
		close()
		}
		
	@IBAction func onCancel(sender:AnyObject?)
		{
		close()
		}
	}