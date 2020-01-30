//
//  System.swift
//  EP QTc
//
//  Created by David Mann on 1/29/20.
//  Copyright © 2020 EP Studios. All rights reserved.
//

import Foundation

enum SystemType {
    case iOS
    case mac
}

func systemType() -> SystemType {
    #if targetEnvironment(macCatalyst)
    return .mac
    #else
    return .iOS
    #endif
}
