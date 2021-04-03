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
    
    static func data(layerVariable: LayerVariable) -> [Float32] {
        let (count, _, _) = layerVariable.countShapeName
        switch layerVariable {
        case .weight(_, _):
            return MPSGData.generate(parameterCount: count, minimum: -0.2, maximum: 0.2)
        case .bias(_, _):
            return MPSGData.generate(parameterCount: count, minimum: 0.1, maximum: 0.1)
        }
    }
    
    static func add(layerVariable: LayerVariable, to graph: MPSGraph) -> VariableData {
        let (_, shape, name) = layerVariable.countShapeName
        let data = self.data(layerVariable: layerVariable)
        let tensor = graph.variable(with: MPSGData.data(for: data),
                                    shape: shape.toArrayNSNumber,
                                    dataType: .float32,
                                    name: name)
        return (tensor: tensor, data: data, name: name)
    }
    
    func addConvLayer(graph: MPSGraph,
                             sourceTensor: MPSGraphTensor,
                             weightsShape: Shape,
                             desc: MPSGraphConvolution2DOpDescriptor,
                             variableTensors: inout [VariableData],
                             name: String? = nil) -> MPSGraphTensor {
        
        let weightVariableData = Self.add(layerVariable: .weight(layerShape: weightsShape, layerName: name), to: graph)
        let biasVariableData = Self.add(layerVariable: .bias(layerShape: weightsShape, layerName: name), to: graph)
                
        let convTensor = graph.convolution2D(sourceTensor,
                                             weights: weightVariableData.tensor,
                                             descriptor: desc,
                                             name: name)
        
        let convBiasTensor = graph.addition(convTensor,
                                            biasVariableData.tensor,
                                            name: nil)
        
        let convActivationTensor = graph.reLU(with: convBiasTensor,
                                              name: nil)
        
//        variableTensors += [convWeights, convBiases]
        variableTensors += [weightVariableData, biasVariableData]

        return convActivationTensor
    }
    
    func addFullyConnectedLayer(graph: MPSGraph,
                                       sourceTensor: MPSGraphTensor,
                                       weightsShape: Shape,
                                       hasActivation: Bool,
                                       variableTensors: inout [VariableData],
                                       name: String? = nil) -> MPSGraphTensor {
        
        let weightVariableData = Self.add(layerVariable: .weight(layerShape: weightsShape, layerName: name), to: graph)
        let biasVariableData = Self.add(layerVariable: .bias(layerShape: weightsShape, layerName: name), to: graph)
                
        let fcTensor = graph.matrixMultiplication(primary: sourceTensor,
                                                  secondary: weightVariableData.tensor,
                                                  name: name)
        
        let fcBiasTensor = graph.addition(fcTensor,
                                          biasVariableData.tensor,
                                          name: nil)
        
//        variableTensors += [fcWeights, fcBiases]
        variableTensors += [weightVariableData, biasVariableData]
        
        if !hasActivation {
            return fcBiasTensor
        }
        
        let fcActivationTensor = graph.reLU(with: fcBiasTensor,
                                            name: nil)

        return fcActivationTensor
    }
    
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

