//
//  ViewController.swift
//  TodoEy
//
//  Created by Anthony Ruiz on 6/1/18.
//  Copyright © 2018 Jakaboy. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
   
   let realm = try! Realm()
   var todoItems : Results<Item>?
   var selectedCategory : Category? {
      didSet {
         loadItems()
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return todoItems?.count ?? 1
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
      
      if let item = todoItems?[indexPath.row] {
         
         cell.textLabel?.text = item.title
         
         /* Ternary operator
          value = condition ? valueIfTrue: valueIfFalse
          */
         
         cell.accessoryType = item.done ? .checkmark : .none
         
      } else {
         cell.textLabel?.text = "No Items Added"
      }
      
      return cell
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      if let item = todoItems?[indexPath.row] {
         do {
            try realm.write {
               item.done = !item.done
            }
         } catch {
            print("Error updating Done status, \(error)")
         }
         
      }
      
      tableView.reloadData()
      
      tableView.deselectRow(at: indexPath, animated: true)

   }
   
   //MARK - Add New Items
   
   @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
      
      var textField = UITextField()
      
      let alert = UIAlertController(title: "Add New TodoYe Item", message: "", preferredStyle: .alert)
      
      let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
         // what will happen once user click the add item button

         if let currentCategory = self.selectedCategory {
            do {
               try self.realm.write {
                  let newItem = Item()
                  newItem.title = (textField.text ?? "New Item")
                  newItem.dateCreated = Date()
                  currentCategory.items.append(newItem)
               }
            } catch {
               print("Error saving a new item, \(error)")
            }
         }
         
         self.tableView.reloadData()
         
      }
      
      alert.addTextField { (alertTextField) in
         alertTextField.placeholder = "Create a New Item"
         textField = alertTextField
      }
      
      alert.addAction(action)
      
      present(alert, animated: true, completion: nil)
      
   }
   
   //MARK - load items in the view
   
   func loadItems() {
      
      todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
      
      tableView.reloadData()
   }
   
}


//MARCK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {

   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
      todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
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

