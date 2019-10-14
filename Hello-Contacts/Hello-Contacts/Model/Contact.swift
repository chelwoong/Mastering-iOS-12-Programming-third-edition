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
