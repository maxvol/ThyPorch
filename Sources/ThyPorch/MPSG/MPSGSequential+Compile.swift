//
//  MPSGSequential+Compile.swift
//  
//
//  Created by Maxim Volgin on 05/04/2021.
//

import os.log
import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public extension MPSGSequential {
    
    // TODO: metrics
    /**
     Compile defines the loss function, the optimizer and the metrics.
     */
    func compile(lossObject: MPSGLoss, optimizer: MPSGOptimizer, softmax: Bool = true) {
        // inference
        if softmax {
            let softMax = graph.softMax(with: output, axis: -1, name: nil)
            self.inferenceTarget = (tensors: [softMax], operations: [])
        } else {
            self.inferenceTarget = (tensors: [output], operations: [])
        }
        // training
        let loss = lossObject(output, labelsPlaceholder)
        let variables = variableData.map { $0.0 }
        let operations = optimizer(loss, variables)
        self.trainingTarget = (tensors: [loss] + variables, operations: operations)
    }
    
}
