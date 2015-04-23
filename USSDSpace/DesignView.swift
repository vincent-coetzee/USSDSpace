//
//  DesignView.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class DesignView:NSView
	{
	var menus:[USSDMenu] = [USSDMenu]()
	var selectedElementHolder:SelectionHolder<USSDItem> = SelectionHolder<USSDItem>()
	
	var dragMenu:USSDMenu?
	var dragOffset:CGPoint?
	
	var workspace = USSDWorkspace()
	
	var menuContainerLayer:CALayer = CALayer()
	var primaryContainerLayer:CALayer = CALayer()
	var linkContainerLayer = LinkManagementLayer()
	
	override var flipped:Bool
		{
		get
			{
			return(true)
			}
		}
		
	func reset()
		{
		for menu in menus
			{
			menu.removeFromSuperlayer()
			}
		menus = [USSDMenu]()
		linkContainerLayer.reset()
		}
		
	func elementContainingPoint(point:CGPoint) -> USSDElement?
		{
		for menu in menus
			{
			if CGRectContainsPoint(menu.frame,point)
				{
				let item = menu.itemContainingPoint(point)
				if item == nil
					{
					return(menu)
					}
				else
					{
					return(item)
					}
				}
			}
		return(nil)
		}
		
	func linkContainingPoint(point:NSPoint) -> SlotLink?
		{
		var link:SlotLink?
		link = linkContainerLayer.linkContainingPoint(point)
		return(link)
		}
		
	func menuContainingPoint(point:CGPoint) -> USSDMenu?
		{
		for menu in menus
			{
			if CGRectContainsPoint(menu.frame,point)
				{
				return(menu)
				}
			}
		return(nil)
		}
		
	func handleLinkDrag(sourceMenu:USSDMenu,slot:Slot,point:NSPoint)
		{
		var continueToLoop:Bool = true
		var localEvent:NSEvent
		var activeLink:SlotLink
		var startPoint:NSPoint
		var targetMenu:USSDMenu?
		var line:NSLineSegment
		var targetPoint:NSPoint?
		
		if slot.isConnected
			{
			slot.disconnect(linkContainerLayer)
			}
		activeLink = slot.newLink()
		startPoint = slot.centerPoint
		activeLink.setLine(startPoint,toPoint:point)
		linkContainerLayer.addPotentialLink(activeLink)
		line = NSLineSegment(start:startPoint,end:startPoint)
		while continueToLoop == true
			{
			var mask:NSEventMask = NSEventMask.LeftMouseUpMask | NSEventMask.LeftMouseDraggedMask
			localEvent = self.window!.nextEventMatchingMask(Int(mask.rawValue))!
			let point = convertPoint(localEvent.locationInWindow,fromView:nil)
			line.endPoint = point
			if localEvent.type == NSEventType.LeftMouseDragged
				{
				autoscroll(localEvent)
				activeLink.setLine(line)
				}
			else if localEvent.type == NSEventType.LeftMouseUp
				{
				continueToLoop = false
				activeLink.setLine(line)
				linkContainerLayer.removePotentialLink(activeLink)
				targetMenu = menuContainingPoint(point)
				if targetMenu != nil && targetMenu != sourceMenu 
					{
					slot.link = activeLink
					slot.isConnected = true
					targetMenu!.addSlotLink(activeLink,fromSlot: slot)
					linkContainerLayer.addLink(activeLink)
					}
				}
			else
				{
				// do nothing
				}
			}
		
		}
		
	override func mouseDown(event:NSEvent)
		{
		var point = convertPoint(event.locationInWindow,fromView:nil)
		var menu = menuContainingPoint(point)
		
		if menu != nil
			{
			var slotSet = menu!.sourceSlotSet()
			var slot = slotSet.slotContainingPoint(point)
			
			if slot != nil
				{
				handleLinkDrag(menu!,slot: slot!,point: point)
				return
				}
				
			dragMenu = menu!
			dragOffset = point.pointBySubtractingPoint(menu!.frame.origin)
			}
		}
		
	override func mouseDragged(event:NSEvent)
		{
		var point = convertPoint(event.locationInWindow,fromView:nil)
		
		if dragMenu != nil
			{
			dragMenu!.setFrameOrigin(point.pointBySubtractingPoint(dragOffset!))
			}
		}
		
	override func mouseUp(event:NSEvent)
		{
		var point = convertPoint(event.locationInWindow,fromView:nil)
		var menu:USSDMenu?
		var menuEntry:USSDMenuEntry?
		
		if dragMenu != nil
			{
			dragMenu!.setFrameOrigin(point.pointBySubtractingPoint(dragOffset!))
			dragMenu = nil
			}
		menu = menuContainingPoint(point)
		if event.clickCount == 1
			{
			if menu != nil
				{
				var element = elementContainingPoint(point)
				if element == selectedElementHolder.selection || element == nil
					{
					selectedElementHolder.selection = nil
					if element != nil
						{
						element!.handleClick(point,inView:self)
						}
					return
					}
				else
					{
					selectedElementHolder.selection = element
					NSLog("SELECTED ELEMENT IS \(element)")
					element!.handleClick(point,inView:self)
					}
				}
			else
				{
				var link:SlotLink?
				
				link = linkContainingPoint(point)
				if link != nil
					{
					selectedElementHolder.selection = link;
					}
				}
			}
		else if event.clickCount == 2
			{
			if menu != nil
				{
				menuEntry = menu!.itemContainingPoint(point)
				if menuEntry != nil
					{
					menuEntry!.editTextInView(self)
					}
				}
			}
		}
		
	override init(frame:NSRect)
		{
		super.init(frame:frame)
		wantsLayer = true
		initLayers()
		}
		
	private func initLayers()
		{
		primaryContainerLayer.removeAllAnimations()
		primaryContainerLayer.geometryFlipped = true
		linkContainerLayer.removeAllAnimations()
		menuContainerLayer.removeAllAnimations()
		layer = primaryContainerLayer
		layer!.addSublayer(menuContainerLayer)
		layer!.insertSublayer(linkContainerLayer,above:menuContainerLayer)
		}

	required init?(coder: NSCoder) 
		{
	    super.init(coder:coder)
		wantsLayer = true
		initLayers()
		}
		
	func currentMousePoint() -> CGPoint
		{
		var point:NSPoint = self.window!.convertRectFromScreen(NSRect(x:NSEvent.mouseLocation().x,y:NSEvent.mouseLocation().y,width:0,height:0)).origin
		
		return(convertPoint(point,fromView:nil))
		}
	
	@IBAction func onOpen(sender:AnyObject?)
		{
		var openPanel:NSOpenPanel;

		openPanel = NSOpenPanel()
		openPanel.allowedFileTypes = ["USSD"]
		openPanel.beginWithCompletionHandler()
			{
			(result: Int) -> Void in 
			if result == NSFileHandlingPanelOKButton
				{
				self.workspace = USSDWorkspace.loadFromPath(openPanel.URL!.path!)
				self.selectedElementHolder.selection = nil
				self.window!.setFrame(self.workspace.windowFrame,display:true)
				self.reset()
				self.menus = [USSDMenu]()
				for (key,menu) in self.workspace.menus
					{
					menu.loadIntoLayer(self.menuContainerLayer,linkLayer:self.linkContainerLayer)
					self.menus.append(menu)
					}
				}
			}
		}
	
	@IBAction func onSave(sender:AnyObject?)
		{
		var savePanel:NSSavePanel;

		workspace.designViewFrame = self.frame
		workspace.windowFrame = self.window!.frame
		if workspace.workspacePath != nil
			{
			workspace.saveOnPath(workspace.workspacePath!)
			return
			}
		savePanel = NSSavePanel()
		savePanel.allowedFileTypes = ["USSD"]
		savePanel.beginWithCompletionHandler()
			{
			(result: Int) -> Void in 
			if result == NSFileHandlingPanelOKButton
				{
				self.workspace.saveOnPath(savePanel.URL!.path!)
				}
			}
		}
		
	@IBAction func onSaveAs(sender:AnyObject?)
		{
		var savePanel:NSSavePanel;

		workspace.designViewFrame = self.frame
		workspace.windowFrame = self.window!.frame
		savePanel = NSSavePanel()
		savePanel.allowedFileTypes = ["USSD"]
		savePanel.beginWithCompletionHandler()
			{
			(result: Int) -> Void in 
			if result == NSFileHandlingPanelOKButton
				{
				self.workspace.saveOnPath(savePanel.URL!.path!)
				}
			}
		}
		
	@IBAction func onAddMenu(sender:AnyObject?)
		{
		var menu:USSDMenu
		
		menu = USSDMenu()
		menu.workspace = workspace
		menu.menuName = workspace.nextMenuName()
		menu.addItem(USSDMenuItem(text:"First Menu Item"))
		menu.addItem(USSDMenuItem(text:"Second long menu Item."))
		menu.addItem(USSDMenuItem(text:"Third shorter Item"))
		menu.addItem(USSDMenuItem(text:"Return to other menu"))
		menu.setFrameOrigin(currentMousePoint())
		menus.append(menu)
		menuContainerLayer.addSublayer(menu)
		menuContainerLayer.setNeedsDisplay()
		workspace.addMenu(menu)
		}
		
	func menu(menu: NSMenu,updateItem item: NSMenuItem,atIndex index: Int,shouldCancel: Bool) -> Bool
		{
//		NSLog("TITLE(\(item.title)) INDEX(\(index))")
		if index == 1
			{
			item.enabled = selectedElementHolder.selection == nil
			}
		return(true)
		}
		
	func numberOfItemsInMenu(menu:NSMenu) -> Int
		{
		return(menu.numberOfItems)
		}
		
	@IBAction func onAddMenuItem(sender:AnyObject?)
		{
		var menuItem = USSDMenuItem(text: "New Item")
		
		if selectedElementHolder.selection != nil && selectedElementHolder.selection!.isMenu()
			{
			(selectedElementHolder.selection! as! USSDMenu).addItem(menuItem)
			}
		}
		
	@IBAction func onAddActionMenuItem(sender:AnyObject?)
		{
		var menuItem = USSDActionMenuItem(text: "New Item")
		
		menuItem.actionSlot = ActionSlot(rect: CGRect(x:0,y:0,width:16,height:16))
		
		if selectedElementHolder.selection != nil && selectedElementHolder.selection!.isMenu()
			{
			(selectedElementHolder.selection! as! USSDMenu).addItem(menuItem)
			}
		}
		
	@IBAction func onEntryFieldMenuItem(sender:AnyObject?)
		{
		var menuItem = USSDEntryFieldMenuItem(text: "REQUEST=")
		if selectedElementHolder.selection != nil && selectedElementHolder.selection!.isMenu()
			{
			(selectedElementHolder.selection! as! USSDMenu).addItem(menuItem)
			}
		}
		
	@IBAction func onDeleteMenu(sender:AnyObject?)
		{
		}
		
	@IBAction func onImport(sender:AnyObject?)
		{
		NSLog("\(workspace.asJSONString())")
		}
		
	@IBAction func onExportAsPDF(sender:AnyObject?)
		{
		var savePanel:NSSavePanel;

		savePanel = NSSavePanel()
		savePanel.allowedFileTypes = ["pdf"]
		savePanel.beginWithCompletionHandler()
			{
			(result: Int) -> Void in 
			if result == NSFileHandlingPanelOKButton
				{
				var data = self.dataWithPDFInsideRect(self.bounds)
				data.writeToFile(savePanel.URL!.path!,atomically: true)
				}
			}
		}
		
	@IBAction func onMoveItemUp(sender:AnyObject?)
		{
		if selectedElementHolder.selection != nil && selectedElementHolder.selection!.isMenuItem()
			{
			var item:USSDMenuEntry
			
			item = selectedElementHolder.selection as! USSDMenuEntry
			item.menu().moveItemUp(item)
			}
		}
		
	@IBAction func onMoveItemDown(sender:AnyObject?)
		{
		if selectedElementHolder.selection != nil && selectedElementHolder.selection!.isMenuItem()
			{
			var item:USSDMenuEntry
			
			item = selectedElementHolder.selection as! USSDMenuEntry
			item.menu().moveItemDown(item)
			}
		}
		
	@IBAction func onSetStartMenu(sender:AnyObject?)
		{
		if selectedElementHolder.selection != nil && selectedElementHolder.selection!.isMenu()
			{
			workspace.startMenu = selectedElementHolder.selection! as! USSDMenu
			}
		}
		
	@IBAction func onDeploy(sender:AnyObject?)
		{
		var service:USSDManagerService
		
		service = USSDManagerService()
		if !service.hasToken
			{
			service.requestToken("vincent.coetzee",userName:"vac14830B",password:"somethingObscure09@")
			}
		service.deployWorkspace(workspace)
		}
		
	@IBAction func onDeployAndRun(sender:AnyObject?)
		{
		var service:USSDManagerService
		
		service = USSDManagerService()
		service.deployWorkspace(workspace)
		Simulator.openNewSimulatorOn(startURL: service.startURLForWorkspace(workspace))
		}
		
	@IBAction func onDeleteItem(sender:AnyObject?)
		{
		var element = selectedElementHolder.selection
		
		if element != nil && element!.isMenuItem()
			{
			var menuItem = element as! USSDMenuItem
			var menu = menuItem.menu()
			menu.removeItem(menuItem)
			}
		}
	}