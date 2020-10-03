//
//  Stride.swift
//  
//
//  Created by Maxim Volgin on 03/10/2020.
//

import Foundation

public enum Stride {
    case YX(Int, Int)
    case XY(Int, Int)
}

public extension Stride {
    
    var toYX: (y: Int, x: Int) {
        get {
            switch self {
            case .YX(let Y, let X):
                return (y: Y, x: X)
            case .XY(let X, let Y):
                return (y: Y, x: X)
            }
        }
    }
    
    var toXY: (x: Int, y: Int) {
        get {
            switch self {
            case .YX(let Y, let X):
                return (x: X, y: Y)
            case .XY(let X, let Y):
                return (x: X, y: Y)
            }
        }
    }
    
}
