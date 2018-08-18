//
//  ViewController.swift
//  Todoey
//
//  Created by BANELLA Frederic on 16/08/2018.
//  Copyright © 2018 BANELLA Frederic. All rights reserved.
//

import UIKit
import CoreData

class TodoListiewController: UITableViewController {
    
    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at:indexPath.row)
        saveItems()
        
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
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            // add it to the itemArray
            self.itemArray.append(newItem)
            
            //save it
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.saveItems()
        
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
    
    // save Items in Core Data DB and reload table view
    func saveItems(){
        do {
            try context.save()
        }
        catch {
            print ("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    // load items from Core Data and refresh the view
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest() , predicate : NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionnalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionnalPredicate])
        }
        else {
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray =  try context.fetch(request)
        } catch {
            print ("Error while fetching context, \(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Search Bar Methods
// When search button is clicked, perform the fetch in Core Data
extension TodoListiewController : UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors =  [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       // print(searchText)
        if searchText.count == 0 {
            loadItems()
            
            //dismiss the search bar & remove the keyboard
            // put it in the main queue to r^
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

//MARK: - With encoder
//    func saveItems(){
//        let encoder =  PropertyListEncoder()
//        do {
//            let dataItem = try encoder.encode(itemArray)
//            try dataItem.write(to:dataFilePath!)
//        }
//        catch {
//            print ("Error encoding array, \(error)")
//        }
//       tableView.reloadData()
//    }

//    func loadItems(){
//        let data = try? Data(contentsOf: dataFilePath!)
//        let decoder = PropertyListDecoder()
//        do {
//            itemArray = try decoder.decode([Item].self, from: data!)
//        } catch {
//            print ("Error decoding item array")
//        }
//    }
