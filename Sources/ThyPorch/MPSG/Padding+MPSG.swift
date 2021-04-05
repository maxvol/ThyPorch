//
//  Padding+MPSG.swift
//  
//
//  Created by Maxim Volgin on 02/10/2020.
//

import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public extension Padding {
    
    var toMPSGraphPaddingStyle: MPSGraphPaddingStyle {
        get {
            switch self {
            case .same:
                return .TF_SAME
            case .valid:
                return .TF_VALID
            }
        }
    }
    
}
