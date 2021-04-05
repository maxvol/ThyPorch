//
//  MPSGLossCCE.swift
//  
//
//  Created by Maxim Volgin on 05/04/2021.
//

import os.log
import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public class MPSGLossCCE: MPSGLoss {
    let graph: MPSGraph
    let batchSize: MPSGraphTensor
    
    public init(graph: MPSGraph, batchSize: Double = Double(Hyper.batchSize)) {
        self.batchSize = graph.constant(batchSize, shape: [1], dataType: .float32)
        self.graph = graph
    }
    
    public func callAsFunction(_ output: MPSGraphTensor, _ labels: MPSGraphTensor) -> MPSGraphTensor {
        let loss = graph.softMaxCrossEntropy(output,
                                             labels: labels,
                                             axis: -1,
                                             reuctionType: .sum,
                                             name: name("_softMaxCrossEntropy_sum_-1"))
        let mean = graph.division(loss, batchSize, name: name("_division"))
        return mean
    }

    func name(_ suffix: String) -> String {
        String(describing: name) + suffix
    }
}
