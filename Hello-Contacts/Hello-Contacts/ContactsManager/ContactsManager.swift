//
//  ContactsManager.swift
//  Hello-Contacts
//
//  Created by Marat Ibragimov on 03/10/2019.
//  Copyright © 2019 Marat Ibragimov. All rights reserved.
//

import Foundation
import Contacts

class ContactsManager {
    
    func authorize(store: CNContactStore,   authorizeHanlder: @escaping  AuthorizeClosure) {
          let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
          if authorizationStatus == .notDetermined {
              store.requestAccess(for: .contacts) { didAuthorize, error in
                  authorizeHanlder(didAuthorize)
              }
          } else if authorizationStatus == .authorized {
              authorizeHanlder(true)
          }
      }

      func retrieveContacts(from store: CNContactStore) -> [Contact]? {
          let containerId = store.defaultContainerIdentifier()
          let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
          let keysToFetch = [CNContactGivenNameKey as CNKeyDescriptor,
                             CNContactFamilyNameKey as CNKeyDescriptor,
                             CNContactImageDataAvailableKey as CNKeyDescriptor,
                             CNContactImageDataKey as CNKeyDescriptor]
          
          let contacts = try? store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
              .map { Contact(contact: $0) }
          
          return contacts
      }
    
}
