//
//  Conv2D.swift
//  
//
//  Created by Maxim Volgin on 02/10/2020.
//

import Foundation

public struct Conv2D {
    public let kernelSize: (height: Int, width: Int)
    public let stride: (y: Int, x: Int)
    public let padding: Padding
    public let dilation: (y: Int, x: Int)
    public let groupCount: Int
    
    public init(kernelSize: (height: Int, width: Int), stride: (y: Int, x: Int) = (1, 1), padding: Padding = .valid, dilation: (y: Int, x: Int) = (1, 1), groupCount: Int = 1) {
        self.kernelSize = kernelSize
        self.stride = stride
        self.padding = padding
        self.dilation = dilation
        self.groupCount = groupCount
    }
}
