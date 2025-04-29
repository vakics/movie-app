//
//  Throttler.swift
//  movie-app
//
//  Created by Panna Krisztina Pazonyi on 2025. 04. 27..
//
import Foundation

class Throttler {
    private var lastRun: Date = Date.distantPast
    private let queue: DispatchQueue
    private let interval: TimeInterval
    private let syncQueue = DispatchQueue(label: "throttler.sync.queue")

    init(interval: TimeInterval, queue: DispatchQueue = DispatchQueue.main) {
        self.interval = interval
        self.queue = queue
    }

    func throttle(action: @escaping () -> Void) {
        syncQueue.sync {
            let now = Date()
            let timeSinceLastRun = now.timeIntervalSince(lastRun)

            if timeSinceLastRun >= interval {
                lastRun = now
                queue.async(execute: action)
            }
        }
    }
}
