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
class MPSGSequential { // : MPSGModel {
    public private(set) var layers: [MPSGLayer] = []
    public var variableData: [MPSGModel.VariableData] {
        get {
            layers.reduce(into: [MPSGModel.VariableData]()) { variableData, layer in
                variableData.append(contentsOf: layer.variableData)
            }
        }
    }
    
    public func summary() -> String {
        ""
    }
    
    public func compile() {}
    
    public func fit() {}
    
    init(_ layers: MPSGLayer...) {
        self.layers = layers
    }
    
    public func add(_ layer: MPSGLayer) {
        self.layers.append(layer)
    }
    
//    func build(graph: MPSGraph, inputTensor: MPSGraphTensor, labelTensor: MPSGraphTensor) -> MPSGModel.TargetTuple {
//
//    }
    
    static func test() {
        let graph = MPSGraph()
        
        let model = MPSGSequential(
            MPSGLayerLinear(graph: graph, units: 8, name: "lin0")
        )
        
    }
    
}



