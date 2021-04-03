//
//  MPSGLayerConv2D.swift
//  
//
//  Created by Maxim Volgin on 03/04/2021.
//

import os.log
import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public struct MPSGLayerConv2D: MPSGLayer {
    public let graph: MPSGraph
    public private(set) var variableData: [MPSGModel.VariableData]
    let weightVariableData: MPSGModel.VariableData
    let biasVariableData: MPSGModel.VariableData
    let desc: MPSGraphConvolution2DOpDescriptor
    let name: String?
    
    public init(graph: MPSGraph,
                weightsShape: Shape,
                desc: MPSGraphConvolution2DOpDescriptor,
                name: String? = nil
    ) {
        self.graph = graph
        self.weightVariableData = Self.add(layerVariable: .weight(layerShape: weightsShape, layerName: name), to: graph)
        self.biasVariableData = Self.add(layerVariable: .bias(layerShape: weightsShape, layerName: name), to: graph)
        self.variableData = [weightVariableData, biasVariableData]
        self.desc = desc
        self.name = name
    }
        
    public func callAsFunction(_ inputTensor: MPSGraphTensor) -> MPSGraphTensor {
        let convTensor = graph.convolution2D(inputTensor,
                                             weights: weightVariableData.tensor,
                                             descriptor: desc,
                                             name: name)
        let convBiasTensor = graph.addition(convTensor,
                                            biasVariableData.tensor,
                                            name: nil)
        return convBiasTensor
    }
    
}


