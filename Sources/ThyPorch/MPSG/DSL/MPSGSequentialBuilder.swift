//
//  MPSGSequentialBuilder.swift
//  
//
//  Created by Maxim Volgin on 22/06/2021.
//

import MetalPerformanceShadersGraph

@resultBuilder
public struct MPSGSequentialBuilder {
    
    public static func buildBlock(_ layers: [MPSGLayer]...) -> [MPSGLayer] {
        layers.flatMap { $0 }
    }

//    static func buildBlock(_ inputTensor: MPSGraphTensor, _ layers: [MPSGLayer]...) -> (MPSGraphTensor, [MPSGLayer]) {
//        (inputTensor, layers.flatMap { $0 })
//    }

    public static func buildExpression(_ expression: MPSGLayer) -> [MPSGLayer] {
        [expression]
    }

//    static func buildExpression(_ inputTensor: MPSGraphTensor, _ expression: [MPSGLayer]) -> (MPSGraphTensor, [MPSGLayer]) {
//        (inputTensor, expression)
//    }

//    static func buildFinalResult(_ inputTensor: MPSGraphTensor, _ layers: [MPSGLayer]) -> MPSGraphTensor {
//        layers.reduce(inputTensor) { tensor, layer in
//            try! layer(tensor)
//        }
//    }
//
//    @available(*, unavailable, message: "missing`` field")
//    static func buildFinalResult(_ layers: [MPSGLayer]) -> MPSGraphTensor {
//        fatalError()
//    }
}

public extension MPSGSequential {
    
    convenience init(graph: MPSGraph, inShape: Shape, outShape: Shape, @MPSGSequentialBuilder _ layers: () -> [MPSGLayer]) {
        self.init(graph: graph, inShape: inShape, outShape: outShape, layers())
    }
    
}
