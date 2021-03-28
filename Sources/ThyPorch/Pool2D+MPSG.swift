//
//  Pool2D+MPSG.swift
//  
//
//  Created by Maxim Volgin on 02/10/2020.
//

import Foundation
import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public extension Pool2D {
    
    func toMPSGraphPooling2DOpDescriptor(dataLayout: MPSGraphTensorNamedDataLayout) -> MPSGraphPooling2DOpDescriptor? {
        let (width, height) = kernelSize.toWH
        let (x, y) = stride.toXY
        return MPSGraphPooling2DOpDescriptor(kernelWidth: width,
                                      kernelHeight: height,
                                      strideInX: x,
                                      strideInY: y,
                                      paddingStyle: padding.toMPSGraphPaddingStyle,
                                      dataLayout: dataLayout)
    }
    
}
