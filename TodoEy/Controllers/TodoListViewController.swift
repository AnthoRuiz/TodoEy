//
//  ViewController.swift
//  TodoEy
//
//  Created by Anthony Ruiz on 6/1/18.
//  Copyright © 2018 Jakaboy. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
   
   var itemArray = [Item]()
   var selectedCategory : Category? {
      didSet {
         loadItems()
      }
   }
   
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      loadItems()
      
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
      
      self.saveItems()
      
      tableView.deselectRow(at: indexPath, animated: true)

   }
   
   //MARK - Add New Items
   
   @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
      
      var textField = UITextField()
      
      let alert = UIAlertController(title: "Add New TodoYe Item", message: "", preferredStyle: .alert)
      
      let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
         // what will happen once user click the add item button

         let newItem = Item(context: self.context)
         newItem.title = (textField.text ?? "New Item")
         newItem.done = false
         newItem.parentCategory = self.selectedCategory
         self.itemArray.append(newItem)
         
         self.saveItems()
      }
      
      alert.addTextField { (alertTextField) in
         alertTextField.placeholder = "Create a New Item"
         textField = alertTextField
      }
      
      alert.addAction(action)
      
      present(alert, animated: true, completion: nil)
      
   }
   
   //MARK - Model Manupulation Methods
   
   func saveItems() {
      
      do{
         try context.save()
      } catch {
         print("Error saving context, \(error)")
      }
      
      self.tableView.reloadData()
   }
   
   //MARK - load items in the view
   
   func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate : NSPredicate? = nil) {
      
      let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
      
      if let addtionalPredicate = predicate {
         request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addtionalPredicate])
      } else {
         request.predicate = categoryPredicate
      }
      
      do {
         itemArray = try context.fetch(request)
      } catch {
         print("Error Fetching data from context \(error)")
      }
      tableView.reloadData()
   }
   
}


//MARCK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
   
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      let request :  NSFetchRequest<Item> = Item.fetchRequest()
      
      let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
      
      request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
      
      loadItems(with: request, predicate: predicate)
      
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

