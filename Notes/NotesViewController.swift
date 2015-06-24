//
//  NotesViewController.swift
//  Notes
//
//  Created by Roma Herman on 12/11/14.
//  Copyright (c) 2014 Roma Herman. All rights reserved.
//

import UIKit
import CoreData
class NotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var notesTable: UITableView!
  var notes = [NSManagedObject]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(animated: Bool) {
    fetchNotes()
    notesTable.reloadData()
  }
  
  func fetchNotes() {
    //1
    let managedContext = CoreDataController.sharedController.managedObjectContext!
    //2
    let fetchRequest = NSFetchRequest(entityName:"Note")
    //3
    var error: NSError?
    let fetchedResults = managedContext.executeFetchRequest(
      fetchRequest,
      error: &error) as! [NSManagedObject]?
    
    if let results = fetchedResults {
      notes = results
    } else {
      println("fetch error = \(error), \(error!.userInfo)")
    }
  }
  
  //MARK: - TableView Datasource
  //1
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  //2
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return notes.count
  }
  
  //MARK: - TableView Delegate
  //3
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("NoteTableViewCell") as! UITableViewCell
    
    if let note = notes[indexPath.row] as? Note {
      cell.textLabel?.text = note.noteText
    }
    return cell
  }
  //4
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  //MARK: - Segue Delegate
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "OpenNoteSegue" {
      let noteDetailViewController = segue.destinationViewController as! NoteDetailViewController
      
      let cell = sender as! UITableViewCell
      let indexPath:NSIndexPath = notesTable.indexPathForCell(cell)!
      
      if let note = notes[indexPath.row] as? Note {
        noteDetailViewController.note = note
      }
    }
  }

}
