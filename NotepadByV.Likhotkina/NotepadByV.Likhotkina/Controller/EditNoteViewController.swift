//
//  EditNoteViewController.swift
//  NotepadByV.Likhotkina
//
//  Created by Mac Developer on 5/10/19.
//  Copyright © 2019 Viktoria. All rights reserved.
//

//add case if text removed
import UIKit

class EditNoteViewController: UIViewController {
    
    @IBOutlet weak var editNoteTextView: UITextView!
    
    weak var noteToEdit: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNoteAfterEditing)), animated: true)
        
        if noteToEdit != nil {
            editNoteTextView.text = noteToEdit?.text
        }
    }
    
    @objc func saveNoteAfterEditing() {
        noteToEdit?.text = editNoteTextView.text
        noteToEdit?.date = Date()
        NoteHandler.shared.appDelegate?.saveContext()
        self.navigationController?.popViewController(animated: false)
    }
}
