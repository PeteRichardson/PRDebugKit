//
//  trace.swift
//  tracetest
//
//  Created by Peter Richardson on 7/13/25.
//

import Foundation
import os
import os.signpost

let signpostLog = OSLog(subsystem: defaultSubsystem, category: .pointsOfInterest)
let logger     = Logger(subsystem: defaultSubsystem, category: "Tracing")


// Thread-local nesting depth tracker
private let traceDepthKey = "\(defaultSubsystem).traceDepth"

public func trace<T>(_ name: StaticString = #function, _ function: () -> T) -> T {
    // Get current depth
    let currentDepth = (Thread.current.threadDictionary[traceDepthKey] as? Int) ?? 0
    Thread.current.threadDictionary[traceDepthKey] = currentDepth + 1

    let indent = String(repeating: "  ", count: currentDepth)
    logger.info("\(indent, privacy: .public)→ƒ \(String(describing: name), privacy: .public)")

    let signpostID = OSSignpostID(log: signpostLog)
    os_signpost(.begin, log: signpostLog, name: name, signpostID: signpostID)

    defer {
        os_signpost(.end, log: signpostLog, name: name, signpostID: signpostID)
        logger.info("\(indent, privacy: .public)←ƒ \(String(describing: name), privacy: .public)")
        Thread.current.threadDictionary[traceDepthKey] = currentDepth
    }

    return function()
}
