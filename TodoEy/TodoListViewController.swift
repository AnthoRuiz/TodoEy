//
//  ViewController.swift
//  TodoEy
//
//  Created by Anthony Ruiz on 6/1/18.
//  Copyright © 2018 Jakaboy. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
   
   var itemArray = ["uno", "dos", "tres"]

   override func viewDidLoad() {
      super.viewDidLoad()
      
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return itemArray.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
      
      cell.textLabel?.text = itemArray[indexPath.row]
      
      return cell
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
         tableView.cellForRow(at: indexPath)?.accessoryType = .none
      } else {
         tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
      }
      
      tableView.deselectRow(at: indexPath, animated: true)
   }
   
   //MARK - Add New Items
   
   @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
      
      var textField = UITextField()
      
      let alert = UIAlertController(title: "Add New TodoYe Item", message: "", preferredStyle: .alert)
      
      let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
         // what will happen once user click the add item button
         self.itemArray.append(textField.text ?? "New Item")
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

