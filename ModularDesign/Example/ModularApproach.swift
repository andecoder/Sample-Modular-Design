//
//  ModularApproach.swift
//  ModularDesign
//
//  Created by Anderson Costa on 10/02/2022.
//

import Foundation

class MLocalOrderRepository: OrderRepositoryType {

    enum Error: Swift.Error {
        case missingFile
    }

    private let cacheReader: CacheReaderType

    init(cacheReader: CacheReaderType) {
        self.cacheReader = cacheReader
    }

    func fetchAll(completion: @escaping (Result<[Order], Swift.Error>) -> Void) {
        if let orders: [Order] = cacheReader.get() {
            completion(.success(orders))
        } else {
            completion(.failure(Error.missingFile))
        }
    }
}

class MRemoteOrderRepository: OrderRepositoryType {

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

class MOrderRepositoryComposite: OrderRepositoryType {

    private let primary: OrderRepositoryType
    private let fallback: OrderRepositoryType

    init(primary: OrderRepositoryType, fallback: OrderRepositoryType) {
        self.primary = primary
        self.fallback = fallback
    }

    func fetchAll(completion: @escaping (Result<[Order], Error>) -> Void) {
        primary.fetchAll { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                completion(result)
            case .failure:
                self.fallback.fetchAll(completion: completion)
            }
        }
    }
}

// USAGE

let modular = MOrderRepositoryComposite(
    primary: MOrderRepositoryCacheDecorator(
        cacheWriter: CacheWriter(),
        decoratee: MRemoteOrderRepository(
            httpClient: HTTPClient(),
            url: URL(string: "www.costa.co.uk")!
        )
    ),
    fallback: MLocalOrderRepository(cacheReader: CacheReader())
)
