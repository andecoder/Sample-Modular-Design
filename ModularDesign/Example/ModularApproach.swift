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

class MOrderRepositoryCacheDecorator: OrderRepositoryType {

    private let cacheWriter: CacheWriterType
    private let decoratee: OrderRepositoryType

    init(cacheWriter: CacheWriterType, decoratee: OrderRepositoryType) {
        self.cacheWriter = cacheWriter
        self.decoratee = decoratee
    }

    func fetchAll(completion: @escaping (Result<[Order], Error>) -> Void) {
        decoratee.fetchAll { [weak self] result in
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

let modular = MOrderRepositoryCacheDecorator(
    cacheWriter: CacheWriter(),
    decoratee: MOrderRepository(
        httpClient: HTTPClient(),
        url: URL(string: "www.costa.co.uk")!
    )
)
