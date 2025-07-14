//
//  main.swift
//  tracetest
//
//  Created by Peter Richardson on 7/13/25.
//

import Foundation
import PRDebugKit


func levelTwo() {
    trace() {
        print("Starting work! levelTwo")
        print("Doing work!  level Two")
    }
}

func levelOne() {
    trace() {
        levelTwo()
    }
}

@main
struct tracetest {
    static func main() async throws {
        trace() {
            levelOne()
        }
    }
    
}

