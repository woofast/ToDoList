//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hufait on 11/26/19.
//  Copyright © 2019 Hufait. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let contextThruAppDelegate = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategoryFromCoreData()
        
    }
    
     //MARK:  - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
         return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
//        let category = categoryArray[indexPath.row]
//
//        cell.textLabel?.text = category.name
        
       return cell
    }
    
    
    
    //MARK:  - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        saveCategoryToCoreData()
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    //TODO:  - Prepare for Segueway to allow VIEW from CategoryView to jump to ToDoListView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! ToDoListViewController
        
       if let indexPath = tableView.indexPathForSelectedRow {
            destinationViewController.selectedCategory = categoryArray[indexPath.row]
            
        }
        
    }
    
    
    //MARK:  - Data Manipulation Methods
    func saveCategoryToCoreData() {
        
        do {
            
            try contextThruAppDelegate.save()
            
        } catch {
            
            print("Error saving category \(error)")
            
        }
        tableView.reloadData()
    }
    
    func loadCategoryFromCoreData() {
        //here we need to  specify the output<Category> of this type NSFetchRequest
                let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try contextThruAppDelegate.fetch(request)
            
        } catch {
            
            print("Error fetching data from category \(error)")
            
        }
        tableView.reloadData()
    }
  
    
    
    //MARK:  - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // What will happen once the user clicks the Add Category button on our UIAlert
            
            let newCategory = Category(context: self.contextThruAppDelegate)
            
            newCategory.name = textField.text!

            self.categoryArray.append(newCategory)
            
            self.saveCategoryToCoreData()
            
        }
         alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            
            textField.placeholder = "Create New Category"
            
        }

        present(alert, animated: true, completion: nil)
        
    }
        
    
  
    
}
