//
//  Size.swift
//  
//
//  Created by Maxim Volgin on 03/10/2020.
//

import Foundation

public enum Size {
    case HW(Int, Int)
    case WH(Int, Int)
}

public extension Size {
    
    var toHW: (height: Int, width: Int) {
        get {
            switch self {
            case .HW(let H, let W):
                return (height: H, width: W)
            case .WH(let W, let H):
                return (height: H, width: W)
            }
        }
    }
    
    var toWH: (width: Int, height: Int) {
        get {
            switch self {
            case .HW(let H, let W):
                return (width: W, height: H)
            case .WH(let W, let H):
                return (width: W, height: H)
            }
        }
    }
    
}
