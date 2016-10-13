//
//  BackButtonDelegate.swift
//  blackbelt002
//
//  Created by JD Penuliar on 8/2/16.
//  Copyright © 2016 JD Penuliar. All rights reserved.
//
import UIKit
protocol BackButtonDelegate: class {
    func backButtonPressedFrom(_ controller: UIViewController, didFinishAddingNote note: String)
    func backButtonPressedFrom(_ controller: UIViewController, didFinishAddingNote note: String, atIndexPath indexPath: Int)
}
