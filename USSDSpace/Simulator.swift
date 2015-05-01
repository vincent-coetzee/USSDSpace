//
//  Simulator.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/22.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class Simulator:NSObject,NSXMLParserDelegate
	{
	@IBOutlet var window:SimulatorWindow?
	@IBOutlet var contextWindow:NSWindow?
	@IBOutlet var viewMenu:NSMenu?
	@IBOutlet var contextView:NSView?
	@IBOutlet var USSDSessionField:NSTextField?
	@IBOutlet var MSISDNField:NSTextField?
	@IBOutlet var startURLField:NSTextField?
	@IBOutlet var shortCodeField:NSTextField?
	@IBOutlet var sourceIPRewriteField:NSTextField?
	@IBOutlet var targetIPRewriteField:NSTextField?
	@IBOutlet var providerField:NSTextField?
	var simulationContext:SimulationContext = SimulationContext()
	var hostView:NSView?
	var topView:NSView?
	var bottomView:NSView?
	var topLayer:CALayer?
	var bottomLayer:CALayer?
	
	var view:SimulatorView?
	var nib:NSNib?
	var array:AutoreleasingUnsafeMutablePointer<NSArray?> = AutoreleasingUnsafeMutablePointer<NSArray?>()
	var menu:SimulatorMenu?
	var masterController:DesignController?
	var targetURL:CallbackURL?
	
	class func openNewSimulatorOn(startURL:String = "http://197.96.167.14:8080/bei/ussdhandler") -> Simulator
		{
		var newSimulator:Simulator
		var nib:NSNib
		var callback:CallbackURL
		callback = CallbackURL(base:startURL)
		callback.setValue("*120*33248",forKey:"request")
		callback.setValue("1234567890",forKey:"USSDSessionId")
		newSimulator = Simulator(startURL:callback)
		newSimulator.openWindow()
		return(newSimulator)
		}
		
	@IBAction func onContextOk(sender:AnyObject?)
		{
		contextView!.removeFromSuperview()
		window!.contentView.addSubview(view!)
		window!.contentView.layer!!.contents = NSImage(named:"WhiteiPhone-292x597")
//		window!.makeKeyAndOrderFront(self)
//		contextWindow!.close()
		setCallback(targetURL!)
		}
		
	@IBAction func onContextCancel(sender:AnyObject?)
		{
		}
		
	func closeWindow()
		{
		view = nil
		nib = nil
		array = nil
		menu = nil
		window!.close()
		}
		
	func openWindow()
		{
		nib = NSNib(nibNamed: "SimulatorWindow",bundle:NSBundle.mainBundle())
		nib!.instantiateWithOwner(self,topLevelObjects:array)
		view = SimulatorView(frame:window!.contentView.bounds)
		view!.menu = viewMenu!
		view!.controller = self
		}
		
	init(startURL:CallbackURL)
		{
		targetURL = startURL
		}
		
	func sendDismiss()
		{
		if masterController != nil
			{
			masterController!.closeSimulator(self)
			}
		else
			{
			closeWindow()
			}
		}
		
	func flipAnimationWithDuration(duration:NSTimeInterval, beginsOnTop:Bool, scale: CGFloat) -> CAAnimation
		{
		var animation:CABasicAnimation
		var shrinkAnimation:CABasicAnimation
		var startValue:CGFloat
		var endValue:CGFloat
		var group:CAAnimationGroup
		
		animation = CABasicAnimation(keyPath:"transform.rotation.y")
		startValue = beginsOnTop ? 0 : CGFloat(M_PI)
		endValue = beginsOnTop ? CGFloat(-M_PI) : 0
		animation.fromValue = startValue
		animation.toValue = endValue
		shrinkAnimation = CABasicAnimation(keyPath:"transform.scale")
		shrinkAnimation.toValue = scale
		shrinkAnimation.duration = duration * 0.5
		shrinkAnimation.autoreverses = true
		group = CAAnimationGroup()
		group.animations = [animation,shrinkAnimation]
		group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
		group.fillMode = kCAFillModeForwards
		group.removedOnCompletion = false
		return(group)
		}
		
	@IBAction func onFlip(sender:AnyObject?)
		{
		var topAnimation = flipAnimationWithDuration(1.0, beginsOnTop: true, scale: 1.3)
		var bottomAnimation = flipAnimationWithDuration(1.0, beginsOnTop: false, scale: 1.3)
		var topLayer = topView!.layerFromContents()
		var bottomLayer = bottomView!.layerFromContents()
		var distance:CGFloat = 1500
		var perspective:CATransform3D = CATransform3DIdentity
		
		perspective.m34 = -1 / distance
		topLayer.transform = perspective
		bottomLayer.transform = perspective
		bottomLayer.frame = topView!.frame
		bottomLayer.doubleSided = false
		hostView!.layer!.addSublayer(bottomLayer)
		topLayer.frame = bottomView!.frame
		topLayer.doubleSided = false
		hostView!.layer!.addSublayer(topLayer)
		CATransaction.begin()
		CATransaction.setValue(true,forKey:kCATransactionDisableActions)
		topView!.removeFromSuperview()
		CATransaction.commit()
		topAnimation.delegate = self
		CATransaction.begin()
		topLayer.addAnimation(topAnimation,forKey:"flip")
		bottomLayer.addAnimation(bottomAnimation,forKey:"flip")
		CATransaction.commit()
		}

	override func animationDidStop(animation:CAAnimation,finished:Bool)
		{
		CATransaction.begin()
		CATransaction.setValue(true,forKey:kCATransactionDisableActions)
		hostView!.addSubview(bottomView!)
		topLayer!.removeFromSuperlayer()
		bottomLayer!.removeFromSuperlayer()
		CATransaction.commit()
		}

	func sendReply(reply:String)
		{
		var menu:SimulatorMenu
		var callback:String?
		var callbackURL:CallbackURL
		
		menu = view!.currentMenu!
		if menu.isDataEntryMenu()
			{
			callback = menu.menuItemCallbackStringAtCommand(0)
			}
		else
			{
			if reply >= "0" || reply <= "99"
				{
				var commandIndex = reply.toInt()
				callback = menu.menuItemCallbackStringAtCommand(commandIndex!)
				}
			}
		if callback == nil
			{
			return
			}
		callbackURL = CallbackURL(base:callback!)
		callbackURL.setValue(reply,forKey:"request")
		setCallback(callbackURL)
		}
		
	func setCallback(callback:CallbackURL)
		{
		var parser:NSXMLParser?
		var xml:String
		var error:NSErrorPointer = NSErrorPointer()
		var service:USSDEngineService
		
		callback.setValue("Vodacom",forKey:"provider")
		callback.setValue("27828877777",forKey:"msisdn")
		NSLog("CALLING \(callback.finalURL())")
		service = USSDEngineService()
		xml = service.fetchXMLAtURL(callback.finalURL().absoluteString!)!
		NSLog("\(xml)")
		parser = NSXMLParser(data:xml.dataUsingEncoding(NSUTF8StringEncoding)!)
		if parser != nil
			{
			parser!.delegate = self
			parser!.parse()
			if parser!.parserError != nil
				{
				var newError:NSErrorPointer = NSErrorPointer()
				
				NSLog("\(xml as NSString)")
				NSLog("ERROR = \(parser!.parserError)")
				NSLog("LINENUMBER = \(parser!.lineNumber)")
				NSLog("COLUMN = \(parser!.columnNumber)")
				NSLog("\((xml as NSString).substringFromIndex(parser!.columnNumber))")
				}
			else
				{
				NSLog("MENU TITLE = \(menu!.title)")
				view!.currentMenu = menu!
				}
			}
		}
		
	func parser(parser: NSXMLParser,didStartElement elementName: String,namespaceURI: String?,qualifiedName: String?,attributes attributeDict: [NSObject : AnyObject])
		{
		if elementName == "headertext"
			{
			menu = SimulatorMenu(parser: parser)
			parser.delegate = menu
			}
		}
	}