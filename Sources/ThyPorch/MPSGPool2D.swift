//
//  MPSGPool2D.swift
//  
//
//  Created by Maxim Volgin on 02/10/2020.
//

import Foundation
import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(iOS 14, *)
public extension Pool2D {
    
    func toMPSGraphPooling2DOpDescriptor(dataLayout: MPSGraphTensorNamedDataLayout) -> MPSGraphPooling2DOpDescriptor? {
        MPSGraphPooling2DOpDescriptor(kernelWidth: kernelSize.width,
                                      kernelHeight: kernelSize.height,
                                      strideInX: stride.x,
                                      strideInY: stride.y,
                                      paddingStyle: padding.toMPSGraphPaddingStyle,
                                      dataLayout: dataLayout)
    }
    
}
