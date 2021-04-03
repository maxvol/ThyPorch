//
//  MPSGLayerDense.swift
//  
//
//  Created by Maxim Volgin on 03/04/2021.
//

import os.log
import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public struct MPSGLayerDense: MPSGLayer {
    public let graph: MPSGraph
    public private(set) var variableData: [MPSGModel.VariableData]
    let weightVariableData: MPSGModel.VariableData
    let biasVariableData: MPSGModel.VariableData
    let hasActivation: Bool
    let name: String?
    
    public init(graph: MPSGraph,
                weightsShape: Shape,
                hasActivation: Bool,
                name: String? = nil
    ) {
        self.graph = graph
        self.weightVariableData = Self.add(layerVariable: .weight(layerShape: weightsShape, layerName: name), to: graph)
        self.biasVariableData = Self.add(layerVariable: .bias(layerShape: weightsShape, layerName: name), to: graph)
        self.variableData = [weightVariableData, biasVariableData]
        self.hasActivation = hasActivation
        self.name = name
    }
        
    public func callAsFunction(_ inputTensor: MPSGraphTensor) -> MPSGraphTensor {
        let fcTensor = graph.matrixMultiplication(primary: inputTensor,
                                                  secondary: weightVariableData.tensor,
                                                  name: name)
        let fcBiasTensor = graph.addition(fcTensor,
                                          biasVariableData.tensor,
                                          name: nil)
        if !hasActivation {
            return fcBiasTensor
        }
        let fcActivationTensor = graph.reLU(with: fcBiasTensor,
                                            name: nil)
        return fcActivationTensor
    }
    
}
