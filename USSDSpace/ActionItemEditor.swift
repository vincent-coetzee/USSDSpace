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
	@IBOutlet var actionNameButton:NSPopUpButton?
	
	var valueName:String?
	var actionItem:USSDActionMenuItem?
	var nib:NSNib?
	var array:AutoreleasingUnsafeMutablePointer<NSArray?> = AutoreleasingUnsafeMutablePointer<NSArray?>()
	var popover:NSPopover?
	var controller:NSViewController?
	var rectView:NSView?
	var actionTargetName = ""
	var actionType = ""
	
	func openOnRect(rect:CGRect,inView:NSView,actionItem:USSDActionMenuItem)
		{
		self.actionItem = actionItem
		nib = NSNib(nibNamed: "ActionItemEditorView",bundle:NSBundle.mainBundle())
		nib!.instantiateWithOwner(self,topLevelObjects:array)
		nameField!.stringValue = "onNothing"
		controller = NSViewController()
		controller!.view = view!
		controller!.preferredContentSize = view!.frame.size
		popover = NSPopover()
		popover!.delegate = actionItem
		popover!.contentViewController = controller
		rectView = NSView(frame: rect)
		inView.addSubview(rectView!)
		popover!.showRelativeToRect(rectView!.bounds,ofView:rectView!,preferredEdge:NSRectEdge.MaxX)
		self.actionItem = actionItem
		nameField!.stringValue = self.actionItem!.actionTargetName
		setAction()
		}
		
	@IBAction func onInvokeMethodSelected(sender:AnyObject?)
		{
		actionItem!.actionType = "INVOKE"
		}
		
	@IBAction func onSaveSelectedIndexSelected(sender:AnyObject?)
		{
		actionItem!.actionType = "INDEX"
		}
		
	@IBAction func onSaveSelectedTextSelected(sender:AnyObject?)
		{
		actionItem!.actionType = "TEXT"
		}
	
	func setAction()
		{
		switch(actionItem!.actionType)
			{
		case "INVOKE":
			actionNameButton!.selectItemWithTitle("Invoke Method")
		case "INDEX":
			actionNameButton!.selectItemWithTitle("Save Selected Index")
		case "TEXT":
			actionNameButton!.selectItemWithTitle("Save Selected Text")
		default:
			break;
			}
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
		actionItem!.actionTargetName = nameField!.stringValue
		actionItem!.connectedSlot()!.link!.closeEditor()
		}
		
	@IBAction func onCancel(sender:AnyObject?)
		{
		actionItem!.connectedSlot()!.link!.closeEditor()
		}
	}