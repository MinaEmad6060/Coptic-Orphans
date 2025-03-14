//
//  03.HomeUseCase.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//


import Combine

//MARK: - UseCase
protocol HomeUseCaseProtocol {
//    func getUsers() -> AnyPublisher<[UserDomain], NetworkError>
}


final class HomeUseCase {
    let repository: AppRepositoryProtocol
    init(dependencies: HomeUseCaseDependanciesProtocol) {
        self.repository = dependencies.repository
    }
}

extension HomeUseCase: HomeUseCaseProtocol {
    
//    func getUsers() -> AnyPublisher<[UserDomain], NetworkError> {
//        repository.getUsers()
//            .map { entities in
//                entities.map { $0.toDomain() }
//            }
//            .eraseToAnyPublisher()
//    }
//
}



//MARK: - UseCase-Dependancies
protocol HomeUseCaseDependanciesProtocol{
    var repository: AppRepositoryProtocol { get }
}


struct HomeUseCaseDependencies: HomeUseCaseDependanciesProtocol {
    var repository: AppRepositoryProtocol
}
