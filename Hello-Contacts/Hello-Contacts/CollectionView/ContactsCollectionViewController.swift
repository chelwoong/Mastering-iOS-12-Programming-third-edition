//
//  ContactsCollectionViewController.swift
//  Hello-Contacts
//
//  Created by Marat Ibragimov on 03/10/2019.
//  Copyright © 2019 Marat Ibragimov. All rights reserved.
//

import UIKit
import Contacts
class ContactsCollectionViewController: UIViewController {

    var contactsManager = ContactsManager ()
    var dataSource = DataSource<Contact>()
    @IBOutlet var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let store = CNContactStore()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.collectionViewLayout = ContactsCollectionViewLayout()
        self.collectionView.register(UINib(nibName: "ContactCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ContactCollectionViewCell")
        contactsManager.authorize(store:store) { (authorized) in
            
            if authorized {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    var contacts = self.contactsManager.retrieveContacts(from: store) ?? []
                    
                    for _ in 0..<10 {
                        contacts.append(contentsOf: contacts)
                    }
                    self.dataSource.append(items: contacts)
                    self.collectionView.reloadData()
                }
            }
        }
        self.navigationItem.rightBarButtonItem = editButtonItem
        let longPressGesture = UILongPressGestureRecognizer(target: self, action:#selector(self.didLongPressOnItem(gesture:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
      super.setEditing(editing, animated: animated)

      for cell in collectionView.visibleCells {
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
          if editing {
            cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
          } else {
            cell.backgroundColor = .clear
          }
        }, completion: nil)
      }
    }
    
    @objc func didLongPressOnItem(gesture: UILongPressGestureRecognizer) {
        let tappedPoint = gesture.location(in: self.collectionView)
        guard let indexPath = self.collectionView.indexPathForItem(at: tappedPoint),
            let tappedCell = collectionView.cellForItem(at: indexPath) as? ContactCollectionViewCell else { return } 
      
        if isEditing {
            beginReorderingForCell(tappedCell: tappedCell, tappedPoint: tappedPoint, at: indexPath, gestureRecognizer: gesture)
         } else {
            deleteContactForCell(tappedCell: tappedCell, at: indexPath)
         }
       
        
    }
    
    func beginReorderingForCell(tappedCell: UICollectionViewCell,tappedPoint: CGPoint, at indexPath: IndexPath, gestureRecognizer: UIGestureRecognizer) {
        
        let state = gestureRecognizer.state
        switch state {
        case .began:
            collectionView.beginInteractiveMovementForItem(at: indexPath)
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
              tappedCell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }, completion: nil)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(tappedPoint)
        case .ended:
             collectionView.endInteractiveMovement()
        default:
             collectionView.endInteractiveMovement()
        }
    }

    func deleteContactForCell(tappedCell: ContactCollectionViewCell, at indexPath: IndexPath) {
        let confirmationDialog = UIAlertController(title: "Delete", message: "Would you like to remove this item?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction.init(title: "Delete", style: .destructive) { (action) in
            self.dataSource.remove(at: indexPath.row)
            self.collectionView.deleteItems(at: [indexPath])
        }
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        confirmationDialog.addAction(deleteAction)
        confirmationDialog.addAction(cancelAction)
        if let popOver = confirmationDialog.popoverPresentationController {
            popOver.sourceView = tappedCell
            popOver.permittedArrowDirections = [UIPopoverArrowDirection.up]
            let imageCenter = tappedCell.contactImageView.center
            popOver.sourceRect = CGRect(x: imageCenter.x,  y: imageCenter.y,
                                        width: 0,  height: 0)
            
        }
        present(confirmationDialog, animated: true, completion: nil)
    }
}


extension ContactsCollectionViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return dataSource.count
  }

  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
      "ContactCollectionViewCell", for: indexPath) as! ContactCollectionViewCell
    let contact = dataSource.item(at: indexPath.row)
    cell.nameLabel.text = "\(contact.givenName) \(contact.familyName)"
    contact.fetchImageIfNeeded { image in
      cell.contactImageView.image = image
    }

    return cell
  }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = dataSource.remove(at: sourceIndexPath.row)
        dataSource.insert(item, at: destinationIndexPath.row)
    }
}


extension ContactsCollectionViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ContactCollectionViewCell else { return }
        UIView.animate(withDuration: 0.5, animations: {
            cell.contactImageView.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        }) { (finished) in
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseIn], animations: {
              cell.contactImageView.transform = .identity
            }, completion: { [weak self]  finished in
                
                self?.performSegue(withIdentifier: "detailViewSegue", sender: self)
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
      if isEditing {
        cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
      } else {
        cell.backgroundColor = .clear
      }
    }
}



extension ContactsCollectionViewController {
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let contactDetailVC = segue.destination as? ContactDetailsVC,
      segue.identifier == "detailViewSegue",
      let selectedIndex = collectionView.indexPathsForSelectedItems?.first {
        contactDetailVC.contact = dataSource.item(at: selectedIndex.row)
    }
  }
}
