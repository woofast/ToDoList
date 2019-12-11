//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Hufait on 11/26/19.
//  Copyright © 2019 Hufait. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    
    //    let contextThruAppDelegate = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let firstRandomColor = UIColor.flatYellow
    let secondRandomColor = UIColor.flatMagenta
    let thirdRandomColor = UIColor.flatNavyBlue
 
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
         let gradientColor = GradientColor(.topToBottom, frame: .init(x: 0, y: 44, width: 414, height: 896), colors: [firstRandomColor, secondRandomColor, thirdRandomColor])
        tableView.backgroundColor = gradientColor
        tableView.separatorStyle = .none
        loadCategory()
        
    }
    
    // Can comment this line of code for viewWillAppear so that the color of the last selected Category on the color of Todoey title
//    override func viewWillAppear(_ animated: Bool) {
//        guard let navBar = navigationController?.navigationBar else {
//            fatalError("Navigation Controller Does Not Exist.")
//              
//        }
//        
//        navBar.backgroundColor = UIColor(hexString: "8368FF")
//    }
    
    //MARK:  - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1  // Nil Coalescing Operator.   ? means if it is not nil .. then..
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //          Safer way to write the code without ??
        if let categoryIndex = categoryArray?[indexPath.row] {
            cell.textLabel?.text = categoryIndex.name
           
//       cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added Yet"
//
//        cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].color ?? "8368FF")
           
        guard let categoryColor = UIColor(hexString: categoryIndex.color) else {fatalError("Category color does not working")}
        
//        if let color = UIColor(hexString: (categoryArray?[indexPath.row].color)!) {

            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
          

        }
        
//        cell.textLabel?.font = UIFont(name: "MavenPro-Medium", size: 18)
  
        return cell
    }
    
    
    
    //MARK:  - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ///        saveCategoryToCoreData()
        //BIG WARNING!!! DO NOT SAVE DATA HERE BEFORE PERFORM SEGUE. THIS WAY YOU WILL ONLY SAVE "NOTHING" AND SENDING NIL TO ToDoListViewController. Because the context is saved for nil before segue to ToDoListViewController, the search bar nor the items in the category will represent nil. 
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    //TODO:  - Prepare for Segueway to allow VIEW from CategoryView to jump to ToDoListView
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationViewController.selectedCategory = categoryArray?[indexPath.row]
            
        }
        
    }
    
    
    //MARK:  - Data Manipulation Methods
    func save(category: Category) {
        
        do {
            
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            
            print("Error saving category \(error)")
            
        }
        tableView.reloadData()
    }
    
    func loadCategory() {
        //here we need to  specify the output<Category> of this type NSFetchRequest
        
        categoryArray = realm.objects(Category.self)
        
        
        tableView.reloadData()
    }
    
    //MARK:  - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {

//        super.updateModel(at: indexPath)
        
        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            
            do {
                    try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                    }
                } catch {
                    print("Error deleting category, \(error)")
                    }
                }
            
        }
        
    
    
    //MARK:  - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // What will happen once the user clicks the Add Category button on our UIAlert
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            
            newCategory.color = UIColor.randomFlat.hexValue()
            
            //            self.categoryArray.append(newCategory)  //Realm will auto-update and monitered the changes so we don't need to append new category no more.
            
            
            self.save(category: newCategory)
            
        }
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            
            textField.placeholder = "Create New Category"
            
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
}///bottomline of class

