//
//  ViewController.swift
//  Todoey
//
//  Created by BANELLA Frederic on 16/08/2018.
//  Copyright © 2018 BANELLA Frederic. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListiewController: UITableViewController {
    
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
  
    override func viewDidLoad() {
        super.viewDidLoad()
        print (dataFilePath)
        
    }

    //MARK: - TableView DataSource Methods
    //TODO: Declare cellForRowAtIndexPath here:
    // Used to display each row for a given type of cell here TodoItemCell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No item added"
        }
        
        return cell
    }
    
    //TODO: Declare numberOfRowsInSection here:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK: - Table View delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do {
            try realm.write {
                item.done = !item.done
            }
            } catch {
                print ("Error during saving status \(error)")
            }
            
            tableView.reloadData()
    }
        
        //print (itemArray[indexPath.row])
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //context.delete(itemArray[indexPath.row])
        //todoItems.remove(at:indexPath.row)
        //todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        //saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    @IBAction func addButtonBarItem(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todoey item", message: "", preferredStyle: .alert)
        
        // Add Item Action
        // what will happen once the user clicks the add item on our UIAlert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // create new Item and default values
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item()
                        item.title = textField.text!
                        item.dateCreated = Date()
                        currentCategory.items.append(item)
                    }
                }
                catch {
                    print ("Error during adding new item \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        // create the alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        //show it on screen
        present(alert,animated: true,completion: nil)
    }
    
    
    // load items from Core Data and refresh the view
    func loadItems() {
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

extension TodoListiewController : UISearchBarDelegate {
    
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

