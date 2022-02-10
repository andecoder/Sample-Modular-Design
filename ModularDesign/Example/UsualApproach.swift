//
//  UsualApproach.swift
//  ModularDesign
//
//  Created by Anderson Costa on 10/02/2022.
//

import Foundation

class OrderRepository: OrderRepositoryType {

    private let cacheWriter: CacheWriterType
    private let httpClient: HTTPClientType
    private let url: URL

    init(cacheWriter: CacheWriterType, httpClient: HTTPClientType, url: URL) {
        self.cacheWriter = cacheWriter
        self.httpClient = httpClient
        self.url = url
    }

    func fetchAll(completion: @escaping (Result<[Order], Error>) -> Void) {
        httpClient.fetch(from: url) { [weak self] (result: Result<[Order], Error>) in
            guard let self = self else { return }
            self.cacheIfPossible(result)
            completion(result)
        }
    }

    private func cacheIfPossible(_ result: Result<[Order], Error>) {
        if case let .success(orders) = result {
            cacheWriter.cache(orders)
        }
    }
}

// USAGE

let usual = OrderRepository(
    cacheWriter: CacheWriter(),
    httpClient: HTTPClient(),
    url: URL(string: "www.costa.co.uk")!
)
