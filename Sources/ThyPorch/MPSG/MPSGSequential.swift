//
//  MPSGSequential.swift
//  
//
//  Created by Maxim Volgin on 04/04/2021.
//

import os.log
import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public class MPSGSequential { // : MPSGModel {
    public let graph: MPSGraph
    public private(set) var layers: [MPSGLayer] = []
    
    public var variableData: [MPSGModel.VariableData] {
        get {
            layers.reduce(into: [MPSGModel.VariableData]()) { variableData, layer in
                variableData.append(contentsOf: layer.variableData)
            }
        }
    }
    
    var sourcePlaceholder: MPSGraphTensor
    var labelsPlaceholder: MPSGraphTensor
    
    var trainingTarget: MPSGModel.Target = (tensors: [], operations: [])
    var inferenceTarget: MPSGModel.Target = (tensors: [], operations: [])
    
    let doubleBufferingSemaphore = DispatchSemaphore(value: 2)
    
    // TODO
    public func summary() -> String {
        ""
    }

    init(graph: MPSGraph, _ layers: MPSGLayer...) {
        self.graph = graph
        self.layers = layers
        
        self.sourcePlaceholder = graph.placeholder(shape: [Hyper.batchSize as NSNumber, MNISTSize * MNISTSize as NSNumber], name: nil) // 16, 28*28
        self.labelsPlaceholder = graph.placeholder(shape: [Hyper.batchSize as NSNumber, MNISTNumClasses as NSNumber], name: nil)       // 16, 10
        print(graph.debugDescription)
    }
    
    public func add(_ layer: MPSGLayer) {
        self.layers.append(layer)
    }
    
//    func build(graph: MPSGraph, inputTensor: MPSGraphTensor, labelTensor: MPSGraphTensor) -> MPSGModel.TargetTuple {
//
//    }
    
    public func update(_ resultsDictionary: [MPSGraphTensor: MPSGraphTensorData]) {
        var totalParameterCount = 0
        for var variable in variableData {
            var parameterCount = 1
            for dimension in variable.tensor.shape! {
                parameterCount *= dimension.intValue
            }
            totalParameterCount += parameterCount
//            print("shape: \(variable.tensor.shape!), parameters: \(parameterCount)")
            
            if let tensorData = resultsDictionary[variable.tensor] {
                tensorData.mpsndarray().readBytes(&variable.data, strideBytes: nil)
            }
        }
    }
    
    static func test() {
        let graph = MPSGraph()
        let model = MPSGSequential(graph: graph,
            MPSGLayerLinear(graph: graph, units: 8, name: "lin0")
        )
        let lossObject = MPSGLossCCE(graph: graph)
        let sgd = MPSGOptimizerSGD(graph: graph)
        model.compile(lossObject: lossObject, optimizer: sgd)
    }
    
}



