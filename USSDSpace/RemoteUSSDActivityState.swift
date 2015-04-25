//
//  RemoteUSSDActivityState.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/25.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation

class RemoteUSSDActivityState
	{
	var stateName:String = ""
	
	init(dict:AnyObject)
		{
		stateName = dict.valueForKey("stateName")! as! String
		var values = dict.objectForKey("stateValues")! 
		NSLog("\(values)")
		}
	}