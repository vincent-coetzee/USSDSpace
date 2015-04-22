//
//  USSDManagerService.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/16.
//  Copyright (c) 2015 Olamide. All rights reserved.
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
		return(request)
		}
		
	func runWorkspaceWithName(name:String) -> String
		{
		var request:NSMutableURLRequest
		var task:NSURLSessionDataTask
		
		request = prepareRequest("runWorkspace/\(name)",contentType: "application/text")
		request.HTTPMethod = "GET"
		task = session.dataTaskWithRequest(request,completionHandler: 
			{(data:NSData!,response:NSURLResponse!,error:NSError!) in 
			self.responseData = data
			self.response = response
			NSLog("\(error)")
			if data != nil
				{
				var string = NSString(data:data!,encoding:NSUTF8StringEncoding) as! String
				NSLog("\(string)")
				self.resultString = string
				}
			})
		resultString = "";
		task.resume()
		while task.state != .Completed
			{
			NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow:5))
			}
		return(resultString!)
		}
		
	func deployWorkspace(workspace:USSDWorkspace)
		{
		var request:NSMutableURLRequest
		var task:NSURLSessionUploadTask
		var string:String
		
		string = JSONParser.formatJSON(workspace.asJSONString())
		NSLog("\(string)")
		request = prepareRequest("deployWorkspace",contentType:"application/json")
		request.HTTPMethod = "POST"
		NSLog("\(workspace.asJSONString())")
		task = session.uploadTaskWithRequest(request,fromData:workspace.asJSONString().dataUsingEncoding(NSUTF8StringEncoding),completionHandler: 
			{(data:NSData!,response:NSURLResponse!,error:NSError!) in 
			self.responseData = data
			self.response = response
			NSLog("\(error)")
			if data != nil
				{
				var string = NSString(data:data!,encoding:NSUTF8StringEncoding) as! String
				NSLog("\(string)")
				}
			})
		task.resume()
		while task.state != .Completed
			{
			NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow:5))
			}
		}
	}