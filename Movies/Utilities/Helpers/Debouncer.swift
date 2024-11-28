//
//  Debouncer.swift
//  Movies
//
//  Created by GiN Eugene on 28/11/2024.
//

import Foundation

final class Debouncer {
    private var timer: Timer?
    private let delay: TimeInterval
    private let queue: DispatchQueue
    
    init(delay: TimeInterval, queue: DispatchQueue = .main) {
        self.delay = delay
        self.queue = queue
    }
    
    func debounce(action: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?.queue.async {
                action()
            }
        }
    }
}
