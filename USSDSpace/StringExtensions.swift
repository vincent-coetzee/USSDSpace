//
//  StringExtensions.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/21.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation

extension String
	{
	var cleanString:String
		{
		get
			{
			var newString:String
			
			newString = self.stringByReplacingOccurrencesOfString("\n",withString:"\\n")
			newString = newString.stringByReplacingOccurrencesOfString("\r",withString:"\\r")
			newString = newString.stringByReplacingOccurrencesOfString("\t",withString:"\\t")
			return(newString)
			}
		}
	}