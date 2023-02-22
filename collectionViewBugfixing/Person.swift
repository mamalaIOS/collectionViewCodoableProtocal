//
//  Person.swift
//  collectionViewBugfixing
//
//  Created by Amel Sbaihi on 1/31/23.
//

import UIKit

class Person: NSObject , Codable {
    
    var name : String
    var image : String
    
    init (name : String , image : String)
    {
           self.name = name
           self.image = image    }

}
