//
//  MPSGLayerLinear.swift
//  
//
//  Created by Maxim Volgin on 03/04/2021.
//

import os.log
import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public class MPSGLayerLinear: MPSGLayer {
    public let graph: MPSGraph
    public private(set) var variableData: [MPSGModel.VariableData] = []
    var weightVariableData: MPSGModel.VariableData!
    var biasVariableData: MPSGModel.VariableData!
    let units: Int
    let name: String?
    
    public init(graph: MPSGraph,
                weightsShape: Shape,
                name: String? = nil
    ) {
        self.graph = graph
        self.weightVariableData = Self.add(layerVariable: .weight(layerShape: weightsShape, layerName: name), to: graph)
        self.biasVariableData = Self.add(layerVariable: .bias(layerShape: weightsShape, layerName: name), to: graph)
        self.variableData = [weightVariableData, biasVariableData]
        self.units = weightsShape.biasCount
        self.name = name
    }
    
    public init(graph: MPSGraph,
                units: Int,
                name: String? = nil
    ) {
        self.graph = graph
        self.units = units
        self.name = name
    }
        
    public func callAsFunction(_ inputTensor: MPSGraphTensor) throws -> MPSGraphTensor {
        
        if variableData.count == 0 {
            guard let inputLastDimensionSize = inputTensor.shape?.last?.intValue else {
                throw MPSGError.wrongShape(inputTensor)
            }
            let weightsShape: Shape = .IO(inputLastDimensionSize, units)
            self.weightVariableData = Self.add(layerVariable: .weight(layerShape: weightsShape, layerName: name), to: graph)
            self.biasVariableData = Self.add(layerVariable: .bias(layerShape: weightsShape, layerName: name), to: graph)
            self.variableData = [weightVariableData, biasVariableData]
        }
        
        let weightTensor = graph.matrixMultiplication(primary: inputTensor,
                                                  secondary: weightVariableData.tensor,
                                                  name: name)
        let biasTensor = graph.addition(weightTensor,
                                          biasVariableData.tensor,
                                          name: nil)
        return biasTensor
    }
    
}
