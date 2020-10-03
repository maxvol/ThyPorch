//
//  Conv2D.swift
//  
//
//  Created by Maxim Volgin on 02/10/2020.
//

import Foundation

public struct Conv2D {
    public let kernelSize: Size
    public let stride: Stride
    public let padding: Padding
    public let dilation: Stride
    public let groupCount: Int
    
    public init(kernelSize: Size, stride: Stride = .YX(1, 1), padding: Padding = .valid, dilation: Stride = .YX(1, 1), groupCount: Int = 1) {
        self.kernelSize = kernelSize
        self.stride = stride
        self.padding = padding
        self.dilation = dilation
        self.groupCount = groupCount
    }
}
