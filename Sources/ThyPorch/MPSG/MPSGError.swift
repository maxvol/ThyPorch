//
//  File.swift
//  
//
//  Created by Maxim Volgin on 04/04/2021.
//

import os.log
import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public enum MPSGError: Error {
    case wrongShape(MPSGraphTensor)
}
