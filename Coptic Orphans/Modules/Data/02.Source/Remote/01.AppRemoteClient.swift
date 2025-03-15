//
//  02.AppRemoteClient.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//


import Combine
import Foundation
import Alamofire


protocol AppRemoteDataSourceProtocol {
    func getAllPublicRepositories(page: Int) -> AnyPublisher<[GitRepositoryEntity], NetworkError>
}


class AppRemoteDataSource: AppRemoteDataSourceProtocol {
    
    private let baseURL = "https://api.github.com/repositories"
        
    func getAllPublicRepositories(page: Int) -> AnyPublisher<[GitRepositoryEntity], NetworkError> {
        let url = "\(baseURL)?since=\(page * 30)"
        
        return AF.request(url)
            .validate()
            .publishDecodable(type: [GitRepositoryEntity].self)
            .tryMap { response in
                guard let data = response.value else {
                    throw NetworkError.networkFailure(response.error ?? AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: 500)))
                }
                return data
            }
            .mapError { error -> NetworkError in
                return NetworkError.networkFailure(error)
            }
            .eraseToAnyPublisher()
    }

}
