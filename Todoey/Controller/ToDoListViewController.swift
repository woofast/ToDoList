//
//  ViewController.swift
//  Todoey
//
//  Created by Hufait on 11/11/19.
//  Copyright © 2019 Hufait. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var defaults = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let newItem = Item()
        newItem.title = "Clean up the kitchen"
//        newItem.done = true       (USE AS DEBUG to show if cellForRowAtIndexPath Called)
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Do the laundry"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Mob the floor"
        itemArray.append(newItem3)
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
        
            print("All AddItems that user entered has saved in default plist file persistantly")
        }
        
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        print("cellForRowAtIndexPath Called")
        
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoListItemCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
       
//**********  Ternary Operator  ==>     ****************************//
// **********  value = condition ? valueIfTrue : valueIfFalse  ******//
        
//        cell.accessoryType = item.done == true ? .checkmark : .none (EVEN SHORTER LOOK@65)
        cell.accessoryType = item.done ? .checkmark : .none
       
//         // this code displays the check mark here (look above@64 for SHORT CODING)
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//
//            cell.accessoryType = .none
//
//        }
        
        
        return cell
    }
    
    //MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//  BELOW itemArray expression with 3 lines of code is replaced with short version ABOVE
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//
//        } else {
//            itemArray[indexPath.row].done = false
//        }
//
        tableView.reloadData()
        
//        if  tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        tableView.deselectRow(at: indexPath, animated: true )
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // What will happen once the user clicks the Add Item button on our UIAlert
            
            let newItem = Item()
            
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
            

            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
   
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    
    
    
}

