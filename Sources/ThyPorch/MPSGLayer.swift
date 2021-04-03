//
//  MPSGLayer.swift
//  
//
//  Created by Maxim Volgin on 03/04/2021.
//

import os.log
import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public protocol MPSGLayer {
    var graph: MPSGraph { get }
    var variableData: [MPSGModel.VariableData] { get }
    func callAsFunction(_ inputTensor: MPSGraphTensor) -> MPSGraphTensor
    func callAsFunction(_ graph: MPSGraph, _ inputTensor: MPSGraphTensor) -> MPSGraphTensor
//    static func data(layerVariable: LayerVariable) -> [Float32]
//    static func add(layerVariable: LayerVariable, to graph: MPSGraph) -> MPSGModel.VariableData
}

@available(macOS 11, iOS 14, *)
public extension MPSGLayer {

    static func data(layerVariable: LayerVariable) -> [Float32] {
        let (count, _, _) = layerVariable.countShapeName
        switch layerVariable {
        case .weight(_, _):
            return MPSGData.generate(parameterCount: count, minimum: -0.2, maximum: 0.2)
        case .bias(_, _):
            return MPSGData.generate(parameterCount: count, minimum: 0.1, maximum: 0.1)
        }
    }

    static func add(layerVariable: LayerVariable, to graph: MPSGraph) -> MPSGModel.VariableData {
        let (_, shape, name) = layerVariable.countShapeName
        let data = self.data(layerVariable: layerVariable)
        let tensor = graph.variable(with: MPSGData.data(for: data),
                                    shape: shape.toArrayNSNumber,
                                    dataType: .float32,
                                    name: name)
        return (tensor: tensor, data: data, name: name)
    }
    
    func callAsFunction(_ graph: MPSGraph, _ inputTensor: MPSGraphTensor) -> MPSGraphTensor {
        assert(graph === self.graph)
        return self.callAsFunction(inputTensor)
    }

}

