//
//  02.AppRemoteClient.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//


import Combine
import Foundation


protocol AppRemoteDataSourceProtocol {
//    func getUsers() -> AnyPublisher<[User], NetworkError>
}


class AppRemoteDataSource {
//    private let provider: MoyaProvider<SocialEndpoint> = MoyaProvider<SocialEndpoint>(
//        plugins: [NetworkLoggerPlugin(configuration: .init(
//            logOptions: [
//                .successResponseBody,
//                .errorResponseBody
//            ]))]
//    )
}

extension AppRemoteDataSource: AppRemoteDataSourceProtocol {
    
//    func getUsers() -> AnyPublisher<[User], NetworkError> {
//           return Future { [weak self] promise in
//               guard let self = self else { return }
//               self.provider.request(.getUsers) { result in
//                   switch result {
//                   case .success(let response):
//                       do {
//                           let users = try JSONDecoder().decode([User].self, from: response.data)
//                           promise(.success(users))
//                       } catch {
//                           promise(.failure(NetworkError.decodingError(error)))
//                       }
//                   case .failure(let error):
//                       promise(.failure(NetworkError.networkFailure(error)))
//                   }
//               }
//           }
//           .eraseToAnyPublisher()
//    }

}
