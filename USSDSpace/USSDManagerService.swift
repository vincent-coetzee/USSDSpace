//
//  USSDManagerService.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/16.
//  Copyright (c) 2015 MacSemantics. All rights reserved.
//

import Foundation
import AppKit

class USSDManagerService
	{
	var userName = "vincent"
	var password = "12345678"
	var port = "8080"
	var serverName = "localhost"
	var baseURL:String = ""
	var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
	var session = NSURLSession()
	var responseData:NSData?
	var response:NSURLResponse?
	var resultString:String?
	var resultObject:AnyObject?
	var token:String?
	
	var hasToken:Bool
		{
		get
			{
			return(token != nil)
			}
		}
		
	init()
		{
		baseURL = "http://\(serverName):\(port)/USSDManager/rest/USSDService"
		session = NSURLSession(configuration:configuration)
		}
		
	func workspaceNames()
		{
		var request:NSMutableURLRequest
		var url:NSURL = NSURL(string:baseURL + "/workspaceNames")!
		
		request = NSMutableURLRequest(URL: url)
		request.HTTPMethod = "GET"
		}
		
	func prepareRequest(method:String,contentType:String) -> NSMutableURLRequest
		{
		var request:NSMutableURLRequest
		var url:NSURL = NSURL(string:baseURL + "/\(method)")!
		request = NSMutableURLRequest(URL: url)
		request.addValue(contentType,forHTTPHeaderField:"Content-Type")
		if token != nil
			{
			request.addValue(token,forHTTPHeaderField:"Token")
			}
		return(request)
		}
		
	func requestToken(personName:String,userName:String,password:String)
		{
		var request:NSMutableURLRequest
		var task:NSURLSessionDataTask
		var string:String
		var time:NSDate
		var timeString:String
		var dict:NSDictionary?
		
		time = NSDate()
		timeString = NSString(format:"%lX",Int64(time.timeIntervalSince1970*1000)) as String
		request = prepareRequest("requestToken",contentType: "application/json")
		request.HTTPMethod = "POST"
		string = "{\"personName\":\"\(personName)\",\"requestToken\":\"\(timeString)\",\"timestamp\":\(time.timeIntervalSince1970*1000)}"
		task = session.uploadTaskWithRequest(request,fromData:string.dataUsingEncoding(NSUTF8StringEncoding),completionHandler: 
			{(data:NSData!,response:NSURLResponse!,error:NSError!) in 
			self.responseData = data
			self.response = response
			NSLog("\(error)")
			if data != nil
				{
				var string = NSString(data:data!,encoding:NSUTF8StringEncoding) as! String
				NSLog("\(string)")
				dict = JSONParser.parseJSON(string) as! NSDictionary
				if (dict!.objectForKey("successful") as! NSNumber).boolValue
					{
					self.token = dict!.objectForKey("result") as! String
					}
				else
					{
					var errorCode = dict!.objectForKey("errorCode")
					NSLog("ERROR CODE = \(errorCode)")
					}
				}
			})
		task.resume()
		while task.state != .Completed
			{
			NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow:5))
			}
		}
		
//	func runWorkspaceWithName(name:String) -> String
//		{
//		var request:NSMutableURLRequest
//		var task:NSURLSessionDataTask
//		
//		request = prepareRequest("runWorkspace/\(name)",contentType: "application/text")
//		request.HTTPMethod = "GET"
//		task = session.dataTaskWithRequest(request,completionHandler: 
//			{(data:NSData!,response:NSURLResponse!,error:NSError!) in 
//			self.responseData = data
//			self.response = response
//			NSLog("\(error)")
//			if data != nil
//				{
//				var string = NSString(data:data!,encoding:NSUTF8StringEncoding) as! String
//				NSLog("\(string)")
//				self.resultString = string
//				}
//			})
//		resultString = "";
//		task.resume()
//		while task.state != .Completed
//			{
//			NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow:5))
//			}
//		return(resultString!)
//		}
		
	func startURLForWorkspace(workspace:USSDWorkspace) -> String
		{
		var string:String
		
		string = baseURL + "/runWorkspace/\(workspace.workspaceName)"
		NSLog("START URL = \(string)")
		return(string)
		}
		
	func handleServiceError(dict:NSDictionary)
		{
		var errorCode:Int
		var errorMessage:String
		var heading:String
		
		errorCode = Int((dict["errorCode"]! as! NSNumber).intValue)
		errorMessage = dict["errorMessage"]! as! String
		heading = "Error Code \(errorCode)"
		ErrorSheet(heading:heading,message:errorMessage)
		}
		
	func deployWorkspace(workspace:USSDWorkspace)
		{
		var request:NSMutableURLRequest
		var task:NSURLSessionUploadTask
		var dict:NSDictionary?
		
		request = prepareRequest("deployWorkspace",contentType:"application/json")
		request.HTTPMethod = "POST"
		NSLog("\(JSONParser.formatJSON(workspace.asJSONString()))")
		task = session.uploadTaskWithRequest(request,fromData:workspace.asJSONString().dataUsingEncoding(NSUTF8StringEncoding),completionHandler: 
			{(data:NSData!,response:NSURLResponse!,error:NSError!) in 
			self.responseData = data
			self.response = response
			if error != nil
				{
				NSLog("ERROR = \(error)")
				}
			else
				{
				if data != nil
					{
					dict = JSONParser.parseJSON(NSString(data:data!,encoding:NSUTF8StringEncoding) as! String) as! NSDictionary
					if !(dict!.objectForKey("successful") as! NSNumber).boolValue
						{
						NSLog("\(dict)")
						}
					}
				}
			})
		task.resume()
		while task.state != .Completed
			{
			NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow:5))
			}
		}
	}