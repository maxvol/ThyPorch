//
//  Shape+BNNS.swift
//  
//
//  Created by Maxim Volgin on 03/10/2020.
//

import Accelerate

@available(macOS 11.0, iOS 14.0, tvOS 14.0, watchOS 7.0, *)
public extension Shape {
    
    func convolutionWeightsOIHW(stride: (Int, Int, Int, Int) = (0, 0, 0, 0)) -> BNNS.Shape {
        switch self {
        // parameters
        case .HWIO(let H, let W, let I, let O):
            return BNNS.Shape.convolutionWeightsOIHW(W, H, I, O, stride: stride)
        case .OIHW(let O, let I, let H, let W):
            return BNNS.Shape.convolutionWeightsOIHW(W, H, I, O, stride: stride)
        default:
            fatalError("Illegal type `\(self)`.")
        }
    }

    func imageCHW(stride: (Int, Int, Int) = (0, 0, 0)) -> BNNS.Shape {
        switch self {
        // data
        case .CHW(let C, let H, let W):
            return BNNS.Shape.imageCHW(W, H, C, stride: stride)
        case .HWC(let H, let W, let C):
            return BNNS.Shape.imageCHW(W, H, C, stride: stride)
        default:
            fatalError("Illegal type `\(self)`.")
        }
    }
    
}
