//
//  ReusableCode.swift
//  ModularDesign
//
//  Created by Anderson Costa on 10/02/2022.
//

import Foundation

protocol HTTPClientType {
    func fetch<Model: Codable>(from: URL, completion: @escaping (Result<Model, Error>) -> Void)
}

class HTTPClient: HTTPClientType {

    func fetch<Model>(from: URL, completion: @escaping (Result<Model, Error>) -> Void) where Model : Decodable { }
}

struct Order: Codable { }

protocol OrderRepositoryType {
    func fetchAll(completion: @escaping (Result<[Order], Error>) -> Void)
}
