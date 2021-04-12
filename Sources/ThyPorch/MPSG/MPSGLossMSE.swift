//
//  MPSGLossMSE.swift
//  
//
//  Created by Maxim Volgin on 12/04/2021.
//

import Foundation

import os.log
import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public class MPSGLossMSE: MPSGLoss {
    let graph: MPSGraph
    let batchSize: MPSGraphTensor
    
    public init(graph: MPSGraph, batchSize: Double = Double(Hyper.batchSize)) {
        self.batchSize = graph.constant(batchSize, shape: [1], dataType: .float32)
        self.graph = graph
    }
    
    public func callAsFunction(_ output: MPSGraphTensor, _ labels: MPSGraphTensor) -> MPSGraphTensor {
        let loss = graph.reductionSum(with: output, axis: -1, name: name("_reductionSum_-1"))
        let mean = graph.division(loss, batchSize, name: name("_division"))
        return mean
    }

    func name(_ suffix: String) -> String {
        String(describing: name) + suffix
    }
}
