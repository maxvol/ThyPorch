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
    typealias TensorBuilder = (MPSGraph, MPSGraphTensor) -> MPSGraphTensor
    
    func debug(_ graph: MPSGraph, _ input: MPSGraphTensor) -> MPSGraphTensor
    
    func sequence(graph: MPSGraph, input: MPSGraphTensor, _ builders: TensorBuilder...) -> MPSGraphTensor
    
    func build(graph: MPSGraph, input: MPSGraphTensor) -> MPSGraphTensor
    
}

@available(macOS 11, iOS 14, *)
public extension MPSGModel {
    
    func debug(_ graph: MPSGraph, _ input: MPSGraphTensor) -> MPSGraphTensor {
        os_log("shape: %@", log: Log.metalPerformanceShadersGraph, type: .debug, String(describing: input.shape))
        return input
    }
    
    func sequence(graph: MPSGraph, input: MPSGraphTensor, _ builders: TensorBuilder...) -> MPSGraphTensor {
        builders.reduce(input) { tensor, builder in
            builder(graph, tensor)
        }
    }
    
}

