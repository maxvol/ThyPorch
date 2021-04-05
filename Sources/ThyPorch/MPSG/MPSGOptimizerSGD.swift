//
//  MPSGOptimizer.swift
//
//
//  Created by Maxim Volgin on 05/04/2021.
//

import os.log
import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public class MPSGOptimizerSGD: MPSGOptimizer {
    let name: String?
    let graph: MPSGraph
    let learningRate: MPSGraphTensor
    
    public init(graph: MPSGraph, learningRate: Double = Hyper.lambda, name: String? = nil) {
        self.learningRate = graph.constant(learningRate, shape: [1], dataType: .float32)
        self.graph = graph
        self.name = name
    }
    
    public func callAsFunction(loss: MPSGraphTensor, variable: MPSGraphTensor...) -> [MPSGraphOperation] {
        let gradients = graph.gradients(of: loss, with: variable, name: name("_gradients"))
        var updateOps: [MPSGraphOperation] = []
        for (value, gradient) in gradients {
            let newValue = graph.stochasticGradientDescent(learningRate: learningRate,
                                                               values: value,
                                                               gradient: gradient,
                                                               name: name("_stochasticGradientDescent"))
            
            let assign = graph.assign(value, tensor: newValue, name: name("_assign"))
            updateOps += [assign]
        }
        return updateOps
    }
    
    func name(_ suffix: String) -> String {
        String(describing: name) + suffix
    }

}
