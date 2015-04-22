//
//  DesignController.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 Olamide. All rights reserved.
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
		
		simulator = Simulator.openNewSimulator()
		simulators.append(simulator)
		}
	}