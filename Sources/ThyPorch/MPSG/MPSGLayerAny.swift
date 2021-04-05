//
//  MPSGLayerAny.swift
//  
//
//  Created by Maxim Volgin on 03/04/2021.
//

import os.log
import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public class MPSGLayerAny: MPSGLayer {
    public var graph: MPSGraph
    public var variableData: [MPSGModel.VariableData] = []
    let builders: [MPSGModel.TensorBuilder]
    
    public init(graph: MPSGraph, _ builders: MPSGModel.TensorBuilder...) {
        self.graph = graph
        self.builders = builders
    }
    
    public func callAsFunction(_ inputTensor: MPSGraphTensor) -> MPSGraphTensor {
        builders.reduce(inputTensor) { tensor, builder in
            builder(graph, tensor)
        }
    }
}
