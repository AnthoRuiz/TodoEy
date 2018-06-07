//
//  ViewController.swift
//  TodoEy
//
//  Created by Anthony Ruiz on 6/1/18.
//  Copyright © 2018 Jakaboy. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
   
   var itemArray = [Item]()
   let defaults = UserDefaults.standard

   override func viewDidLoad() {
      super.viewDidLoad()
      
      let newItem = Item()
      newItem.title = "UNO"
      itemArray.append(newItem)
      
      let newItem2 = Item()
      newItem2.title = "DOS"
      itemArray.append(newItem2)
      
      let newItem3 = Item()
      newItem3.title = "TRES"
      itemArray.append(newItem3)
      
      let newItem4 = Item()
      newItem4.title = "CUATRO"
      itemArray.append(newItem4)
      
      if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
         itemArray = items
      }
      
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return itemArray.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
      
      let item = itemArray[indexPath.row]
      
      cell.textLabel?.text = item.title
      
      /* Ternary operator
       value = condition ? valueIfTrue: valueIfFalse
      */
      
      cell.accessoryType = item.done ? .checkmark : .none
      
      return cell
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      itemArray[indexPath.row].done = !itemArray[indexPath.row].done
      
      tableView.reloadData()
      tableView.deselectRow(at: indexPath, animated: true)

   }
   
   //MARK - Add New Items
   
   @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
      
      var textField = UITextField()
      
      let alert = UIAlertController(title: "Add New TodoYe Item", message: "", preferredStyle: .alert)
      
      let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
         // what will happen once user click the add item button
         
         let newItem = Item()
         newItem.title = (textField.text ?? "New Item")
         
         self.itemArray.append(newItem)
         
         self.defaults.setValue(self.itemArray, forKey: "TodoListArray")
         
         self.tableView.reloadData()
      }
      
      alert.addTextField { (alertTextField) in
         alertTextField.placeholder = "Create a New Item"
         textField = alertTextField
      }
      
      alert.addAction(action)
      
      present(alert, animated: true, completion: nil)
      
   }
   
}

