//
//  Pool2D.swift
//  
//
//  Created by Maxim Volgin on 02/10/2020.
//

import Foundation

public struct Pool2D {
    public let kernelSize: Size
    public let stride: Stride
    public let padding: Padding
    
    public init(kernelSize: Size, stride: Stride = .YX(1, 1), padding: Padding = .valid) {
        self.kernelSize = kernelSize
        self.stride = stride
        self.padding = padding
    }
}

