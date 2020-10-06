//
//  LayerVariable.swift
//  
//
//  Created by Maxim Volgin on 06/10/2020.
//

import os.log
import Foundation

public enum LayerVariable {
    case weight(shape: Shape, layerName: String?)
    case bias(shape: Shape, layerName: String?)
}

public extension LayerVariable {
    var parameterCountAndName: (parameterCount: Int, name: String?) {
        get {
            switch self {
            case .weight(let shape, let layerName):
                return (parameterCount: shape.weightCount, name: layerName == nil ? nil : "\(layerName!).w")
            case .bias(let shape, let layerName):
                return (parameterCount: shape.biasCount, layerName == nil ? nil : "\(layerName!).b")
            }
        }
    }
}
