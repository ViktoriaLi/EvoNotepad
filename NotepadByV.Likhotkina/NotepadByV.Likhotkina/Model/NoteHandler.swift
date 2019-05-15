//
//  NoteHandler.swift
//  NotepadByV.Likhotkina
//
//  Created by Viktoriia LIKHOTKINA on 5/13/19.
//  Copyright © 2019 Viktoria. All rights reserved.
//

import Foundation
import CoreData

class NoteHandler {
    static let shared = NoteHandler()
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
    var totalNotesCount: Int? = 0
    
    var appDelegate: AppDelegate? = nil {
        didSet {
            context = appDelegate?.persistentContainer.viewContext
        }
    }
    
    var context: NSManagedObjectContext? = nil {
        didSet {
            totalNotesCount = try! context?.count(for: fetchRequest)
        }
    }
    
    let fetchSize: Int = 20
}
