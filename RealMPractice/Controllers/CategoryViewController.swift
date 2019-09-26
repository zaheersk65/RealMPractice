//
//  CategoryViewController.swift
//  CoreDataEx
//
//  Created by IMAC on 9/20/19.
//  Copyright © 2019 IMAC. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
     let realm = try! Realm()
   
    var categories : Results<Category>?   //This is Category is Realm model Category which having title and done types in items
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Location Path
        print("LocationPath : \(Realm.Configuration.defaultConfiguration.fileURL)")
        
        
        displayItems()

    }

    
    
    //MARK : - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryViewController", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "NO Categories Added" //This title is in core data
        
        //cell.accessoryType = cellItem.done ? .checkmark : .none //Ternary ooperator
        
        return cell
    }
    
    //Mark : - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(categories?[indexPath.row])
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        //This is parenet class
        //Update should be in didSelectPath
        if let indexPathCategory = tableView.indexPathForSelectedRow {
            vc.selectedCategory = categories?[indexPathCategory.row]//This selectedCategory will be in viewCOntroller where child class is exist
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
       
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
    //MARK: DElete
            if let item = categories?[indexPath.row] {
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
    
    
    

    @IBAction func addEvents(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add an event", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Add Item", style: UIAlertAction.Style.default, handler: { _ in
            //Cancel Action
            
            if textField.text == "" {
                alert.message = "Enter data"
                self.present(alert, animated: true, completion: nil)
                
            }
            else{
                let newArray = Category()//Item is core data entity
                newArray.name = textField.text!//These two title and done are from core data entity
                
                
                //self.categories.append(newArray)
                
                //This will go to Create data and save
                self.saveItems(category: newArray)
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
//core data
//Creating/saving data here
    func saveItems(category: Category) {
    do{
        
        try realm.write {//Save/Create
            realm.add(category)
        }
        
    }catch {
        print("Error in saving \(error)")
        
    }
    tableView.reloadData()
}

//Read the data after saving like displying again
func displayItems() {

    categories = realm.objects(Category.self)
    
    tableView.reloadData()
}

}

