//
//  MPSGLayerReLU.swift
//  
//
//  Created by Maxim Volgin on 22/06/2021.
//

import os.log
import Foundation
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public class MPSGLayerReLU: MPSGLayer {
    public let graph: MPSGraph
    public let name: String?
    public let variableData: [MPSGModel.VariableData] = []

    public init(graph: MPSGraph, name: String? = nil) {
        self.graph = graph
        self.name = name
    }

    public func callAsFunction(_ inputTensor: MPSGraphTensor) throws -> MPSGraphTensor {
        graph.reLU(with: inputTensor, name: name)
    }
    
}

