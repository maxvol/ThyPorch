//
//  BNNSModel.swift
//  
//
//  Created by Maxim Volgin on 02/10/2020.
//

import Foundation
import Accelerate

@available(macOS 11, iOS 14, *)
public protocol BNNSModel {
    func forward(_ inputArray: BNNSNDArrayDescriptor, _ outputArray: BNNSNDArrayDescriptor)
    func backwardPass()
    func computeLoss()
}

@available(macOS 11, iOS 14, *)
public extension BNNSModel {
}



