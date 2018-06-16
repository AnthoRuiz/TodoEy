//
//  SwipeTableViewController.swift
//  TodoEy
//
//  Created by Anthony Ruiz on 6/15/18.
//  Copyright © 2018 Jakaboy. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
      
      tableView.rowHeight = 80.0
      tableView.separatorStyle = .none
    }
   
   // TableView DataSource Methods
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
      
      cell.delegate = self
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
      guard orientation == .right else { return nil }
      
      let deleteAction = SwipeAction(style: .destructive, title: nil) { action, indexPath in
         // handle action by updating model with deletion
         
         self.updateModel(at: indexPath)

      }
      
      // customize the action appearance
      deleteAction.image = UIImage(named: "delete-icon")
      
      return [deleteAction]
   }
   
   func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
      var options = SwipeOptions()
      options.expansionStyle = .destructive
      return options
   }
   
   func updateModel(at indexPath: IndexPath){
      //Update our data model
   }
   
}
