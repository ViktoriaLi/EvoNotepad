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
        if newNoteTextView.text != nil {
            let newNote = Note1(text: newNoteTextView.text, date: Date())
            notesListVC?.notes.append(newNote)
            notesListVC?.notepadTableView.reloadData()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
