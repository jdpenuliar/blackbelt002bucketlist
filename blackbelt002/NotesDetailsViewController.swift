//
//  NotesDetailsViewController.swift
//  blackbelt002
//
//  Created by JD Penuliar on 8/2/16.
//  Copyright © 2016 JD Penuliar. All rights reserved.
//

import UIKit
class NotesDetailsViewController: UIViewController {
    var addNoteBool = true
    var backButtonDelegate: BackButtonDelegate?
    var noteToEditIndexPath: Int?
    var noteToEdit: String?
    
    @IBOutlet weak var noteEditor: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if addNoteBool == false{
            noteEditor.text = noteToEdit
        }
    }
    override func didMove(toParentViewController parent: UIViewController?) {
        if (!(parent?.isEqual(self.parent) ?? false)) {
            print("Back Button Pressed!")
            if self.addNoteBool == true{
                backButtonDelegate?.backButtonPressedFrom(self, didFinishAddingNote: noteEditor.text!)
                print("Back Button Pressed true!")
            }else{
                backButtonDelegate?.backButtonPressedFrom(self, didFinishAddingNote: noteEditor.text!, atIndexPath: noteToEditIndexPath!)
                print("Back Button Pressed false!")
            }
        }
    }
}
