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

