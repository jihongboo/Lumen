//
//  AppIdleTimer.swift
//  Lumen
//
//  Created by Codex on 2026/5/3.
//

#if os(iOS) || os(tvOS)
import UIKit
#endif

enum AppIdleTimer {
    static func disable() {
        #if os(iOS) || os(tvOS)
        UIApplication.shared.isIdleTimerDisabled = true
        #endif
    }
}
