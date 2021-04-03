//
//  MPSGModel.swift
//  
//
//  Created by Maxim Volgin on 30/09/2020.
//

import os.log
import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public protocol MPSGModel {
    
    typealias VariableData = (tensor: MPSGraphTensor, data: [Float32], name: String?)
    typealias TensorBuilder = (MPSGraph, MPSGraphTensor) -> MPSGraphTensor
    typealias Target = (tensors: [MPSGraphTensor], operations: [MPSGraphOperation])
    typealias TargetTuple = (inference: Target, training: Target)
    
    var variableData: [VariableData] { get }
    
    func debug(_ graph: MPSGraph, _ inputTensor: MPSGraphTensor) -> MPSGraphTensor
    
    func sequence(graph: MPSGraph, inputTensor: MPSGraphTensor, variableData: inout [VariableData], _ layers: MPSGLayer...) -> MPSGraphTensor
    
//    func sequence(graph: MPSGraph, inputTensor: MPSGraphTensor, variableData: inout [VariableData], _ builders: TensorBuilder...) -> MPSGraphTensor
    
    func build(graph: MPSGraph, inputTensor: MPSGraphTensor, labelTensor: MPSGraphTensor) -> TargetTuple

}

@available(macOS 11, iOS 14, *)
public extension MPSGModel {
    
    func debug(_ graph: MPSGraph, _ inputTensor: MPSGraphTensor) -> MPSGraphTensor {
        os_log("shape: %@", log: Log.metalPerformanceShadersGraph, type: .debug, String(describing: inputTensor.shape))
        return inputTensor
    }
    
    func sequence(graph: MPSGraph, inputTensor: MPSGraphTensor, variableData: inout [VariableData], _ layers: MPSGLayer...) -> MPSGraphTensor {
        let result = layers.reduce(inputTensor) { tensor, layer in
            layer(tensor)
        }
        for layer in layers {
            variableData += layer.variableData
        }
        return result
    }
    
//    func sequence(graph: MPSGraph, inputTensor: MPSGraphTensor, variableData: inout [VariableData], _ builders: TensorBuilder...) -> MPSGraphTensor {
//        builders.reduce(inputTensor) { tensor, builder in
//            builder(graph, tensor)
//        }
//    }
    
}

