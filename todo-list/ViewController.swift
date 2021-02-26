//
//  ViewController.swift
//  todo-list
//
//  Created by Joakim Hellgren on 2021-01-31.
//

import CoreData
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var addButton: UIButton!
    
    var todos: [Todo] = []
    var items: [String] = []

    @IBAction func addButtonPressed(_ sender: Any) {
        addNote()
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addNote()
        textField.resignFirstResponder()
        return true;
    }
    
    func addNote() {
        if textField.text != "" {
            guard let item = textField.text else { return }
            textField.text = ""
            if items.contains(item) { return }
            items.append(item)
            saveCoreData(item: item)
        }
    }
    
    
    @IBAction func scribbleIconPressed(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        let todo = self.todos[indexPath.row].value(forKey: "item") as? String
        cell.configure(text: todo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if todos.count == 0 {
            return 0
        } else {
            return todos.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let persistentContainer = UIApplication.shared.delegate as? AppDelegate else { return }
            let safeContainer = persistentContainer.persistentContainer
            let fav = todos[indexPath.row]
            do {
                safeContainer.viewContext.delete(fav)
                try safeContainer.viewContext.save()
                todos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch let error as NSError {
                print("Could not save changes. \(error), \(error.userInfo)")
            }
        }
    }
    
    func saveCoreData(item: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Todo", in: managedContext)!
        let todo = Todo(entity: entity, insertInto: managedContext)
        todo.setValue(item, forKey: "item")
        do {
            try managedContext.save()
            todos.append(todo)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
        do {
            todos = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        textField.delegate = self
        fetchCoreData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

