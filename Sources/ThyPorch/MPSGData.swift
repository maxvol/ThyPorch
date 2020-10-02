//
//  MPSGData.swift
//  
//
//  Created by Maxim Volgin on 02/10/2020.
//

import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

public struct MPSGData {
    
    public static func generate(parameterCount: Int, dataType: MPSDataType, minimum: Float, maximum: Float) -> Data {
        switch dataType {
        case .float32:
            let parameterArray = MPSGData.getRandomData(count: parameterCount, minimum: minimum, maximum: maximum)
            return Data(bytes: parameterArray, count: parameterCount * MemoryLayout<Float32>.size)
        default:
            fatalError("Not implemented for `\(dataType)` yet.")
        }
    }
    
    private static func getRandomData(count: Int, minimum: Float32, maximum: Float32) -> [Float32] {
        minimum == maximum ?
            [Float32](repeating: minimum, count: count) :
            (1...count).map { _ in Float32.random(in: minimum...maximum) }
    }

}
