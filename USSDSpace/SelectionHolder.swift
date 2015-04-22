//
//  SelectionHolder.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/06.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation

class SelectionHolder<T:Selectable>
	{
	private var actualSelection:T?
	
	var selection:T?
		{
		get
			{
			return(actualSelection)
			}
		set
			{
			if actualSelection != nil
				{
				actualSelection!.deselect()
				}
			actualSelection = newValue
			if actualSelection != nil
				{
				actualSelection!.select()
				}
			}
		}
	}
