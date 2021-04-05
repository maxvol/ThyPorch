//
//  MPSGData.swift
//  
//
//  Created by Maxim Volgin on 02/10/2020.
//

import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public struct MPSGData {
    
    public static func data(for parameterArray: [Float32], dataType: MPSDataType = .float32) -> Data {
        switch dataType {
        case .float32:
            return Data(bytes: parameterArray, count: parameterArray.count * MemoryLayout<Float32>.size)
        default:
            fatalError("Not implemented for `\(dataType)` yet.")
        }
    }
    
    public static func generate(parameterCount: Int, minimum: Float32, maximum: Float32) -> [Float32] {
        minimum == maximum ?
            [Float32](repeating: minimum, count: parameterCount) :
            (1...parameterCount).map { _ in Float32.random(in: minimum...maximum) }
    }

}
