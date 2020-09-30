//
//  Linear.swift
//  
//
//  Created by Maxim Volgin on 30/09/2020.
//

import Foundation

/**
 y = xWᵀ + b
 input shape: (N, *, Hᵢₙ) where Hᵢₙ = in_features
 output shape: (N, *, Hₒᵤₜ) where Hₒᵤₜ = out_features
 */
public struct Linear {
    let in_features: Int
    let out_features: Int
    var weight: [Float] = [] // shape: (out_features, in_features), init as U(-√k, √k) where k = 1/in_features
    let bias: bool = true // shape: (out_features), init as U(-√k, √k) where k = 1/in_features
     
    public init(_ in_features: Int, _ out_features: Int, _ bias: bool = true) {
        self.in_features = in_features
        self.out_features = output_features
        self.bias = bias
    }
}

//>>> m = nn.Linear(20, 30)
//>>> input = torch.randn(128, 20)
//>>> output = m(input)
//>>> print(output.size())
//torch.Size([128, 30])
