//
//  EndPointType.swift
//  Manj
//
//  Created by Manjinder Singh on 29/03/2025.
//  Copyright © 2025 Manjinder Singh. All rights reserved.
//

import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    func task() async -> HTTPTask
    func headers() async -> HTTPHeaders?
}
