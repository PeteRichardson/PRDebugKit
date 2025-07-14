//
//  main.swift
//  tracetest2
//
//  Created by Peter Richardson on 7/13/25.
//

import Foundation
import PRDebugKit


@main
struct tracetest2 {
    static func main() {
        trace() {
            bootstrapLogging()
            let logger = SwiftLogAdapter(label: "logtest", level: .debug )
            logger.info("Some info message.")
            print("Hello, World!")
            logger.debug("A debug message!")
        }
    }
}

