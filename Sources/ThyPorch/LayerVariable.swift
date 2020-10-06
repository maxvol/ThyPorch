//
//  LayerVariable.swift
//  
//
//  Created by Maxim Volgin on 06/10/2020.
//

import os.log
import Foundation

public enum LayerVariable {
    case weight(layerShape: Shape, layerName: String?)
    case bias(layerShape: Shape, layerName: String?)
}

public extension LayerVariable {
    var countShapeName: (count: Int, shape: Shape, name: String?) {
        get {
            switch self {
            case .weight(let layerShape, let layerName):
                return (count: layerShape.weightCount, shape: layerShape.weightShape, name: layerName == nil ? nil : "\(layerName!).w")
            case .bias(let layerShape, let layerName):
                return (count: layerShape.biasCount, shape: layerShape.biasShape, name: layerName == nil ? nil : "\(layerName!).b")
            }
        }
    }
}
