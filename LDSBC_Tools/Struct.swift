//
//  Struct.swift
//  LDSBC_Tools
//
//  Created by Riley Hooper on 5/29/15.
//  Copyright (c) 2015 LDS BC. All rights reserved.
//

import Foundation
import Parse

struct department {
    var name : String
    var description : String
    var location : String
    var phone : String
    var email : String
    var website : String
}

struct event {
    var image : PFFile
    var name : String
    var description : String
    var startDate : NSDate
    var endDate : NSDate
    var location : String
    var website : String
    
}

struct deal {
    var image : PFFile
    var title : String
    var description : String
    var company : String
    var address : String
    var startDate : NSDate
    var endDate : NSDate
    
}