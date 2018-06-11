//
//  CategoryViewController.swift
//  TodoEy
//
//  Created by Anthony Ruiz on 6/8/18.
//  Copyright © 2018 Jakaboy. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

   var categories = [Category]()
   
   let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
      loadCategories()
      
    }
   
   //MARK: - TableView DataSource Methods
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return categories.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
      let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
      
      cell.textLabel?.text = categories[indexPath.row].name
      
      return cell
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

      performSegue(withIdentifier: "goToItems", sender: self)

   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let destinationVC = segue.destination as! TodoListViewController
      
      if let indexPath = tableView.indexPathForSelectedRow {
         destinationVC.selectedCategory = categories[indexPath.row]
      }
   }
   
   //MARK: - Data Manipulation Methods
   

   // MARK: - add new Categories

   
   @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
      
      var textField = UITextField()
      
      let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
      
      let action = UIAlertAction(title: "Add", style: .default) { (action) in
         
         let newCategory = Category(context: self.context)
         
         newCategory.name = (textField.text ?? "New Category")
         
         self.categories.append(newCategory)
         
         self.saveCategories()
      }
      
      alert.addTextField { (alertTextField) in
         alertTextField.placeholder = "Add a New Category"
         textField = alertTextField
      }
      
      alert.addAction(action)
      
      present(alert, animated: true, completion: nil)
 
   }
   
   func saveCategories() {
      
      do{
         try context.save()
      } catch {
         print("Error saving context, \(error)")
      }
      
      self.tableView.reloadData()
   }
   
   func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
      
      do {
         categories = try context.fetch(request)
      } catch {
         print("Error loading categories \(error)")
      }
      tableView.reloadData()
   }
   
}

//MARCK: - Search bar methods
extension CategoryViewController: UISearchBarDelegate {
   
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      
      let request :  NSFetchRequest<Category> = Category.fetchRequest()
      
      request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
      request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
      
      loadCategories(with: request)
      
   }
   
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      if searchBar.text?.count == 0 {
         loadCategories()
         DispatchQueue.main.async {
            searchBar.resignFirstResponder()
         }
      }
   }
}
