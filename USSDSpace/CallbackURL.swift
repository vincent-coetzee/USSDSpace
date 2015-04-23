//
//  CallbackURL.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/22.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation

class CallbackURL
	{
	var baseURL:String = ""
	var parameters:[String:String] = [String:String]()
	
	init(base:String)
		{
		baseURL = base
		}
		
	func setValue(value:String,forKey:String)
		{
		parameters[forKey] = value
		}
		
	func finalURL() -> NSURL
		{
		var arguments:String
		var values:[String] = [String]()
		var url:String
		
		for (key,value) in parameters
			{
			values.append("\(key)=\(value)")
			}
		url = baseURL
		if values.count > 0
			{
			arguments = (values as NSArray).componentsJoinedByString("&")
			url = url + ((url as NSString).containsString("?") ? "&" : "?") + arguments
			}
		return(NSURL(string:url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!))!
		}
	}