//
//  CategoryViewController.swift
//  TodoEy
//
//  Created by Anthony Ruiz on 6/8/18.
//  Copyright © 2018 Jakaboy. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

   let realm = try! Realm()
   
   var categories : Results<Category>?
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
      loadCategories()

    }
   
   //MARK: - TableView DataSource Methods
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
      return categories?.count ?? 1
      
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = super.tableView(tableView, cellForRowAt: indexPath)
      
      cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added  Yet"

      cell.backgroundColor = UIColor(hexString: categories?[indexPath.row].colour ?? "1D9BF6")
      
      return cell
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

      performSegue(withIdentifier: "goToItems", sender: self)

   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      let destinationVC = segue.destination as! TodoListViewController
      
      if let indexPath = tableView.indexPathForSelectedRow {
         destinationVC.selectedCategory = categories?[indexPath.row]
      }
   }
   
   //MARK: - Data Manipulation Methods
   
   func save(category: Category) {
      
      do{
         try realm.write {
            realm.add(category)
         }
      } catch {
         print("Error saving context, \(error)")
      }
      
      self.tableView.reloadData()
   }
   
   func loadCategories() {
      
      categories = realm.objects(Category.self)
      
      tableView.reloadData()
   }

   // MARK: - Delete Data From Swipe
   
   override func updateModel(at indexPath: IndexPath) {
      if let categoryForDeletion = self.categories?[indexPath.row]{
         do{
            try self.realm.write {
               self.realm.delete(categoryForDeletion)
            }
         } catch {
            print("Error deleting categories, \(error)")
         }
      }
   }
   
   

   // MARK: - add new Categories

   
   @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
      
      var textField = UITextField()
      
      let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
      
      let action = UIAlertAction(title: "Add", style: .default) { (action) in
         
         let newCategory = Category()
         
         newCategory.name = (textField.text ?? "New Category")
         
         newCategory.colour = UIColor.randomFlat.hexValue()
         
         self.save(category: newCategory)
      }
      
      alert.addTextField { (alertTextField) in
         alertTextField.placeholder = "Add a New Category"
         textField = alertTextField
      }
      
      alert.addAction(action)
      
      present(alert, animated: true, completion: nil)
 
   }
   
}




//MARCK: - Search bar methods
//extension CategoryViewController: UISearchBarDelegate {
//   
//   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//      
//      let request :  NSFetchRequest<Category> = Category.fetchRequest()
//      
//      request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
//      request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
//      
//      loadCategories(with: request)
//      
//   }
//   
//   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//      if searchBar.text?.count == 0 {
//         loadCategories()
//         DispatchQueue.main.async {
//            searchBar.resignFirstResponder()
//         }
//      }
//   }
//}
