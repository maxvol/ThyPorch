//
//  MPSGLoss.swift
//  
//
//  Created by Maxim Volgin on 05/04/2021.
//

import os.log
import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public protocol MPSGLoss {
    func callAsFunction(_ output: MPSGraphTensor, _ labels: MPSGraphTensor) -> MPSGraphTensor
}
