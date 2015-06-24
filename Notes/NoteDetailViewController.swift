//
//  NoteDetailViewController.swift
//  Notes
//
//  Created by Roma Herman on 12/11/14.
//  Copyright (c) 2014 Roma Herman. All rights reserved.
//

import UIKit
import CoreData
class NoteDetailViewController: UIViewController {
  
  @IBOutlet weak var noteView: UITextView!
  
  
  var note:Note?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let note = note {
      noteView.text = note.noteText
    }
    
  }
  
  override func viewWillDisappear(animated: Bool) {
    if let note = note {
      updateNote()
    } else {
      addNewNote()
    }
    createNotification()
  }
  
  func createNotification() {
    let localNotification = UILocalNotification()
    localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
    localNotification.alertBody = note!.noteText.stringByPaddingToLength(50, withString: note!.noteText, startingAtIndex: 0)
    localNotification.timeZone = NSTimeZone.defaultTimeZone()
    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
  }
  
  func updateNote() {
    note?.noteText = noteView.text
    
    let managedContext = CoreDataController.sharedController.managedObjectContext!
    
    var error: NSError?
    if !managedContext.save(&error) {
      println("Could not save \(error), \(error?.userInfo)")
    }
  }
  
  func addNewNote() {
    //1
    let managedContext = CoreDataController.sharedController.managedObjectContext!
    //2
    let entityDescripition = NSEntityDescription.entityForName("Note", inManagedObjectContext: managedContext)
    let note = Note(entity: entityDescripition!, insertIntoManagedObjectContext: managedContext)
    note.noteText = noteView.text
    //4
    var error: NSError?
    if !managedContext.save(&error) {
      println("Could not save \(error), \(error?.userInfo)")
    }
  }
  
  func deleteNoteIfEmpty(note:Note) {
    if note.noteText.isEmpty {
      //1
      let managedContext = CoreDataController.sharedController.managedObjectContext!
      //2
      managedContext.deleteObject(note)
      //3
      var error: NSError?
      if !managedContext.save(&error) {
        println("Could not save \(error), \(error?.userInfo)")
      }
    }
  }
  
}
