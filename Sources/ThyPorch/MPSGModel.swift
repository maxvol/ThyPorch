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

@available(iOS 14, *)
public protocol MPSGModel {
    typealias TensorBuilder = (MPSGraph, MPSGraphTensor) -> MPSGraphTensor
    typealias Target = (tensors: [MPSGraphTensor], operations: [MPSGraphOperation])
    
    func debug(_ graph: MPSGraph, _ inputTensor: MPSGraphTensor) -> MPSGraphTensor
    
    func sequence(graph: MPSGraph, inputTensor: MPSGraphTensor, _ builders: TensorBuilder...) -> MPSGraphTensor
    
    func build(graph: MPSGraph, inputTensor: MPSGraphTensor, labelTensor: MPSGraphTensor) -> (Target, Target)
    
}

@available(iOS 14, *)
public extension MPSGModel {
    
    func debug(_ graph: MPSGraph, _ inputTensor: MPSGraphTensor) -> MPSGraphTensor {
        os_log("shape: %@", log: Log.metalPerformanceShadersGraph, type: .debug, String(describing: inputTensor.shape))
        return inputTensor
    }
    
    func sequence(graph: MPSGraph, inputTensor: MPSGraphTensor, _ builders: TensorBuilder...) -> MPSGraphTensor {
        builders.reduce(inputTensor) { tensor, builder in
            builder(graph, tensor)
        }
    }
    
}

