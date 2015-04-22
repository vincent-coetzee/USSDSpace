//
//  ActionSlot.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/11.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class ActionSlot:CALayer
	{
	enum ActionType
		{
		case Invoke(Int,String,String) 
		case SaveIndex(Int,String,String) 
		case SaveText(Int,String,String) 
		}
		
	var outerFrame:CGRect = CGRect(x:0,y:0,width:16,height:16)
	var actionType:ActionType?
	var menu:USSDMenu?
	
	init(rect:CGRect)
		{
		super.init()
		frame = rect
		outerFrame = rect
		actionType = ActionType.Invoke(1,"doNothing","0000-0000-0000-0000")
		self.contents = UFXStylist.SlotMenuImage
		}
		
	func asJSONString() -> String
		{
		switch(actionType!)
			{
		case let .Invoke(code,invokeMethodName,menuUUID):
			return("\"actionType\":\"method\",\"actionValue\":\"\(invokeMethodName)\",\"nextMenuUUID\":\"\(menuUUID)\"")
		case let .SaveIndex(code,name,menuUUID):
			return("\"actionType\":\"saveIndex\",\"actionValue\":\"\(name)\",\"nextMenuUUID\":\"\(menuUUID)\"")
		case let .SaveText(code,name,menuUUID):
			return("\"actionType\":\"saveText\",\"actionValue\":\"\(name)\",\"nextMenuUUID\":\"\(menuUUID)\"")
		default:
			return("")
			}
		}
		
	override func encodeWithCoder(coder:NSCoder)
		{
		super.encodeWithCoder(coder)
		coder.encodeRect(outerFrame,forKey:"outerFrame")
		encodeActionTypeWithCoder(coder,aType:actionType!,forKey:"actionType")
		}
		
	func encodeActionTypeWithCoder(coder:NSCoder,aType:ActionType,forKey:String)
		{
		switch(aType)
			{
		case let .Invoke(code,invokeMethodName,menuName):
			coder.encodeInteger(code,forKey:"\(forKey).code")
			coder.encodeObject(invokeMethodName,forKey:"\(forKey).invokeMethodName")
			coder.encodeObject(menuName,forKey:"\(forKey).nextMenuName")
			break;
		case let .SaveIndex(code,name,menuName):
			coder.encodeInteger(code,forKey:"\(forKey).code")
			coder.encodeObject(name,forKey:"\(forKey).name")
			coder.encodeObject(menuName,forKey:"\(forKey).nextMenuName")
			break;
		case let .SaveText(code,name,menuName):
			coder.encodeInteger(code,forKey:"\(forKey).code")
			coder.encodeObject(name,forKey:"\(forKey).name")
			coder.encodeObject(menuName,forKey:"\(forKey).nextMenuName")
			break;
		default:
			break;
			}
		}
		
	func decodeActionType(coder:NSCoder,forKey:String) -> ActionType
		{
		var code:Int = coder.decodeIntegerForKey("\(forKey).code")
		switch(code)
			{
		case 1:
			return(ActionType.Invoke(code,coder.decodeObjectForKey("\(forKey).invokeMethodName") as! String,coder.decodeObjectForKey("\(forKey).nextMenuName") as! String))
		case 2:
			return(ActionType.SaveIndex(code,coder.decodeObjectForKey("\(forKey).name") as! String,coder.decodeObjectForKey("\(forKey).nextMenuName") as! String))
		case 3:
			return(ActionType.SaveText(code,coder.decodeObjectForKey("\(forKey).name") as! String,coder.decodeObjectForKey("\(forKey).nextMenuName") as! String))
		default:
			return(ActionType.Invoke(code,coder.decodeObjectForKey("\(forKey).invokeMethodName") as! String,""))
			}
		}
		
	override init()
		{
		super.init()
		self.contents = UFXStylist.SlotMenuImage
		}
		
	override init(layer:AnyObject?)
		{
		super.init(layer: layer)
		self.contents = UFXStylist.SlotMenuImage
		}

	required init(coder aDecoder: NSCoder) 
		{
	    super.init(coder:aDecoder)
		outerFrame = aDecoder.decodeRectForKey("outerFrame")
		actionType = decodeActionType(aDecoder,forKey:"actionType") 
		self.contents = UFXStylist.SlotMenuImage
		}
	}