//
//  ViewController.swift
//  NotepadByV.Likhotkina
//
//  Created by Mac Developer on 5/9/19.
//  Copyright © 2019 Viktoria. All rights reserved.
//

import UIKit
import CoreData

class NotepadViewController: UIViewController {
    @IBOutlet weak var notepadTableView: UITableView!
    @IBOutlet weak var notesSearchBar: UISearchBar!
    
    var notes = [Note]()
    var filteredNotes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notepadTableView.delegate = self
        notepadTableView.dataSource = self
        notesSearchBar.delegate = self
        notesSearchBar.showsCancelButton = true
        getNotes()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notesSearchBar.showsCancelButton = false
        getNotes()
    }
    
    func getNotes() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let notepad = try? context.fetch(Note.fetchRequest()) as? [Note] {
                if notepad != nil{
                    notes = notepad!
                    filteredNotes = notepad!
                    notepadTableView.reloadData()
                }
            }
        }
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
    
    @IBAction func sortButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "A-Z", style: .default, handler: { (UIAlertAction)
            in
            self.performSorting(sortType: .alphabetAscending)
        }))
        alert.addAction(UIAlertAction(title: "Z-A", style: .default, handler: { (UIAlertAction)
            in
            self.performSorting(sortType: .alphabetDescending)
        }))
        alert.addAction(UIAlertAction(title: "Newest", style: .default, handler: { (UIAlertAction)
            in
            self.performSorting(sortType: .newest)
        }))
        alert.addAction(UIAlertAction(title: "Oldest", style: .default, handler: { (UIAlertAction)
            in
            self.performSorting(sortType: .oldest)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func performSorting(sortType: Sorting) {
        switch sortType {
            
        case .alphabetAscending:
            filteredNotes = filteredNotes.sorted{ $0.text! < $1.text! }
            notepadTableView.reloadData()
        case .alphabetDescending:
            filteredNotes = filteredNotes.sorted{ $0.text! > $1.text! }
            notepadTableView.reloadData()
        case .newest:
            filteredNotes = filteredNotes.sorted{ $0.date! < $1.date! }
            notepadTableView.reloadData()
        case .oldest:
            filteredNotes = filteredNotes.sorted{ $0.date! > $1.date! }
            notepadTableView.reloadData()
        }
    }
}

extension NotepadViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let note = filteredNotes[indexPath.row]
        let cell = notepadTableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as? NoteTableViewCell
        var noteText = note.text
        
        if noteText != nil, noteText!.count > 100 {
            noteText = String(noteText!.prefix(100))
        }

        if let creationDate = note.date {
            cell?.noteDateLabel.text = dateFormatter.string(from: creationDate)
        }
        cell?.noteTextLabel.text = noteText

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "showNoteID") as? ShowNoteViewController
    
        controller?.selectedNote = filteredNotes[indexPath.row]
        if controller != nil {
            self.navigationController?.pushViewController(controller!, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "editNoteVC") as? EditNoteViewController

            controller?.noteToEdit = self.filteredNotes[indexPath.row]
            if controller != nil {
                self.navigationController?.pushViewController(controller!, animated: true)
            }
                context.refresh(self.filteredNotes[indexPath.row], mergeChanges: true)
                try? context.save()
            }
        }
        editAction.backgroundColor = .blue
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                context.delete(self.notes[indexPath.row])
                self.notes.remove(at: indexPath.row)
                self.filteredNotes.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                self.notepadTableView.reloadData()
                    try? context.save()
            }
        }
        deleteAction.backgroundColor = .red
        
        return [deleteAction, editAction]
    }
}

extension NotepadViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredNotes = searchText.isEmpty ? notes : notes.filter { (item: Note) -> Bool in
            return item.text?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        notepadTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        notesSearchBar.showsCancelButton = true
    }
        
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        notesSearchBar.text = ""
        notesSearchBar.showsCancelButton = false
        notesSearchBar.endEditing(true)
        getNotes()
    }
}
