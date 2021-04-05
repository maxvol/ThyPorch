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
    
    let output: MPSGraphTensor
    
    var sourcePlaceholder: MPSGraphTensor
    var labelsPlaceholder: MPSGraphTensor
    
    var trainingTarget: MPSGModel.Target = (tensors: [], operations: [])
    var inferenceTarget: MPSGModel.Target = (tensors: [], operations: [])
    
    let doubleBufferingSemaphore = DispatchSemaphore(value: 2)
    
    public init(graph: MPSGraph, inShape: Shape, outShape: Shape, _ layers: MPSGLayer...) {
        self.graph = graph
        self.layers = layers
        let inputTensor =  graph.placeholder(shape: inShape.toArrayNSNumber, name: nil)
        self.sourcePlaceholder = inputTensor
        self.labelsPlaceholder = graph.placeholder(shape: outShape.toArrayNSNumber, name: nil)
//        self.sourcePlaceholder = graph.placeholder(shape: [Hyper.batchSize as NSNumber, MNISTSize * MNISTSize as NSNumber], name: nil)
//        self.labelsPlaceholder = graph.placeholder(shape: [Hyper.batchSize as NSNumber, MNISTNumClasses as NSNumber], name: nil)
        self.output = layers.reduce(inputTensor) { tensor, layer in
            try! layer(tensor)
        }
        let totalParameterCount = variableData.reduce(0) { r, e in r + e.data.count }
        print("totalParameterCount: \(totalParameterCount)")
        print(graph.debugDescription)
    }
    
    public func add(_ layer: MPSGLayer) {
        self.layers.append(layer)
    }
    
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
    
    public func summary() {
        os_log("total params: %d",
               log: Log.metalPerformanceShadersGraph,
               type: .debug,
               self.variableData.reduce(0) { count, variableData in count + variableData.data.count }
               )
    }
    
    public func save(variableData: [MPSGModel.VariableData]) {
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
        
    static func test() {
        let graph = MPSGraph()
        let model = MPSGSequential(graph: graph,
                                   inShape: .IO(16, 28*28),
                                   outShape: .IO(16, 10),
            MPSGLayerLinear(graph: graph, units: 8, name: "lin0")
        )
        let lossObject = MPSGLossCCE(graph: graph)
        let sgd = MPSGOptimizerSGD(graph: graph)
        model.compile(lossObject: lossObject, optimizer: sgd)
    }
    
}



