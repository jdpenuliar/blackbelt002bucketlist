//
//  NotesViewController.swift
//  blackbelt002
//
//  Created by JD Penuliar on 8/2/16.
//  Copyright © 2016 JD Penuliar. All rights reserved.
//

import UIKit
import CoreData
class NotesViewController: UITableViewController, BackButtonDelegate {
    var filteredNotes = [Notes]()
    let searchController = UISearchController(searchResultsController: nil)
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    var notesArr = [Notes]()
    var addNoteBool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        showNotes()
        //added
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredNotes.removeAll()
        filteredNotes = notesArr.filter { note in
            return note.notes!.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    @IBAction func composeButtonPressed(_ sender: UIBarButtonItem) {
        self.addNoteBool = true
        performSegue(withIdentifier: "AddNotesSegue", sender: self)
    }
    
    
    //delegates
    func backButtonPressedFrom(_ controller: UIViewController, didFinishAddingNote note: String) {
        print ("hahayes")
        let entityNotes = NSEntityDescription.entity(forEntityName: "Notes", in: managedObjectContext)
        let entityNotesObject = NSManagedObject(entity: entityNotes!, insertInto: managedObjectContext)
        entityNotesObject.setValue(note, forKey: "notes")
        let date = Date()
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.weekday, .day , .month , .year], from: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        let weekday = components.weekday
        
        print(year)
        print(month)
        print(day)
        print (weekday)
        print (components)
        print ("string: \(note) and date: \(Date())")
        entityNotesObject.setValue(Date(), forKey: "date")
        do{
            try managedObjectContext.save()
        }catch let error as NSError{
            print (error)
        }
        showNotes()
        
    }
    func backButtonPressedFrom(_ controller: UIViewController, didFinishAddingNote note: String, atIndexPath indexPath: Int) {
        print ("hahano")
        notesArr[indexPath].notes = note
        notesArr[indexPath].date = Date()
        do {
            try managedObjectContext.save()
        }catch let error as NSError{
            print(error)
        }
        showNotes()
    }
    //segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNotesSegue"{
            let noteController = segue.destination as! NotesDetailsViewController
            noteController.backButtonDelegate = self
            if self.addNoteBool == true{
                noteController.addNoteBool = true
            }else{
                noteController.addNoteBool = false
                if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                    noteController.noteToEditIndexPath = (indexPath as NSIndexPath).row
                    let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
                    noteController.noteToEdit = currentCell.textLabel?.text
                }
            }
        }
    }
    
    
    //tables
    //number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredNotes.count
        }
        return notesArr.count
    }
    
    //load table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let note: Notes
        if searchController.isActive && searchController.searchBar.text != "" {
            note = filteredNotes[(indexPath as NSIndexPath).row]
        } else {
            note = notesArr[(indexPath as NSIndexPath).row]
        }
        //        cell.textLabel?.text = missions[indexPath.row]
        cell.textLabel?.text = note.notes
        let date = note.date
        
        
        let RFC3339DateFormatter = DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        RFC3339DateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        
        
        
        
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.weekday, .day , .month , .year], from: date! as Date)
        var dayOfWeek: String?
        var monthOfYear: String?
        
        if components.weekday == 1{
            dayOfWeek = "Sunday"
        }else if components.weekday == 2{
            dayOfWeek = "Monday"
        }else if components.weekday == 3{
            dayOfWeek = "Tuesday"
        }else if components.weekday == 4{
            dayOfWeek = "Wednessday"
        }else if components.weekday == 5{
            dayOfWeek = "Thursday"
        }else if components.weekday == 6{
            dayOfWeek = "Friday"
        }else if components.weekday == 7{
            dayOfWeek = "Saturday"
        }
        
        if components.month == 1{
            monthOfYear = "01"
        }else if components.month == 2{
            monthOfYear = "02"
        }else if components.month == 3{
            monthOfYear = "03"
        }else if components.month == 4{
            monthOfYear = "04"
        }else if components.month == 5{
            monthOfYear = "05"
        }else if components.month == 6{
            monthOfYear = "06"
        }else if components.month == 7{
            monthOfYear = "07"
        }else if components.month == 8{
            monthOfYear = "08"
        }else if components.month == 9{
            monthOfYear = "09"
        }else if components.month == 10{
            monthOfYear = "10"
        }else if components.month == 11{
            monthOfYear = "11"
        }else if components.month == 12{
            monthOfYear = "12"
        }
        
        
        if components.day! < 10{
            cell.detailTextLabel?.text = "\(monthOfYear!)-0\(components.day)-\(components.year)"
        }else if components.day! >= 10{
            cell.detailTextLabel?.text = "\(monthOfYear!)-\(components.day)-\(components.year)"
        }
        return cell
        
    }
    
    //cell tap
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.addNoteBool = false
        performSegue(withIdentifier: "AddNotesSegue", sender: tableView.cellForRow(at: indexPath))
    }
    //delete
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            let notesIndex = notesArr[(indexPath as NSIndexPath).row]
            managedObjectContext.delete(notesIndex)
            do{
                try managedObjectContext.save()
                showNotes()
            }catch let error as NSError{
                print(error)
            }
        }
    }
    
    
    
    //helper function
    func showNotes(){
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        //swift 2
//        let fetch = NSFetchRequest(entityName: "Notes")
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        fetch.sortDescriptors = [sortDescriptor]
        
        do{
            let result = try managedObjectContext.fetch(fetch)
            notesArr = result as! [Notes]
            print(notesArr)
            tableView.reloadData()
            
        }catch let error as NSError{
            print (error)
        }
        
    }
}
extension NotesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
