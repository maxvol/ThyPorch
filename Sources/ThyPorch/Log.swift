//
//  Log.swift
//  
//
//  Created by Maxim Volgin on 30/09/2020.
//

import os.log
import Foundation

@available(macOS 11, iOS 14, *)
struct Log {
    fileprivate static let subsystem: String = "ThyPorch" // Bundle.main.bundleIdentifier ?? ""
    
    static let metalPerformanceShadersGraph = OSLog(subsystem: subsystem, category: "MetalPerformanceShadersGraph")
}

