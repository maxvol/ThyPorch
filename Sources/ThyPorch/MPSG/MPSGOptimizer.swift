//
//  MPSGOptimizer.swift
//  
//
//  Created by Maxim Volgin on 05/04/2021.
//

import os.log
import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public protocol MPSGOptimizer {
    func callAsFunction(loss: MPSGraphTensor, variable: MPSGraphTensor...) -> [MPSGraphOperation] 
}
