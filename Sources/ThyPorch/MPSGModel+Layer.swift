//
//  MPSGModel+Layer.swift
//  
//
//  Created by Maxim Volgin on 03/04/2021.
//

import os.log
import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public extension MPSGModel {
        
    // pool2d(x, pool_size, strides=(1, 1), padding='valid', data_format=None, pool_mode='max'
//    static func pool2d(_ graph: MPSGraph, _ input: MPSGraphTensor) -> MPSGraphTensor {
//        graph.maxPooling2D(withSourceTensor: input, descriptor: pooling2DOpDescriptor, name: "pool_0")
//        // [16, 14, 14, 32]
//    }
    
    // TODO: only for trainable layers
    func getAssignOperations(graph: MPSGraph, lossTensor: MPSGraphTensor, variableTensors: [MPSGraphTensor]) -> [MPSGraphOperation] {
        let gradTensors = graph.gradients(of: lossTensor, with: variableTensors, name: nil)
     
        let lambdaTensor = graph.constant(Hyper.lambda, shape: [1], dataType: .float32)

        var updateOps: [MPSGraphOperation] = []
        for (key, value) in gradTensors {
            let updateTensor = graph.stochasticGradientDescent(learningRate: lambdaTensor,
                                                               values: key,
                                                               gradient: value,
                                                               name: nil)
            
            let assign = graph.assign(key, tensor: updateTensor, name: nil)
            
            updateOps += [assign]
        }
        
        return updateOps
    }
    
    //        os_log("shape: %@", log: Log.metalPerformanceShadersGraph, type: .debug, String(describing: inputTensor.shape))
    
}

