//
//  MPSGLayerBuilder.swift
//  
//
//  Created by Maxim Volgin on 22/06/2021.
//

import MetalPerformanceShadersGraph

@resultBuilder
struct MPSGLayerBuilder {
    
//    static func buildBlock(_ components: [MPSGLayer]...) -> [MPSGLayer] {
//        components.flatMap { $0 }
//    }
    
//    static func buildExpression(_ expression: MPSGLayer) -> [MPSGLayer] {
//        [expression]
//    }

    @available(*, unavailable, message: "missing`` field")
    static func buildBlock(_ components: [MPSGLayer]...) -> [MPSGLayer] {
        fatalError()
    }
    
}

@resultBuilder
struct MPSGLayerLinearBuilder {
    static func buildBlock(_ graph: MPSGraph,
                           _ name: String? = nil) -> (MPSGraph, String?) {
        (graph, name)
    }
    static func buildBlock(_ weightsShape: Shape) -> Shape {
        weightsShape
    }
    static func buildBlock(_ graph: MPSGraph,
                           _ weightsShape: Shape,
                           _ name: String? = nil) -> (MPSGraph, Shape, String?) {
        (graph, weightsShape, name)
    }
    static func buildBlock(_ graph: MPSGraph,
                           _ units: Int,
                           _ name: String? = nil) -> (MPSGraph, Int, String?) {
        (graph, units, name)
    }
}

extension MPSGLayerLinear {
    convenience init(weightsShape: Shape, @MPSGLayerLinearBuilder builder: () -> (MPSGraph, String?)) {
        let (graph, name) = builder()
        self.init(graph: graph, weightsShape: weightsShape, name: name)
    }
    convenience init(_ graph: MPSGraph, _ name: String? = nil, @MPSGLayerLinearBuilder builder: () -> Shape) {
        let weightsShape = builder()
        self.init(graph: graph, weightsShape: weightsShape, name: name)
    }
    convenience init(@MPSGLayerLinearBuilder builder: () -> (MPSGraph, Shape, String?)) {
        let (graph, weightsShape, name) = builder()
        self.init(graph: graph, weightsShape: weightsShape, name: name)
    }
    convenience init(@MPSGLayerLinearBuilder builder: () -> (MPSGraph, Int, String?)) {
        let (graph, units, name) = builder()
        self.init(graph: graph, units: units, name: name)
    }
}
