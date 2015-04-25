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
	var elements:[USSDElement] = [USSDElement]()
	var selectedElementHolder:SelectionHolder<USSDItem> = SelectionHolder<USSDItem>()
	
	var dragElement:USSDElement?
	var dragOffset:CGPoint?
	
	var workspace = USSDWorkspace()
	var workspaceItem = USSDWorkspaceItem()
	
	var menuContainerLayer:CALayer = CALayer()
	var primaryContainerLayer:CALayer = CALayer()
	var linkContainerLayer = LinkManagementLayer()
	
	var packages:[String:RemoteUSSDPackage] = [String:RemoteUSSDPackage]()
	var packageNames:[String]?
	
	override var flipped:Bool
		{
		get
			{
			return(true)
			}
		}
		
	func reset()
		{
		for element in elements
			{
			element.removeFromSuperlayer()
			}
		workspaceItem.removeFromSuperlayer()
		workspaceItem = USSDWorkspaceItem()
		elements = [USSDElement]()
		linkContainerLayer.reset()
		}
		
	required init?(coder: NSCoder) 
		{
	    super.init(coder:coder)
		wantsLayer = true
		initLayers()
		NSOperationQueue.mainQueue().addOperationWithBlock({() in self.loadPackages()})
		workspaceItem.menuView = self
		workspaceItem.loadIntoLayer(menuContainerLayer,linkLayer:linkContainerLayer)
		workspaceItem.actualWorkspace = workspace
		workspaceItem.layoutInFrame(self.frame)
		workspace.workspaceItem = workspaceItem
		workspace.addMenu(workspaceItem)
		elements.append(workspaceItem)
		}
		
	func loadPackages()
		{
		packageNames = [String]()
		
//		var service = USSDManagerService()
//		
//		packageNames = service.packageNames()
//		for aName in packageNames!
//			{
//			var package = service.packageForName(aName)
//			packages[package!.name] = package;
//			}
//		NSLog("WOW")
		}
		
	override func layout()
		{
		super.layout()
		workspaceItem.layoutInFrame(self.frame)
		menuContainerLayer.setNeedsLayout()
		}
		
	override func menuForEvent(event:NSEvent) -> NSMenu?
		{
		var itemUnderPoint:USSDItem?
		var point = convertPoint(event.locationInWindow,fromView:nil)
		var newMenu:NSMenu = NSMenu()
		
		NSLog("\(event)")
		if event.type == NSEventType.LeftMouseDown && (event.modifierFlags & NSEventModifierFlags.ControlKeyMask == NSEventModifierFlags.ControlKeyMask)
			{
			itemUnderPoint = elementContainingPoint(point)
			if itemUnderPoint != nil
				{
				return(itemUnderPoint!.popupMenu())
				}
			itemUnderPoint = linkContainingPoint(point)
			if itemUnderPoint != nil
				{
				return(itemUnderPoint!.popupMenu())
				}
			}
		var newItem = newMenu.addItemWithTitle("Add Menu",action:"onAddMenu:",keyEquivalent:"")
		newItem!.target = self
		newItem = newMenu.addItemWithTitle("Add Package Activity",action:"onAddActivity:",keyEquivalent:"")
		newItem!.target = self
		newMenu.addItem(NSMenuItem.separatorItem())
		newItem = newMenu.addItemWithTitle("Packages",action:"onSomething:",keyEquivalent:"")
		newItem!.target = self;
		var subMenu:NSMenu = NSMenu()
		newItem!.submenu = subMenu
		for (key,package) in packages
			{
			var item = NSMenuItem(title: key,action:Selector("onSomething:") ,keyEquivalent:"")
			subMenu.addItem(item)
			item.target = self
			var packMenu = NSMenu()
			item.submenu = packMenu
			for (actName,act) in package.activities
				{
				var lowerItem = NSMenuItem(title:act.name,action:"onSomething:",keyEquivalent:"")
				packMenu.addItem(lowerItem)
				lowerItem.target = self
				}
			}
		return(newMenu)
		}
		
	func onSomething(sender:AnyObject?)
		{
		}
		
	func onAddActivityEntryPoint(sender:AnyObject?)
		{
		var item:USSDEntryPointItem
		
		item = USSDEntryPointItem()
		item.setFrameOrigin(currentMousePoint())
		elements.append(item)
		menuContainerLayer.addSublayer(item)
		menuContainerLayer.setNeedsDisplay()
		}
		
	func onAddActivityExitPoint(sender:AnyObject?)
		{
		var item:USSDExitPointItem
		
		item = USSDExitPointItem()
		item.setFrameOrigin(currentMousePoint())
		elements.append(item)
		menuContainerLayer.addSublayer(item)
		menuContainerLayer.setNeedsDisplay()
		}
		
	func elementContainingPoint(point:CGPoint) -> USSDElement?
		{
		for element in elements
			{
			if CGRectContainsPoint(element.frame,point)
				{
				let item = element.itemContainingPoint(point)
				if item == nil
					{
					return(element)
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
		
	func menuContainingPoint(point:CGPoint) -> USSDElement?
		{
		for element in elements
			{
			if CGRectContainsPoint(element.frame,point)
				{
				return(element)
				}
			}
		return(nil)
		}
		
	func handleLinkDrag(sourceMenu:USSDElement,slot:Slot,point:NSPoint)
		{
		var continueToLoop:Bool = true
		var localEvent:NSEvent
		var activeLink:SlotLink
		var startPoint:NSPoint
		var targetMenu:USSDElement?
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
					targetMenu!.addIncomingSlotLink(activeLink,fromSlot: slot)
					slot.isConnected = true
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
				
			dragElement = menu!
			dragElement!.startDrag()
			dragOffset = point.pointBySubtractingPoint(menu!.frame.origin)
			}
		}
		
	override func mouseDragged(event:NSEvent)
		{
		var point = convertPoint(event.locationInWindow,fromView:nil)
		
		if dragElement != nil
			{
			dragElement!.setFrameOrigin(point.pointBySubtractingPoint(dragOffset!))
			}
		}
		
	override func mouseUp(event:NSEvent)
		{
		var point = convertPoint(event.locationInWindow,fromView:nil)
		var menu:USSDElement?
		var menuEntry:USSDMenuEntry?
		
		if dragElement != nil
			{
			dragElement!.setFrameOrigin(point.pointBySubtractingPoint(dragOffset!))
			dragElement!.endDrag()
			dragElement = nil
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
					element!.handleClick(point,inView:self)
					}
				}
			else
				{
				var link:SlotLink?
				
				link = linkContainingPoint(point)
				if link != nil
					{
					if selectedElementHolder.selection == link
						{
						selectedElementHolder.selection = nil
						}
					else
						{
						selectedElementHolder.selection = link
						}
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
			else
				{
				var link:SlotLink?
				
				link = linkContainingPoint(point)
				if link != nil
					{
					link!.editLinkInView(self)
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
		self.layer = primaryContainerLayer
		self.layer!.addSublayer(menuContainerLayer)
		self.layer!.insertSublayer(linkContainerLayer,above:menuContainerLayer)
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
				self.restoreFromWorkspace(USSDWorkspace.loadFromPath(openPanel.URL!.path!))
				}
			}
		}
		
	func restoreFromWorkspace(aNewWorkspace:USSDWorkspace)
		{
		var theNewOne = aNewWorkspace
		
		reset()
		workspace = theNewOne
		workspaceItem = theNewOne.workspaceItem!
		selectedElementHolder.selection = nil
		self.window!.setFrame(theNewOne.windowFrame,display:true)
		elements = theNewOne.elements
		for element in elements
			{
			element.menuView = self
			element.loadIntoLayer(self.menuContainerLayer,linkLayer:self.linkContainerLayer)
			}
		menuContainerLayer.setNeedsLayout()
		linkContainerLayer.setNeedsLayout()
		menuContainerLayer.setNeedsDisplay()
		linkContainerLayer.setNeedsDisplay()
		}
	
	@IBAction func onSave(sender:AnyObject?)
		{
		var savePanel:NSSavePanel;
	
		workspace.workspaceItem = workspaceItem
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

		workspace.workspaceItem = workspaceItem
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
		menu.menuView = self
		menu.workspace = workspace
		menu.menuName = workspace.nextMenuName()
		menu.addItem(USSDMenuItem(text:"Menu Item"))
		menu.setFrameOrigin(currentMousePoint())
		elements.append(menu)
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