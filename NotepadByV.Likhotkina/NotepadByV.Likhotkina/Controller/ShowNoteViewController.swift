//
//  ShowNoteViewController.swift
//  NotepadByV.Likhotkina
//
//  Created by Mac Developer on 5/10/19.
//  Copyright © 2019 Viktoria. All rights reserved.
//

import UIKit
import CoreData

class ShowNoteViewController: UIViewController {

    @IBOutlet weak var noteTextLabel: UILabel!
    
    var selectedNote: String?
    var activityViewController: UIActivityViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedNote != nil {
            noteTextLabel.text = selectedNote!
        }
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote)), animated: true)
    }
    
    @objc func shareNote() {
        if self.selectedNote != nil {
            let textToShare = [self.noteTextLabel.text!]
            self.activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            self.activityViewController?.popoverPresentationController?.sourceView = self.view
            self.present(self.activityViewController!, animated: true, completion: nil)
        }
    }
    
    @IBAction func returnToNotepadButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: false, completion: nil)
    }
}
