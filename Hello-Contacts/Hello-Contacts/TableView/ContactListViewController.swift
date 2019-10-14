//
//  ViewController.swift
//  Hello-Contacts
//
//  Created by Marat Ibragimov on 22/09/2019.
//  Copyright © 2019 Marat Ibragimov. All rights reserved.
//

import UIKit
import Contacts

typealias AuthorizeClosure = (Bool) -> Void
class ContactListViewController: UIViewController {
    
    var dataSource = DataSource<Contact>()
    lazy var tableViewAdapter: ContactListAdapter = {
       return ContactListAdapter(dataSource: dataSource)
    }()
    var contactsManager = ContactsManager()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
        self.tableView.delegate = self
        self.tableView.dataSource = tableViewAdapter
        self.tableView.prefetchDataSource = tableViewAdapter
        let xib = UINib.init(nibName: "ContactTableViewCell", bundle: nil)
        self.tableView.register(xib, forCellReuseIdentifier: "ContactTableViewCell")
        navigationItem.rightBarButtonItem = editButtonItem
        let store = CNContactStore()
        contactsManager.authorize(store: CNContactStore()) { authorized in
            if authorized {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    let contacts = self.contactsManager.retrieveContacts(from: store) ?? []
                    self.dataSource.append(items: contacts)
                    self.tableView.reloadData()
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
  
}



class ContactListAdapter: NSObject, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    var dataSource: DataSource<Contact>?
    init(dataSource: DataSource<Contact>) {
        self.dataSource = dataSource
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath) as! ContactTableViewCell
        guard let contact = dataSource?.item(at: indexPath.row) else {
            fatalError("no data")
        }
        cell.nameLabel.text = "\(contact.givenName) \(contact.familyName)"
        contact.fetchImageIfNeeded { image in
            cell.contactImage.image = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            // 3
            guard let contact = dataSource?.item(at: indexPath.row) else {
                fatalError("no data")
            }
            contact.fetchImageIfNeeded()
        }
        print(indexPaths)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let item = dataSource?.remove(at: sourceIndexPath.row) {
            dataSource?.insert(item, at: destinationIndexPath.row)
        }
    }
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print( "cacnel prefetch \(indexPaths)")
    }
}




extension ContactListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let contact = dataSource.item(at: indexPath.row)
        let alertController = UIAlertController(title: "Contact tapped",
                                                message: "You tapped \(contact.givenName)",
            preferredStyle: .alert)
        let dissmisAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        alertController.addAction(dissmisAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteHanlder: UIContextualAction.Handler = { action, view, callback in
            self.dataSource.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
            callback(true)
        }
        
        let action = UIContextualAction(style: .destructive, title: "Delete", handler: deleteHanlder)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}


 



