//
//  Shape+MPSG.swift
//  
//
//  Created by Maxim Volgin on 03/10/2020.
//

import Foundation

public extension Shape {
    
    var toArrayNSNumber: [NSNumber] {
        get {
            toArrayInt.map { $0 as NSNumber }
        }
    }
    
}
