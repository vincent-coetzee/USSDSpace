//
//  RemoteUSSDActivity.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/25.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation

class RemoteUSSDActivity
	{
	var name:String = ""
	var description:String = ""
	var inputState:RemoteUSSDActivityState?
	var outputState:RemoteUSSDActivityState?
	
	init(string:String)
		{
		name = string
		}
		
	init(dict:AnyObject)
		{
		name = dict.valueForKey("activityName")! as! String
//		inputState = RemoteUSSDActivityState(dict: dict.valueForKey("activityInputState")!)
//		outputState =  RemoteUSSDActivityState(dict: dict.valueForKey("activityOutputState")!)
		}
	}