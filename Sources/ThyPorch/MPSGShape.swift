//
//  MPSGShape.swift
//  
//
//  Created by Maxim Volgin on 02/10/2020.
//

import Foundation

public enum MPSGShape {
    // data
    case NCHW(Int, Int, Int, Int) // TensorFlow
    case NHWC(Int, Int, Int, Int) // PyTorch
    // weights
    case HWIO(Int, Int, Int, Int) // TensorFlow
    case OIHW(Int, Int, Int, Int) // MetalPerformanceShadersGraph
}

public extension MPSGShape {
    var count: Int {
        get {
            switch self {
            // data
            case .NCHW(let N, let C, let H, let W):
                fallthrough
            case .NHWC(let N, let H, let W, let C):
                return N * H * W * C
            // weights
            case .HWIO(let H, let W, let I, let O):
                fallthrough
            case .OIHW(let O, let I, let H, let W):
                return H * W * I * O
            }
        }
    }
}


