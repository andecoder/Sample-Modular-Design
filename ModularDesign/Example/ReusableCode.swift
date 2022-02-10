//
//  ReusableCode.swift
//  ModularDesign
//
//  Created by Anderson Costa on 10/02/2022.
//

import Foundation

protocol CacheWriterType {
    func cache<Model: Encodable>(_: Model)
}

class CacheWriter: CacheWriterType {

    func cache<Model>(_: Model) where Model : Encodable { }
}

protocol HTTPClientType {
    func fetch<Model: Decodable>(from: URL, completion: @escaping (Result<Model, Error>) -> Void)
}

class HTTPClient: HTTPClientType {

    func fetch<Model>(from: URL, completion: @escaping (Result<Model, Error>) -> Void) where Model : Decodable { }
}

struct Order: Codable { }

protocol OrderRepositoryType {
    func fetchAll(completion: @escaping (Result<[Order], Error>) -> Void)
}
