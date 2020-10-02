//
//  MPSGShape.swift
//  
//
//  Created by Maxim Volgin on 02/10/2020.
//

import Foundation

public enum MPSGShape {
    // parameters
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
    
    var shape: [Int] {
        get {
            switch self {
            // parameters
            case .HWIO(let H, let W, let I, let O):
                return [H, W, I, O]
            case .OIHW(let O, let I, let H, let W):
                return [O, I, H, W]
            case .IO(let I, let O):
                return [I, O]
            // data
            case .NCHW(let N, let C, let H, let W):
                return [N, C, H, W]
            case .NHWC(let N, let H, let W, let C):
                return [N, H, W, C]
            }

        }
    }
    
    var weightCount: Int {
        get {
            switch self {
            // parameters
            case .HWIO(_, _, _, _):
                fallthrough
            case .OIHW(_, _, _, _):
                fallthrough
            case .IO(_, _):
                return shape.reduce(1, *)
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
            default:
                return 0
            }
        }
    }
    
}
