//
//  DataSource.swift
//  Hello-Contacts
//
//  Created by Marat Ibragimov on 12/10/2019.
//  Copyright © 2019 Marat Ibragimov. All rights reserved.
//

import Foundation


class DataSource<T> {
    private var data: [T] = []
    var count: Int  {
        return data.count
    }
    func item(at index: Int) -> T {
        return data[index]
    }
    
    func append(items: [T]) {
        data.append(contentsOf: items)
    }
    
    func insert(_ item:T, at index: Int) {
        data.insert(item, at: index)
    }
    
   @discardableResult
   func remove(at index: Int) -> T {
        return data.remove(at: index)
    }
}

