//
//  StoredCity.swift
//  weatherApp
//
//  Created by K Janakan on 18/2/20.
//  Copyright © 2020 K Janakan. All rights reserved.
//

import Foundation
import CoreData

class StoredCity:NSManagedObject{
    
    @NSManaged var city_code :String
    @NSManaged var country_code :String
    @NSManaged var name :String?
    
    
}
