//
//  MPSG+DSL.swift
//  
//
//  Created by Maxim Volgin on 20/06/2021.
//

import MetalPerformanceShadersGraph

struct SequentialModel {
    let content: [MPSGLayer]
//    let output: MPSGraphTensor
    
    init(@MPSGSequentialBuilder content: () -> [MPSGLayer]) {
        self.content = content()
//        self.output = content()
//        self.output = layers.reduce(inputTensor) { tensor, layer in
//            try! layer(tensor)
//        }
    }
}

class Test1 {
    func callAsFunction() {
        let graph = MPSGraph()
//        var t: MPSGraphTensor!
        let m = SequentialModel {
            MPSGLayerLinear(graph: graph, weightsShape: .IO(10, 128), name: "linear0")
            MPSGLayerLinear(weightsShape: .IO(10, 128)) {
                graph
                "linear0"
            }
//            MPSGLayerLinear {
//                graph
//                .IO(10, 128)
//                "linear0"
//            }
            MPSGLayerAny(graph: graph) { (graph, inputTensor) in graph.reLU(with: inputTensor, name: "reLU_linear0") }
            MPSGLayerAny(graph: graph) { (graph, inputTensor) in graph.dropout(inputTensor, rate: 0.5, name: "do0") }
            MPSGLayerLinear {
                graph
                64
                "linear1"
            }
        }
    }
}

/*
class Smoothie {}

@resultBuilder
enum SmoothieArrayBuilder {
    static func buildEither(first component: [Smoothie]) -> [Smoothie] {
        component
    }
    static func buildEither(second component: [Smoothie]) -> [Smoothie] {
        component
    }
    static func buildOptional(_ component: [Smoothie]?) -> [Smoothie] {
        component ?? []
    }
    static func buildBlock(_ components: [Smoothie]...) -> [Smoothie] {
        components.flatMap { $0 }
    }
    static func buildExpression(_ expression: Smoothie) -> [Smoothie] {
        [expression]
    }
//    static func buildArray(_ components: [[Smoothie]]) -> [Smoothie] {
//        <#code#>
//    }
//    static func buildFinalResult(_ component: [Smoothie]) -> <#Result#> {
//        <#code#>
//    }
}

extension Smoothie {
    @SmoothieArrayBuilder
    static func all(includingPaid: Bool = true) {
        
    }
}
*/
