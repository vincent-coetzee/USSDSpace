//
//  VisualLinkedMenuEntry.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/26.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit
import QuartzCore

class VisualDataMenuEntry:VisualLinkingMenuEntry
	{
	override init()
		{
		super.init()
		leftSlot.linkCreationClosure = {() in return(VisualDataLink())}
		rightSlot.linkCreationClosure = {() in return(VisualDataLink())}
		labelItem.backgroundColor = UFXStylist.DataSlotLinkColor.lighter().withAlpha(0.2).CGColor
		}

	override init(layer:AnyObject)
		{
		super.init(layer:layer)
		}
		
	required init?(coder aDecoder: NSCoder) 
		{
	    super.init(coder: aDecoder)
		leftSlot.linkCreationClosure = {() in return(VisualDataLink())}
		rightSlot.linkCreationClosure = {() in return(VisualDataLink())}
		labelItem.backgroundColor = UFXStylist.DataSlotLinkColor.lighter().withAlpha(0.2).CGColor
		}
	}