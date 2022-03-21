//
//  ViewState.swift
//  sampleapp
//
//  Created by Ricarlo Silva on 07/12/21.
//

import Foundation
import SwiftUI

enum ViewState<T> {
    case Idle
    case Success(_ data: T)
    case Loading(_ message: String? = nil)
    case Failure(_ error: Error)
}
