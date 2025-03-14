//
//  AppRepository.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//


import Combine

//MARK: - Repository
protocol AppRepositoryProtocol {
//    func getUsers() -> AnyPublisher<[User], NetworkError>
}

final class AppRepository {
    let dataSource: AppRemoteDataSourceProtocol
    
    init(dependencies: AppRepositoryDependenciesProtocol) {
        self.dataSource = dependencies.dataSource
    }
}

extension AppRepository: AppRepositoryProtocol{
    
//    func getUsers() -> AnyPublisher<[User], NetworkError> {
//        dataSource.getUsers()
//            .eraseToAnyPublisher()
//    }
    
}


//MARK: - Repository-Dependencies
protocol AppRepositoryDependenciesProtocol {
    var dataSource: AppRemoteDataSourceProtocol { get }
}

struct AppRepositoryDependencies: AppRepositoryDependenciesProtocol {
    var dataSource: AppRemoteDataSourceProtocol
}

