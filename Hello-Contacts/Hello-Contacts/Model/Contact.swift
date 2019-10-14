//
//  Contact.swift
//  Hello-Contacts
//
//  Created by Marat Ibragimov on 27/09/2019.
//  Copyright © 2019 Marat Ibragimov. All rights reserved.
//

import UIKit
import Contacts

class Contact {
  private let contact: CNContact
  var image: UIImage?

  // 1
  var givenName: String {
    return contact.givenName
  }

  var familyName: String {
    return contact.familyName
  }

  init(contact: CNContact) {
    self.contact = contact
  }
    
  var emailAddress: String {
    // 1
    return String(contact.emailAddresses.first?.value ?? "--")
  }

  var phoneNumber: String {
    // 2
    return contact.phoneNumbers.first?.value.stringValue ?? "--"
  }

  var address: String {
    // 3
    let street = contact.postalAddresses.first?.value.street ?? "--"
    let city = contact.postalAddresses.first?.value.city ?? "--"

    return "\(street) \(city)"
  }

  //2
  func fetchImageIfNeeded(completion: @escaping ((UIImage?) -> Void) = {_ in }) {
    guard contact.imageDataAvailable == true, let imageData = contact.imageData else {
        completion(nil)
      return
    }

    if let image = self.image {
        completion(image)
      return
    }

    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      self?.image = UIImage(data: imageData)
      DispatchQueue.main.async {
        completion(self?.image)
      }
    }
  }
}
