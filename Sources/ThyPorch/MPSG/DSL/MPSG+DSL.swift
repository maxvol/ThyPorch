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
        
        
         let input_shape = 10
         let output_shape = 10
         
         let model = MPSGSequential(graph: graph,
                                    inShape: .IO(16, input_shape),
                                    outShape: .IO(16, output_shape),
                                    //            MPSGLayerAny(graph: graph, debug),
                                                MPSGLayerLinear(graph: graph, weightsShape: .IO(input_shape, 128), name: "linear0"),
                                    //            MPSGLayerAny(graph: graph, debug),
                                                MPSGLayerAny(graph: graph) { (graph, inputTensor) in graph.reLU(with: inputTensor, name: "reLU_linear0") },
                                    //            MPSGLayerAny(graph: graph, debug),
                                                MPSGLayerAny(graph: graph) { (graph, inputTensor) in graph.dropout(inputTensor, rate: 0.5, name: "do0") },
                                    //            MPSGLayerAny(graph: graph, debug),
                                                MPSGLayerLinear(graph: graph, units: 64, name: "linear1"),
                                    //            MPSGLayerAny(graph: graph, debug),
                                                MPSGLayerAny(graph: graph) { (graph, inputTensor) in graph.reLU(with: inputTensor, name: "reLU_linear1") },
                                    //            MPSGLayerAny(graph: graph, debug),
                                                MPSGLayerAny(graph: graph) { (graph, inputTensor) in graph.dropout(inputTensor, rate: 0.5, name: "do1") },
                                    //            MPSGLayerAny(graph: graph, debug),
                                                MPSGLayerLinear(graph: graph, units: output_shape, name: "linear2")//,
                                    //            MPSGLayerAny(graph: graph, debug) //,
                                    //            MPSGLayerAny(graph: graph) { (graph, inputTensor) in graph.softMax(with: inputTensor, axis: -1, name: "softmax_linear2") },
                                    //            MPSGLayerAny(graph: graph, debug)
         )
         let lossObject = MPSGLossCCE(graph: graph)
         let sgd = MPSGOptimizerSGD(graph: graph)
         model.compile(lossObject: lossObject, optimizer: sgd)
         
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
