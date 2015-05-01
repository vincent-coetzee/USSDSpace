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
		simulator = Simulator.openNewSimulatorOn(startURL: "https://10.1.7.1:18443/ABWeb/ProcessUSSD")
//		simulator = Simulator.openNewSimulatorOn(startURL: "http://localhost:8080/ABWeb/ProcessUSSD")
		simulator.masterController = self
		simulators.append(simulator)
		}
		
	func closeSimulator(simulator:Simulator)
		{
		var index:Int?
		
		index = find(simulators,simulator)
		if index != nil
			{
			simulator.closeWindow()
			simulators.removeAtIndex(index!)
			}
		}
	}