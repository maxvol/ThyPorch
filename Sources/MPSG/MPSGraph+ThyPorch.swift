//
//  MPSGraph+ThyPorch.swift
//  
//
//  Created by Maxim Volgin on 30/09/2020.
//

import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

public typealias TensorBuilder = (MPSGraph, MPSGraphTensor) -> MPSGraphTensor

public extension MPSGraph {

    func sequence(input: MPSGraphTensor, _ builders: TensorBuilder...) -> MPSGraphTensor {
        builders.reduce(input) { tensor, builder in
            builder(self, tensor)
        }
    }

}
