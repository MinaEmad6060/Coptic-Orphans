//
//  02.registerUseCase.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//


import Combine

//MARK: - UseCase
protocol RegisterUseCaseProtocol {
//    func getUsers() -> AnyPublisher<[UserDomain], NetworkError>
}


final class RegisterUseCase {
    let repository: AppRepositoryProtocol
    init(dependencies: RegisterUseCaseDependanciesProtocol) {
        self.repository = dependencies.repository
    }
}

extension RegisterUseCase: RegisterUseCaseProtocol {
    
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
protocol RegisterUseCaseDependanciesProtocol{
    var repository: AppRepositoryProtocol { get }
}


struct RegisterUseCaseDependencies: RegisterUseCaseDependanciesProtocol {
    var repository: AppRepositoryProtocol
}
