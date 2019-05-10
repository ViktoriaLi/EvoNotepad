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
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        if newNoteTextView.text != nil, newNoteTextView.text != "" {
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                let newNote = Note(entity: Note.entity(), insertInto: context)
                newNote.text = newNoteTextView.text
                newNote.date = Date()
                //notesListVC?.totalNotesCount! += 1
                try? context.save()
            }
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
