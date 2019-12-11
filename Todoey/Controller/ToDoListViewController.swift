//
//  ViewController.swift
//  Todoey
//
//  Created by Hufait on 11/11/19.
//  Copyright © 2019 Hufait. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var toDoItems : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let firstRandomColor = UIColor.flatYellow
    let secondRandomColor = UIColor.flatMagenta
    let thirdRandomColor = UIColor.flatNavyBlue
    
    //    let contextThruAppDelegate = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        let gradientColor = GradientColor(.topToBottom, frame: .init(x: 0, y: 44, width: 414, height: 896), colors: [firstRandomColor, secondRandomColor, thirdRandomColor])
        tableView.backgroundColor = gradientColor
        tableView.separatorStyle = .none
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        title = selectedCategory!.name
        
        if let colorHex = selectedCategory?.color {
            guard let navBar = navigationController?.navigationBar else {fatalError("Navigation Controller Does Not Exist.")}
            
            if let navBarContrastColor = UIColor(hexString: colorHex) {
                
                navBar.barTintColor = navBarContrastColor
                
                navBar.tintColor = ContrastColorOf(navBarContrastColor, returnFlat: true)
                
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarContrastColor, returnFlat: true) ]
                
                searchBar.barTintColor = navBarContrastColor
            }
            
          
        }
    }
    
    //MARK: - ******************* Tableview Datasource Methods ******************
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.title

          
                if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage:
              
                // Currently on row #5
                // Assume there's a total number of 10 items in toDoItems
                
                CGFloat(indexPath.row) / CGFloat(toDoItems!.count)
                ) {
                    
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
               
            }
            
            
            
            // whole number gets rounded           print("Version 1: \(CGFloat(indexPath.row/toDoItems!.count))")
            // float number / float number = decimal for percentage shade color           print("Version 2: \(CGFloat(indexPath.row) / CGFloat(toDoItems!.count))")
            
            
            //**********  Ternary Operator  ==>     ****************************//
            // **********  value = condition ? valueIfTrue : valueIfFalse  ******//
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK: - ********************** Tableview Delegate Methods **********************
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
            
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true )
    }
    
    //MARK: - ******************* Add New Items **************************
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        
                        currentCategory.items.append(newItem)
                    }
                    
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - ************************* Model Manipulation Methods *************************
    
    func loadItems() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    
    //MARK:  - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        
        //        super.updateModel(at: indexPath)
        
        if let itemForDeletion = toDoItems?[indexPath.row] {
            
            do {
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
        
    }
    
} ///Bottomline of Class



//MARK: - Search Bar Methods

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}
