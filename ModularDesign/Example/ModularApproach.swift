//
//  ModularApproach.swift
//  ModularDesign
//
//  Created by Anderson Costa on 10/02/2022.
//

import Foundation

class MOrderRepository: OrderRepositoryType {

    private let httpClient: HTTPClientType
    private let url: URL

    init(httpClient: HTTPClientType, url: URL) {
        self.httpClient = httpClient
        self.url = url
    }

    func fetchAll(completion: @escaping (Result<[Order], Error>) -> Void) {
        httpClient.fetch(from: url, completion: completion)
    }
}

// USAGE

let modular = MOrderRepository(
    httpClient: HTTPClient(),
    url: URL(string: "www.costa.co.uk")!
)
