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
    
    typealias VariableData = (tensor: MPSGraphTensor, data: [Float32], name: String?)
    typealias TensorBuilder = (MPSGraph, MPSGraphTensor) -> MPSGraphTensor
    typealias Target = (tensors: [MPSGraphTensor], operations: [MPSGraphOperation])
    typealias TargetTuple = (inference: Target, training: Target)
    
    var variableData: [VariableData] { get }
    
    func debug(_ graph: MPSGraph, _ inputTensor: MPSGraphTensor) -> MPSGraphTensor
    
    func sequence(graph: MPSGraph, inputTensor: MPSGraphTensor, variableData: inout [VariableData], _ layers: MPSGLayer...) -> MPSGraphTensor
    
    func build(graph: MPSGraph, inputTensor: MPSGraphTensor, labelTensor: MPSGraphTensor) -> TargetTuple
    
    func save(variableData: [VariableData])

}

@available(macOS 11, iOS 14, *)
public extension MPSGModel {
    
    func debug(_ graph: MPSGraph, _ inputTensor: MPSGraphTensor) -> MPSGraphTensor {
        os_log("shape: %@", log: Log.metalPerformanceShadersGraph, type: .debug, String(describing: inputTensor.shape))
        return inputTensor
    }
    
    func sequence(graph: MPSGraph, inputTensor: MPSGraphTensor, variableData: inout [VariableData], _ layers: MPSGLayer...) -> MPSGraphTensor {
        let result = layers.reduce(inputTensor) { tensor, layer in
            try! layer(tensor)
        }
        for layer in layers {
            os_log("layer: %@\tshape: %@\tparams: %@",
                   log: Log.metalPerformanceShadersGraph,
                   type: .debug,
                   "", // layer.name,
                   "", // String(describing: layer.shape),
                   layer.variableData.reduce(0) { count, variableData in count + variableData.data.count }
                   )
            variableData += layer.variableData
        }
        os_log("total params: %@",
               log: Log.metalPerformanceShadersGraph,
               type: .debug,
               self.variableData.reduce(0) { count, variableData in count + variableData.data.count }
               )
        return result
    }
    
    func save(variableData: [VariableData]) {
        let url = getDocumentsDirectory()
        for variable in variableData {
            guard let name = variable.name else {
                continue
            }
            try? MPSGData.data(for: variable.data).write(to: url.appendingPathComponent(name), options: .atomicWrite)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}

