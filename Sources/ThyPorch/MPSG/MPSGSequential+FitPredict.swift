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
    
//    var gDevice: MTLDevice = MTLCreateSystemDefaultDevice()!
//    var gCommandQueue: MTLCommandQueue = gDevice.makeCommandQueue()!
    
    // MARK: - training
    
    // Encode training batch to command buffer using double buffering
    func batchFit(
                 _ sourceTensorData: MPSGraphTensorData,
                 _ labelsTensorData: MPSGraphTensorData,
                 completion: ((Float) -> Void)?) -> MPSGraphTensorData {
        doubleBufferingSemaphore.wait()

        let executionDesc = MPSGraphExecutionDescriptor()
        
        executionDesc.completionHandler = { (resultsDictionary, nil) in
            var loss: Float = 0
            
            self.update(resultsDictionary)
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

        let feed = [sourcePlaceholder: sourceTensorData,
                    labelsPlaceholder: labelsTensorData]
        
        // pass variables only the last time?..
        let fetch = graph.runAsync(
                                 feeds: feed,
                                 targetTensors: trainingTarget.tensors,
                                 targetOperations: trainingTarget.operations,
                                 executionDescriptor: executionDesc)

        return fetch[trainingTarget.tensors[0]]!
    }
    
    // Encode training batch to command buffer using double buffering
    func batchFitEncode(commandBuffer: MTLCommandBuffer,
                             _ sourceTensorData: MPSGraphTensorData,
                             _ labelsTensorData: MPSGraphTensorData,
                             completion: ((Float) -> Void)?) -> MPSGraphTensorData {
        doubleBufferingSemaphore.wait()

        let executionDesc = MPSGraphExecutionDescriptor()
        
        executionDesc.completionHandler = { (resultsDictionary, nil) in
            var loss: Float = 0
            
            self.update(resultsDictionary)
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

        let feed = [sourcePlaceholder: sourceTensorData,
                    labelsPlaceholder: labelsTensorData]
        
        // pass variables only the last time?..
        let fetch = graph.encode(to: MPSCommandBuffer(commandBuffer: commandBuffer),
                                 feeds: feed,
                                 targetTensors: trainingTarget.tensors,
                                 targetOperations: trainingTarget.operations,
                                 executionDescriptor: executionDesc)

        return fetch[trainingTarget.tensors[0]]!
    }
    
    // MARK: - inference
    
    // Encode inference batch to command buffer using double buffering
    func batchPredict(_ sourceTensorData: MPSGraphTensorData, _ labelsTensorData: MPSGraphTensorData) -> MPSGraphTensorData {
        let batchSize = labelsTensorData.shape.first!.intValue
        let labelSize = labelsTensorData.shape.last!.intValue
        
        doubleBufferingSemaphore.wait()

        let executionDesc = MPSGraphExecutionDescriptor()
        let yLabels = labelsTensorData.mpsndarray()

        executionDesc.completionHandler = { (resultsDictionary, nil) in
            let outputTensorData: MPSGraphTensorData = resultsDictionary[self.inferenceTarget.tensors[0]]!

            var values = [Float](repeating: 0, count: batchSize * labelSize)
            var labels = [Float](repeating: 0, count: batchSize * labelSize)

            outputTensorData.mpsndarray().readBytes(&values, strideBytes: nil)
            yLabels.readBytes(&labels, strideBytes: nil)

            var ind = 0
            for _ in 0..<Hyper.batchSize {
                var maxIndex = 0
                var maxValue: Float = 0
                var correctIndex = 0
                for classIdx in 0..<labelSize {
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
        
        let fetch = graph.runAsync(
                                  feeds: [sourcePlaceholder: sourceTensorData,
                                          labelsPlaceholder: labelsTensorData],
                                  targetTensors: inferenceTarget.tensors,
                                  targetOperations: inferenceTarget.operations,
                                  executionDescriptor: executionDesc)
        
        return fetch[inferenceTarget.tensors[0]]!
    }
    
    // Encode inference batch to command buffer using double buffering
    func batchPredictEncode(commandBuffer: MTLCommandBuffer, _ sourceTensorData: MPSGraphTensorData, _ labelsTensorData: MPSGraphTensorData) -> MPSGraphTensorData {
        let batchSize = labelsTensorData.shape.first!.intValue
        let labelSize = labelsTensorData.shape.last!.intValue

        doubleBufferingSemaphore.wait()

        let executionDesc = MPSGraphExecutionDescriptor()
        let yLabels = labelsTensorData.mpsndarray()

        executionDesc.completionHandler = { (resultsDictionary, nil) in
            let outputTensorData: MPSGraphTensorData = resultsDictionary[self.inferenceTarget.tensors[0]]!

            var values = [Float](repeating: 0, count: batchSize * labelSize)
            var labels = [Float](repeating: 0, count: batchSize * labelSize)

            outputTensorData.mpsndarray().readBytes(&values, strideBytes: nil)
            yLabels.readBytes(&labels, strideBytes: nil)

            var ind = 0
            for _ in 0..<Hyper.batchSize {
                var maxIndex = 0
                var maxValue: Float = 0
                var correctIndex = 0
                for classIdx in 0..<labelSize {
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
                                  feeds: [sourcePlaceholder: sourceTensorData,
                                          labelsPlaceholder: labelsTensorData],
                                  targetTensors: inferenceTarget.tensors,
                                  targetOperations: inferenceTarget.operations,
                                  executionDescriptor: executionDesc)
        
        return fetch[inferenceTarget.tensors[0]]!
    }
    
    // Run single inference case, call is blocking
    func predict(_ sourceData: MPSGraphTensorData) -> MPSGraphTensorData {
        let fetch = self.graph.run(feeds: [sourcePlaceholder: sourceData],
                                   targetTensors: self.inferenceTarget.tensors,
                                   targetOperations: self.inferenceTarget.operations)
        return fetch[inferenceTarget.tensors[0]]!
    }
   
    // Run single inference case, call is blocking
    func predictEncode(commandQueue: MTLCommandQueue, _ sourceData: MPSGraphTensorData) -> MPSGraphTensorData {
        let fetch = self.graph.run(with: commandQueue,
                                   feeds: [sourcePlaceholder: sourceData],
                                   targetTensors: self.inferenceTarget.tensors,
                                   targetOperations: self.inferenceTarget.operations)
        return fetch[inferenceTarget.tensors[0]]!
    }
    
}
