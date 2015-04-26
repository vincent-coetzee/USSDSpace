//
//  VisualContainer.swift
//  USSDSpace
//
//  Created by Vincent Coetzee on 2015/04/26.
//  Copyright (c) 2015 Olamide. All rights reserved.
//

import Foundation
import AppKit

protocol VisualContainer
	{
	var container:VisualContainer { get }
	var containerView:DesignView { get }
	var topItem:VisualItem? { get }
	var isView:Bool { get }
	func markForLayout()
	func markForDisplay()
	}