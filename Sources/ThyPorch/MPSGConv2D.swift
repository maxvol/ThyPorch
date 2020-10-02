//
//  MPSGConv2D.swift
//  
//
//  Created by Maxim Volgin on 02/10/2020.
//

import Foundation
import MetalPerformanceShaders
import MetalPerformanceShadersGraph

@available(iOS 14, *)
public extension Conv2D {
    
    func toMPSGraphConvolution2DOpDescriptor(dataLayout: MPSGraphTensorNamedDataLayout, weightsLayout: MPSGraphTensorNamedDataLayout) -> MPSGraphConvolution2DOpDescriptor? {
        MPSGraphConvolution2DOpDescriptor(strideInX: stride.x,
                                          strideInY: stride.y,
                                          dilationRateInX: dilation.x,
                                          dilationRateInY: dilation.y,
                                          groups: groupCount,
                                          paddingStyle: padding.toMPSGraphPaddingStyle,
                                          dataLayout: dataLayout,
                                          weightsLayout: weightsLayout)
    }
    
    func toWeightsLayout(channelCount: Int, filterCount: Int, weightsLayout: MPSGraphTensorNamedDataLayout) -> MPSGShape {
        switch weightsLayout {
        case .HWIO:
            return .HWIO(kernelSize.height, kernelSize.width, channelCount, filterCount)
        case .OIHW:
            return .OIHW(filterCount, channelCount, kernelSize.height, kernelSize.width)
        default:
            fatalError("Illegal weightsLayout: `\(weightsLayout)`.")
        }
    }
    
}
