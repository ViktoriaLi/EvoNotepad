//
//  AddNewNoteViewController.swift
//  NotepadByV.Likhotkina
//
//  Created by Mac Developer on 5/9/19.
//  Copyright © 2019 Viktoria. All rights reserved.
//

import UIKit

class AddNewNoteViewController: UIViewController {

    @IBOutlet weak var newNoteTextView: UITextView!
    
    weak var notesListVC: NotepadViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //newNoteTextView.selectedTextRange = newNoteTextView.textRange(from: newNoteTextView.beginningOfDocument, to: newNoteTextView.beginningOfDocument)
        //newNoteTextView.beginFloatingCursor(at: CGPoint(x: 0, y: 0))
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if newNoteTextView.text != nil, newNoteTextView.text != "" {
            if let context = NoteHandler.shared.context {
                let newNote = Note(entity: Note.entity(), insertInto: context)
                newNote.text = newNoteTextView.text
                newNote.date = Date()
                 NoteHandler.shared.totalNotesCount! += 1
                NoteHandler.shared.appDelegate?.saveContext()
                
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
