//
//  VisualItemSet.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/26.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit

class VisualItemSet:NSObject,SequenceType
	{
	var items:[VisualItem] = [VisualItem]()
	
	override init()
		{
		super.init()
		items = [VisualItem]()
		}
		
	init(coder:NSCoder)
		{
		items = coder.decodeObjectForKey("items") as! [VisualItem] 
		}
		
	func encodeWithCoder(coder:NSCoder)
		{
		coder.encodeObject(items,forKey:"items")
		}
		
	func addItem(item:VisualItem)
		{
		items.append(item)
		}
		
	func removeItem(item:VisualItem)
		{
		var index = find(items,item)
		if index != nil
			{
			items.removeAtIndex(index!)
			}
		}
		
	func removeFromLayer()
		{
		for item in items
			{
			item.removeFromSuperlayer()
			}
		}
		
	func frameChanged(sourceItem:VisualItem)
		{
		for item in items
			{
			item.frameChanged(sourceItem)
			}
		}
		
	func itemContainingPoint(point:CGPoint) -> VisualItem?
		{
		for item in items
			{
			var found = item.hitTest(point) as! VisualItem?
			if found != nil
				{
				return(found)
				}
			}
		return(nil)
		}
		
	func generate() -> GeneratorOf<VisualItem> 
		{
        // keep the index of the next car in the iteration
        var nextIndex = 0

        // Construct a GeneratorOf<Car> instance, passing a closure that returns the next car in the iteration
        return GeneratorOf<VisualItem> 
			{
            if (nextIndex >= self.items.count) 
				{
                return nil
				}
            return self.items[nextIndex++]
			}
		}
		
	subscript(index:Int) -> VisualItem
		{
		get
			{
			return(items[index])
			}
		set
			{
			items[index] = newValue
			}
		}
	}
	