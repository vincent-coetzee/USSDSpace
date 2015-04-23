//
//  USSDEngineService.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/23.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit

class USSDEngineService:NSObject,NSURLSessionDelegate
	{
	var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
	var session = NSURLSession()
	var responseData:NSData?
	var response:NSURLResponse?
	var resultString:String?
		
	override init()
		{
		super.init()
		session = NSURLSession(configuration:configuration,delegate:self,delegateQueue:nil)
		}

	func URLSession(_ session: NSURLSession,didReceiveChallenge challenge: NSURLAuthenticationChallenge,completionHandler completionHandler: (NSURLSessionAuthChallengeDisposition,NSURLCredential!) -> Void)
		{
		var trust = challenge.protectionSpace.serverTrust
		var credential:NSURLCredential
		
		credential = NSURLCredential(forTrust:trust)
		completionHandler(NSURLSessionAuthChallengeDisposition.UseCredential,credential)
		}
		
	func fetchXMLAtURL(aString:String) -> String
		{
		var request:NSMutableURLRequest
		var task:NSURLSessionDataTask
		var string:String
		var time:NSDate
		var timeString:String
		var dict:NSDictionary?
		
		NSLog("\(aString)")
		request = NSMutableURLRequest(URL:NSURL(string:aString)!)
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
				self.resultString = (string as NSString).stringByReplacingOccurrencesOfString("196.38.58.244",withString:"10.1.7.1")
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
	}