//
//  MPSGSequential+FitPredict.swift
//  
//
//  Created by Maxim Volgin on 05/04/2021.
//

import Foundation

import os.log
import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public extension MPSGSequential {
    
    var sourcePlaceholderTensor: MPSGraphTensor
    var labelsPlaceholderTensor: MPSGraphTensor
    
    var trainingTarget: MPSGModel.Target = (tensors: [], operations: [])
    var inferenceTarget: MPSGModel.Target = (tensors: [], operations: [])
    
    let doubleBufferingSemaphore = DispatchSemaphore(value: 2)
    
//    override init () {
//
//        sourcePlaceholderTensor = graph.placeholder(shape: [Hyper.batchSize as NSNumber, MNISTSize * MNISTSize as NSNumber], name: nil) // 16, 28*28
//        labelsPlaceholderTensor = graph.placeholder(shape: [Hyper.batchSize as NSNumber, MNISTNumClasses as NSNumber], name: nil)       // 16, 10
//
//        (inferenceTarget, trainingTarget) = model.build(graph: graph, inputTensor: sourcePlaceholderTensor, labelTensor: labelsPlaceholderTensor)
//        print(graph.debugDescription)
//
//        super.init()
//    }

    // Encode training batch to command buffer using double buffering
    func encodeTrainingBatch(commandBuffer: MTLCommandBuffer,
                             sourceTensorData: MPSGraphTensorData,
                             labelsTensorData: MPSGraphTensorData,
                             completion: ((Float) -> Void)?) -> MPSGraphTensorData {
        doubleBufferingSemaphore.wait()

        let executionDesc = MPSGraphExecutionDescriptor()
        
        executionDesc.completionHandler = { (resultsDictionary, nil) in
            var loss: Float = 0
            
            self.model.update(resultsDictionary)
            let lossTensorData: MPSGraphTensorData = resultsDictionary[self.trainingTarget.tensors[0]]!
            
            lossTensorData.mpsndarray().readBytes(&loss, strideBytes: nil)
            
            self.doubleBufferingSemaphore.signal()
            
            // Run completion function if provided
            if let completion = completion {
                DispatchQueue.main.async(execute: {
                    completion(loss)
                })
            }
        }

        let feed = [sourcePlaceholderTensor: sourceTensorData,
                    labelsPlaceholderTensor: labelsTensorData]
        
        // pass variables only the last time?..
        let fetch = graph.encode(to: MPSCommandBuffer(commandBuffer: commandBuffer),
                                 feeds: feed,
                                 targetTensors: trainingTarget.tensors,
                                 targetOperations: trainingTarget.operations,
                                 executionDescriptor: executionDesc)

        return fetch[trainingTarget.tensors[0]]!
    }

    // Encode inference batch to command buffer using double buffering
    func encodeInferenceBatch(commandBuffer: MTLCommandBuffer,
                              sourceTensorData: MPSGraphTensorData,
                              labelsTensorData: MPSGraphTensorData) -> MPSGraphTensorData {
        doubleBufferingSemaphore.wait()

        let executionDesc = MPSGraphExecutionDescriptor()
        let yLabels = labelsTensorData.mpsndarray()

        executionDesc.completionHandler = { (resultsDictionary, nil) in
            let outputTensorData: MPSGraphTensorData = resultsDictionary[self.inferenceTarget.tensors[0]]!

            var values = [Float](repeating: 0, count: Int(Hyper.batchSize) * MNISTNumClasses)
            var labels = [Float](repeating: 0, count: Int(Hyper.batchSize) * MNISTNumClasses)

            outputTensorData.mpsndarray().readBytes(&values, strideBytes: nil)
            yLabels.readBytes(&labels, strideBytes: nil)

            var ind = 0
            for _ in 0..<Hyper.batchSize {
                var maxIndex = 0
                var maxValue: Float = 0
                var correctIndex = 0
                for classIdx in 0..<MNISTNumClasses {
                    if labels[ind] == 1.0 {
                        correctIndex = classIdx
                    }
                    if maxValue < values[ind] {
                        maxIndex = classIdx
                        maxValue = values[ind]
                    }
                    ind += 1
                }
                if maxIndex == correctIndex {
//                    gCorrect += 1
                }
            }
            self.doubleBufferingSemaphore.signal()
        }
        
        let fetch = graph.encode(to: MPSCommandBuffer(commandBuffer: commandBuffer),
                                  feeds: [sourcePlaceholderTensor: sourceTensorData,
                                          labelsPlaceholderTensor: labelsTensorData],
                                  targetTensors: inferenceTarget.tensors,
                                  targetOperations: inferenceTarget.operations,
                                  executionDescriptor: executionDesc)
        
        return fetch[inferenceTarget.tensors[0]]!
    }
    
    // Run single inference case, call is blocking
    func encodeInferenceCase(sourceTensorData: MPSGraphTensorData) -> MPSGraphTensorData {
        let fetch = graph.run(with: gCommandQueue,
                              feeds: [sourcePlaceholderTensor: sourceTensorData],
                              targetTensors: inferenceTarget.tensors,
                              targetOperations: inferenceTarget.operations)

        return fetch[inferenceTarget.tensors[0]]!
    }
    
}
