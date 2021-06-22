//
//  MPSGLayerBuilder.swift
//  
//
//  Created by Maxim Volgin on 22/06/2021.
//

import MetalPerformanceShadersGraph

@resultBuilder
public struct MPSGLayerAnyBuilder {
    
//    static func buildBlock(_ graph: MPSGraph, _ name: String?, _ builders: [MPSGModel.TensorBuilder]) -> (MPSGraph, String?, [MPSGModel.TensorBuilder]) {
//        (graph, name, builders)
//    }
    
//    public static func buildBlock(_ layers: [MPSGLayer]...) -> [MPSGLayer] {
//        layers.flatMap { $0 }
//    }

    static func buildBlock(_ graph: MPSGraph, _ builders: MPSGModel.TensorBuilder...) -> (MPSGraph, [MPSGModel.TensorBuilder]) {
        (graph, builders)
    }

//    static func buildExpression(_ expression: @escaping MPSGModel.TensorBuilder) -> [MPSGModel.TensorBuilder] {
//        [expression]
//    }

//    @available(*, unavailable, message: "missing`` field")
//    public static func buildBlock(_ components: [MPSGLayer]...) -> [MPSGLayer] {
//        fatalError()
//    }
    
}

public extension MPSGLayerAny {
//    convenience init(@MPSGLayerAnyBuilder builder: () -> (MPSGraph, String?, MPSGModel.TensorBuilder)) {
//        let (graph, name, builders) = builder()
//        self.init(graph: graph, builders)
//    }
    convenience init(@MPSGLayerAnyBuilder builder: () -> (MPSGraph, [MPSGModel.TensorBuilder])) {
        let (graph, builders) = builder()
        self.init(graph: graph, builders)
    }
}
