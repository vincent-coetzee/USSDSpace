//
//  DesignController.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class DesignController:NSObject
	{
	var simulators:[Simulator] = [Simulator]()
	
	@IBAction func onOpenSimulator(sender:AnyObject?)
		{
		var simulator:Simulator
		
		//startURL: "https://10.1.7.1:18443/ABWeb/ProcessUSSD" 
		simulator = Simulator.openNewSimulatorOn("https://africanbankdev.payperks.co.za:8443/ABWeb/ProcessUSSD")
//		simulator = Simulator.openNewSimulatorOn(startURL: "http://localhost:9090/ABWeb/ProcessUSSD")
		simulator.masterController = self
		simulators.append(simulator)
		}
		
	func closeSimulator(simulator:Simulator)
		{
		var index:Int?
		
		index = simulators.indexOf(simulator)
		if index != nil
			{
			simulator.closeWindow()
			simulators.removeAtIndex(index!)
			}
		}
	}