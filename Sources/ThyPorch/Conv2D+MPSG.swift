//
//  Conv2D+MPSG.swift
//  
//
//  Created by Maxim Volgin on 02/10/2020.
//

import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(macOS 11, iOS 14, *)
public extension Conv2D {
    
    func toMPSGraphConvolution2DOpDescriptor(dataLayout: MPSGraphTensorNamedDataLayout, weightsLayout: MPSGraphTensorNamedDataLayout) -> MPSGraphConvolution2DOpDescriptor? {
        let (strideX, strideY) = stride.toXY
        let (dilationX, dilationY) = dilation.toXY
        return MPSGraphConvolution2DOpDescriptor(strideInX: strideX,
                                          strideInY: strideY,
                                          dilationRateInX: dilationX,
                                          dilationRateInY: dilationY,
                                          groups: groupCount,
                                          paddingStyle: padding.toMPSGraphPaddingStyle,
                                          dataLayout: dataLayout,
                                          weightsLayout: weightsLayout)
    }
    
    func toWeightsShape(channelCount: Int, filterCount: Int, weightsLayout: MPSGraphTensorNamedDataLayout) -> Shape {
        let (height, width) = kernelSize.toHW
        switch weightsLayout {
        case .HWIO:
            return .HWIO(height, width, channelCount, filterCount)
        case .OIHW:
            return .OIHW(filterCount, channelCount, height, width)
        default:
            fatalError("Illegal weightsLayout: `\(weightsLayout)`.")
        }
    }
    
}
