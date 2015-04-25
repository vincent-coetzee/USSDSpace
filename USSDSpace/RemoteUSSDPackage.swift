//
//  RemoteUSSDPackage.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/25.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation

class RemoteUSSDPackage
	{
	var name:String = ""
	var description:String = ""
	var activities:[String:RemoteUSSDActivity] = [String:RemoteUSSDActivity]()
	
	init(string:String)
		{
		name = string
		}
		
	init(dict:NSDictionary)
		{
		var activity:RemoteUSSDActivity?
		
		name = dict.valueForKey("packageName") as! String
		description = dict.valueForKey("packageDescription") as! String
		var array = dict.objectForKey("activities")! as! NSArray
		for a in array
			{
			var act = RemoteUSSDActivity(dict: a)
			activities[act.name] = act
			}
		}
	}