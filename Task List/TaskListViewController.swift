//
//  ViewController.swift
//  Task List
//
//  Created by Tushar Khandaker on 3/24/21.
//

import UIKit

class TaskListViewController: UITableViewController, UITextFieldDelegate {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(dataFilePath)
        loadItem()
        
        
    }
    
    //data source method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: " ListCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        if item.done == false {
            cell.accessoryType = .none
        }else {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    //delegate method
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done =  !itemArray[indexPath.row].done
        saveItem()
    }
    
    // add new item
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        showAlert()
        
    }
    
    func  showAlert() {
        
        let alert = UIAlertController(title: "Add Task", message: "Enter Your Task Here", preferredStyle: .alert)
        
        alert.addTextField { (textField : UITextField!) in
            textField.placeholder = "Enter  emails"
            textField.delegate = self
        }
        let save = UIAlertAction(title: "Save", style: .default) { saveAction in
            guard let textField = alert.textFields?[0].text else { return }
            
            if !textField.isEmpty{
                if !textField.trimmingCharacters(in: .whitespaces).isEmpty {
                    print(textField)
                    var newItem = Item ()
                    newItem.title = textField
                    self.itemArray.append(newItem)
                    self.saveItem()
                }  
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancelAction) in
            
        }
        alert.addAction(save)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        
    }
//save data
    func saveItem () {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: self.dataFilePath!)
        }catch {
            print("Saving Eorror Cause : \(error)")
        }
        
        self.tableView.reloadData()
    }
// load data
    func loadItem() {
        if let data = try? Data(contentsOf: dataFilePath!) {
        let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }catch {
                print("Load Error Cause: \(error)")
            }
           
    }
}
}
