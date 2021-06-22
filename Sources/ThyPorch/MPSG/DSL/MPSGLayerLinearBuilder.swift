//
//  MPSGLayerLinearBuilder.swift
//  
//
//  Created by Maxim Volgin on 22/06/2021.
//

import MetalPerformanceShadersGraph

@resultBuilder
public struct MPSGLayerLinearBuilder {
    public static func buildBlock(_ graph: MPSGraph,
                           _ name: String? = nil) -> (MPSGraph, String?) {
        (graph, name)
    }
    public static func buildBlock(_ weightsShape: Shape) -> Shape {
        weightsShape
    }
    public static func buildBlock(_ graph: MPSGraph,
                           _ weightsShape: Shape,
                           _ name: String? = nil) -> (MPSGraph, Shape, String?) {
        (graph, weightsShape, name)
    }
    public static func buildBlock(_ graph: MPSGraph,
                           _ units: Int,
                           _ name: String? = nil) -> (MPSGraph, Int, String?) {
        (graph, units, name)
    }
}

public extension MPSGLayerLinear {
    convenience init(units: Int, @MPSGLayerLinearBuilder builder: () -> (MPSGraph, String?)) {
        let (graph, name) = builder()
        self.init(graph: graph, units: units, name: name)
    }
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
}
