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
    @IBOutlet weak var emptyTableLabel: UILabel!
    
    
    var ifSorted: Bool = false
    let spinnerFooter = UIActivityIndicatorView.init(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var notes = [Note]()
    
    var filteredNotes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notepadTableView.delegate = self
        notepadTableView.dataSource = self
        notesSearchBar.delegate = self
        notesSearchBar.showsCancelButton = false
        NoteHandler.shared.appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        
        self.spinnerFooter.frame = CGRect(x: 0, y: 0, width: notepadTableView.bounds.width, height: 50)
        if NoteHandler.shared.totalNotesCount! > NoteHandler.shared.fetchSize {
            self.spinnerFooter.startAnimating()
        }
        if NoteHandler.shared.totalNotesCount == 0 {
            emptyTableLabel.text = "No notes"
            emptyTableLabel.isHidden = false
        }
        self.notepadTableView.tableFooterView = self.spinnerFooter
        
        let searchBarStyle = notesSearchBar.value(forKey: "searchField") as? UITextField
        searchBarStyle?.clearButtonMode = .never
        
        getNotes(startIndex: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetSearchState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        resetSearchState()
    }
    
    func getNotes(startIndex: Int) {
        
        if ifSorted == false {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            fetchRequest.fetchOffset = startIndex
            fetchRequest.fetchLimit = NoteHandler.shared.fetchSize
            if let context = NoteHandler.shared.context {
                
                if let notepad = try? context.fetch(fetchRequest) as? [Note] {
                    if notepad != nil {
                        if startIndex == 0 {
                            notes = notepad!
                            filteredNotes = notepad!
                        }
                        else {
                            notes += notepad!
                            filteredNotes += notepad!
                        }
                        notepadTableView.reloadData()
                    }
                }
            }
        }
    }

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter
    }()
    
    let timeFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
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
            print("1")
            print(self.filteredNotes)
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
            print("2")
            print(filteredNotes)
            notepadTableView.reloadData()
            print("3")
            print(filteredNotes)
        case .alphabetDescending:
            filteredNotes = filteredNotes.sorted{ $0.text! > $1.text! }
            notepadTableView.reloadData()
        case .newest:
            filteredNotes = filteredNotes.sorted{ $0.date! > $1.date! }
            notepadTableView.reloadData()
        case .oldest:
            filteredNotes = filteredNotes.sorted{ $0.date! < $1.date! }
            notepadTableView.reloadData()
        }
    }
    
    func stopSpinner() {
        self.spinnerFooter.stopAnimating()
        self.notepadTableView.tableFooterView = UIView()
    }
}

extension NotepadViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let note = filteredNotes[indexPath.row]
        let cell = notepadTableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as? NoteTableViewCell
        
        cell?.accessoryView?.frame = CGRect(x: 5, y: 5, width: 5, height: 5)
        var adjustedFrame = cell?.accessoryView?.frame
        adjustedFrame?.origin.x += 10.0
        cell?.accessoryView?.frame = adjustedFrame!
        
        if ifSorted == false, indexPath.row == filteredNotes.count - 1, NoteHandler.shared.totalNotesCount! > filteredNotes.count {
            getNotes(startIndex: indexPath.row + 1)
        } else if ifSorted == false, indexPath.row == filteredNotes.count - 1, NoteHandler.shared.totalNotesCount! <= filteredNotes.count {
            stopSpinner()
        }
        
        var noteText = note.text
        
        if noteText != nil, noteText!.count > 100 {
            noteText = String(noteText!.prefix(100))
        }

        if let creationDate = note.date {
            cell?.noteDateLabel.text = dateFormatter.string(from: creationDate)
            cell?.noteTimeLabel.text = timeFormatter.string(from: creationDate)
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
            if let context = NoteHandler.shared.context {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "editNoteVC") as? EditNoteViewController
                controller?.noteToEdit = self.filteredNotes[indexPath.row]
                if controller != nil {
                    self.navigationController?.pushViewController(controller!, animated: true)
                }
                context.refresh(self.filteredNotes[indexPath.row], mergeChanges: true)
                NoteHandler.shared.appDelegate?.saveContext()
            }
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
            let alert = UIAlertController(title: "Delete note?", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (UIAlertAction)
                in
                if let context = NoteHandler.shared.context {
                    //context.delete(self.notes[indexPath.row])
                    context.delete(self.filteredNotes[indexPath.row])
                    self.notes.remove(at: indexPath.row)
                    self.filteredNotes.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self.notepadTableView.reloadData()
                    NoteHandler.shared.totalNotesCount! -= 1
                    NoteHandler.shared.appDelegate?.saveContext()
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        return [deleteAction, editAction]
    }
}

extension NotepadViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            filteredNotes = notes
            while filteredNotes.count != NoteHandler.shared.totalNotesCount {
                self.getNotes(startIndex: self.filteredNotes.count)
            }
            filteredNotes = searchText.isEmpty ? notes : notes.filter { (item: Note) -> Bool in
                print("4")
                print(filteredNotes)
                ifSorted = true
                stopSpinner()
                return item.text?.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            notepadTableView.reloadData()
            print("5")
            print(filteredNotes)
        } else {
            resetSearchState()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        notesSearchBar.showsCancelButton = true
        print("searchBarTextDidBeginEditing")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarCancelButtonClicked")
        resetSearchState()
    }
    
    func resetSearchState() {
        ifSorted = false
        notesSearchBar.text = ""
        notesSearchBar.showsCancelButton = false
        notesSearchBar.endEditing(true)
        stopSpinner()
        getNotes(startIndex: 0)
    }
}
