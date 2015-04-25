//
//  JSONParser.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/21.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation

class JSONParser
	{		
	class func parseJSON(string:String) -> AnyObject
		{
		var data:NSData
		var object:AnyObject
		var error:NSErrorPointer
		
		data = string.dataUsingEncoding(NSUTF8StringEncoding)!
		error = NSErrorPointer()
		object = NSJSONSerialization.JSONObjectWithData(data,options:NSJSONReadingOptions.AllowFragments,error: error)!
		return(object)
		}
		
	class func parseJSON(data:NSData) -> AnyObject
		{
		self.formatJSON((NSString(data:data,encoding:NSUTF8StringEncoding)) as! String)
		return(self.parseJSON((NSString(data:data,encoding:NSUTF8StringEncoding)) as! String));
		}
		
	class func formatJSON(string:String) -> String
		{
		var object:AnyObject
		var output:String
		var data:NSData
		var error:NSErrorPointer 
		
		object = self.parseJSON(string)
		error = NSErrorPointer()
		data = NSJSONSerialization.dataWithJSONObject(object,options:NSJSONWritingOptions.PrettyPrinted,error:error)!
		output = NSString(data: data,encoding:NSUTF8StringEncoding)! as String
		return(output)
		}
		
	
	}