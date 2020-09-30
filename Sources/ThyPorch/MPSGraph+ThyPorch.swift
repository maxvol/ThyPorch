//
//  MPSGraph+ThyPorch.swift
//  
//
//  Created by Maxim Volgin on 30/09/2020.
//

import Foundation

#if os(iOS)

import MetalPerformanceShaders
import MetalPerformanceShadersGraph

public typealias TensorBuilder = (MPSGraph, MPSGraphTensor) -> MPSGraphTensor

public extension MPSGraph {

    public func sequence(input: MPSGraphTensor, _ builders: TensorBuilder...) -> MPSGraphTensor {
        builders.reduce(input) { tensor, builder in
            builder(self, tensor)
        }
    }

}

#endif
