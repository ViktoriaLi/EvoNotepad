//
//  ShowNoteViewController.swift
//  NotepadByV.Likhotkina
//
//  Created by Mac Developer on 5/10/19.
//  Copyright © 2019 Viktoria. All rights reserved.
//

import UIKit

class ShowNoteViewController: UIViewController {

    @IBOutlet weak var noteTextLabel: UILabel!
    
    weak var selectedNote: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedNote != nil {
            noteTextLabel.text = selectedNote!.text
        }
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote)), animated: true)
    }
    
    @objc func shareNote() {
        print("test")
    }
    
    @IBAction func returnToNotepadButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }
}
