//
//  Pool2D.swift
//  
//
//  Created by Maxim Volgin on 02/10/2020.
//

import Foundation

public struct Pool2D {
    public let kernelSize: (height: Int, width: Int)
    public let stride: (y: Int, x: Int)
    public let padding: Padding
    
    public init(kernelSize: (height: Int, width: Int), stride: (y: Int, x: Int) = (1, 1), padding: Padding = .valid) {
        self.kernelSize = kernelSize
        self.stride = stride
        self.padding = padding
    }
}

