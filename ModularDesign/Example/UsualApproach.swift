//
//  UsualApproach.swift
//  ModularDesign
//
//  Created by Anderson Costa on 10/02/2022.
//

import Foundation

class OrderRepository: OrderRepositoryType {

    private let cacheReader: CacheReaderType
    private let cacheWriter: CacheWriterType
    private let httpClient: HTTPClientType
    private let url: URL

    init(cacheReader: CacheReaderType, cacheWriter: CacheWriterType, httpClient: HTTPClientType, url: URL) {
        self.cacheReader = cacheReader
        self.cacheWriter = cacheWriter
        self.httpClient = httpClient
        self.url = url
    }

    func fetchAll(completion: @escaping (Result<[Order], Error>) -> Void) {
        if let orders: [Order] = cacheReader.get() {
            return completion(.success(orders))
        }

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
    cacheReader: CacheReader(),
    cacheWriter: CacheWriter(),
    httpClient: HTTPClient(),
    url: URL(string: "www.costa.co.uk")!
)
