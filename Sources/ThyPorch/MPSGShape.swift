//
//  MPSGShape.swift
//  
//
//  Created by Maxim Volgin on 02/10/2020.
//

import Foundation

public enum MPSGShape {
    // weights
    case IO(Int, Int)
    case HWIO(Int, Int, Int, Int) // TensorFlow
    case OIHW(Int, Int, Int, Int) // MetalPerformanceShadersGraph
    // data
    case NCHW(Int, Int, Int, Int) // TensorFlow
    case NHWC(Int, Int, Int, Int) // PyTorch
    
    //case CHW
    //case HWC
    //case HW
}

public extension MPSGShape {
    
    var weightCount: Int {
        get {
            switch self {
            // weights
            case .HWIO(let H, let W, let I, let O):
                fallthrough
            case .OIHW(let O, let I, let H, let W):
                return H * W * I * O
            case .IO(let I, let O):
                return I * O
//            case .NCHW(let N, let C, let H, let W):
//                fallthrough
//            case .NHWC(let N, let H, let W, let C):
//                return N * H * W * C
            // data
            default:
                return 0
            }
        }
    }
    
    var biasCount: Int {
        get {
            switch self {
            // weights
            case .HWIO(_, _, _, let O):
                fallthrough
            case .OIHW(let O, _, _, _):
                return O
            case .IO(_, let O):
                return O
            // data
//            case .NCHW(_, let C, _, _):
//                fallthrough
//            case .NHWC(_, _, _, let C):
//                return C
            default:
                return 0
            }
        }
    }
    
}
