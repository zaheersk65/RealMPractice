//
//  ViewController.swift
//  coreRealmTableView
//
//  Created by IMAC on 8/29/19.
//  Copyright © 2019 IMAC. All rights reserved.
//

import UIKit
import RealmSwift



class ViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var itemArray : Results<Item>?  //This is Category is Realm model Category which having types
   
    var selectedCategory : Category? {//This is created from categoryViewController class
        
        didSet {//DidSet  Property observers are called every time a property’s value is set, even if the new value is the same as the property’s current value .
            
            //Read or display the saved items
            displayItems()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //printing location path where core data stored
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
       print("filePath  \(dataFilePath)")
   
        
        }
    
    
    
    
    //MARK : - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoList", for: indexPath)
       
        if let cellItems = itemArray?[indexPath.row] {
            
            cell.textLabel?.text = cellItems.title//This title is in core data
            
            cell.accessoryType = cellItems.done ? .checkmark : .none //Ternary ooperator
            
        }else {
            cell.textLabel?.text = "No Items Added"
        }
                
        return cell
    }
    
    //Mark : - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        //MARK: Update should be in didSelectPath
        if let item = itemArray?[indexPath.row] {
            do{
                try realm.write {//updated
                    item.done = !item.done
                }
            }catch {
                print("Error saving done status,  \(error)")
            }
        }
        tableView.reloadData()
        
           tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        //MARK: DElete
        if let item = itemArray?[indexPath.row] {
            do{
                try realm.write {//delete
                    realm.delete(item)
                }
            }catch {
                print("Error saving done status,  \(error)")
            }
        }
            tableView.reloadData()
    }
    }

    //MARK: Core Data
    
    @IBAction func addList(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add an event", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Add Item", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            
            if textField.text == "" {
                alert.message = "Enter data"
                self.present(alert, animated: true, completion: nil)
                
            }
            else{
                
                
                if let currentCategory = self.selectedCategory {
                    
                    do {
                        try self.realm.write {
                            let newArray = Item()//Item is realm Data Model
                            newArray.title = textField.text!//These two title and done are from core data entity
                            //For date
                            newArray.dateWise = Date()
                            //MARK: Realm data
                            //Creating/saving data here
                            currentCategory.items.append(newArray)//This parentCategory created in datamodel in Categories
                            // newArray.done = false
                        }
                    }catch {
                        print("Error saving new items , \(error)")
                    }
                    
                }
                self.tableView.reloadData()
//
//
            
           
            }
            
            self.tableView.reloadData()
        }))
        //This is for adding textField in alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter item name"
            textField = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
        print("Selected")
        
    }
    
    
    
    //MARK: Model Manupulation Methods
    
    
//    //Read the data after saving like displying again
    func displayItems() {

        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }

}

//MARK: SearchBarMethods
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

//        itemArray = itemArray?.filter("title CONTAINS[cd] %@ ", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        //DateWise filter
        itemArray = itemArray?.filter("title CONTAINS[cd] %@ ", searchBar.text!).sorted(byKeyPath: "dateWise", ascending: true)
        
        tableView.reloadData()

    }
    
//    Go to Back to original list
//    After searching click cancel it will come to normal list
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
           displayItems() //Reload the tableView


            DispatchQueue.main.async {

                //This will hide the Keyboard also
                searchBar.resignFirstResponder()//This is to resign the didFinishTyping
            }

        }
    }
}

//MARK: Search bar for normal array data

//let countryNameArr = ["Afghanistan", "Albania", "Algeria", "American Samoa"]
//var searchedCountry = [String]()
//var searching = false

//func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//       searchedCountry = countryNameArr.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
//       searching = true
//       tblView.reloadData()
//   }
//
//   func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//       searching = false
//       searchBar.text = ""
//       tblView.reloadData()
//   }


//MARK: Dictionary to Array

//let array = ["Asia","Africa","Europe"]
//let countriesArray = [["China", "Japan", "Korea"],
//                      ["Egypt", "Sudan", "South Africa"],
//                      ["Spain", "Netherlands", "France"]]//This is array Dictionary
////This is used to change this above dictionary into array
//var selectedArray = [String]()
////This is used for index value for dictionary to array
//var selectedIndex = 0
//var selectedIndexPath = IndexPath(item: 0, section: 0)
//
//override func viewDidLoad() {
//       super.viewDidLoad()
//
//       //This is used to save dictionay data into string array
//        selectedArray = countriesArray[selectedIndex]
//}
//
//selectedArray[indexPath.row]
