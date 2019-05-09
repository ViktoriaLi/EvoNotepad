//
//  ViewController.swift
//  NotepadByV.Likhotkina
//
//  Created by Mac Developer on 5/9/19.
//  Copyright © 2019 Viktoria. All rights reserved.
//

import UIKit
import CoreData

struct Note1 {
    var text: String?
    var date: Date?
}

class NotepadViewController: UIViewController {
    @IBOutlet weak var notepadTableView: UITableView!
    @IBOutlet weak var notesSearchBar: UISearchBar!
    
    var notes = [Note1]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notepadTableView.delegate = self
        notepadTableView.dataSource = self
        notes.append(Note1(text: "test", date: Date()))
    }


    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let newVC = segue.destination as? AddNewNoteViewController {
            newVC.notesListVC = self
        }
        
    }
}

extension NotepadViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let note = notes[indexPath.row]
        let cell = notepadTableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as? NoteTableViewCell
        if let creationDate = note.date {
            cell?.noteDateLabel.text = dateFormatter.string(from: creationDate)
        }
        cell?.noteTextLabel.text = note.text

        return cell!
    }
}
