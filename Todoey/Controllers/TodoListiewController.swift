//
//  ViewController.swift
//  Todoey
//
//  Created by BANELLA Frederic on 16/08/2018.
//  Copyright © 2018 BANELLA Frederic. All rights reserved.
//

import UIKit

class TodoListiewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")


    override func viewDidLoad() {
        super.viewDidLoad()
        
        print (dataFilePath)
        
        // Do any additional setup after loading the view, typically from a nib.
//        let newitem = Item()
//        newitem.title = "Find Mike"
//        itemArray.append(newitem)
//
//        let newitem2 = Item()
//        newitem2.title = "Buy Eggs"
//        itemArray.append(newitem2)
//
//        let newitem3 = Item()
//        newitem3.title = "Destroy"
//        itemArray.append(newitem3)
        
        loadItems()
        
//        if let items  = defaults.array(forKey: "TodoListArray") as? [Item]{
//            itemArray = items
//        }
    }

    //MARK: - TableView DataSource Methods
    //TODO: Declare cellForRowAtIndexPath here:
    // Used to display each row for a given type of cell here TodoItemCell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //TODO: Declare numberOfRowsInSection here:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //MARK: - Table View delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print (itemArray[indexPath.row])
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    @IBAction func addButtonBarItem(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todoey item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add item on our UIAlert
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.saveItems()
        
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        
        present(alert,animated: true,completion: nil)
    }
    
    func saveItems(){
        let encoder =  PropertyListEncoder()
        do {
            let dataItem = try encoder.encode(itemArray)
            try dataItem.write(to:dataFilePath!)
        }
        catch {
            print ("Error encoding array, \(error)")
        }
       tableView.reloadData()
    }
    
    func loadItems(){
        let data = try? Data(contentsOf: dataFilePath!)
        let decoder = PropertyListDecoder()
        do {
            itemArray = try decoder.decode([Item].self, from: data!)
        } catch {
            print ("Error decoding item array")
        }
        
        
    }
    
    
    
}

