//
//  ViewController.swift
//  Todoey
//
//  Created by Hufait on 11/11/19.
//  Copyright © 2019 Hufait. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
 
    var selectedCategory : Category? {
        didSet{
            loadItemsFromCoreData()
        }
    }
    
    
    let contextThruAppDelegate = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
          tableView.separatorStyle = .none
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    //MARK: - ******************* Tableview Datasource Methods ******************
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //**********  Ternary Operator  ==>     ****************************//
        // **********  value = condition ? valueIfTrue : valueIfFalse  ******//
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - ********************** Tableview Delegate Methods **********************
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItemsToPlist()  //here we need to save items so that the checkmark done property can be saved before sending to context
        
        tableView.deselectRow(at: indexPath, animated: true )
    }
    
    //MARK: - ******************* Add New Items **************************
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.contextThruAppDelegate)
            
            newItem.title = textField.text!
            
            newItem.done = false
            
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItemsToPlist()
            
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - ************************* Model Manipulation Methods *************************
    
    
    //TODO:    New Method to save data persistantly on document(item.plist OR CoreData) in the sandbox not in user default plist
    func saveItemsToPlist() {
        
        do {
            
            try contextThruAppDelegate.save()
            
        } catch {
            
            print("Error saving context \(error)")
            
        }
        self.tableView.reloadData()
    }
    
    //TODO:  New Method to Load Items from plist to the tableview
    
    // Load Items From CoreData with output of type <Item> Entity
    func loadItemsFromCoreData(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try contextThruAppDelegate.fetch(request)
            
        } catch {
            
            print("Error fetching data from context \(error)")
            
        }
        tableView.reloadData()
    }
    
} ///Bottomline of Class



//MARK: - Search Bar Methods

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        //        print(searchBar.text!)
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItemsFromCoreData(with: request, predicate: predicate)
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItemsFromCoreData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
    
}
