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
    public let graph: MPSGraph
    public let name: String? = nil
    public let variableData: [MPSGModel.VariableData] = []
    
    let builders: [MPSGModel.TensorBuilder]

    init(graph: MPSGraph, _ builders: [MPSGModel.TensorBuilder]) {
        self.graph = graph
        self.builders = builders
    }

    convenience public init(graph: MPSGraph, _ builders: MPSGModel.TensorBuilder...) {
        self.init(graph: graph, builders)
    }
    
    public func callAsFunction(_ inputTensor: MPSGraphTensor) -> MPSGraphTensor {
        builders.reduce(inputTensor) { tensor, builder in
            builder(graph, tensor)
        }
    }
}
