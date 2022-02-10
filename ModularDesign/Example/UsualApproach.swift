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
        httpClient.fetch(from: url) { [weak self] (result: Result<[Order], Error>) in
            guard let self = self else { return }
            if case let .success(orders) = result {
                self.cacheWriter.cache(orders)
                completion(result)
            } else if let orders: [Order] = self.cacheReader.get() {
                completion(.success(orders))
            } else {
                completion(result)
            }
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
