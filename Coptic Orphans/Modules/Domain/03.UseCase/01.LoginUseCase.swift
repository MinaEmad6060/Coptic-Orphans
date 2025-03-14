//
//  01.LoginUseCase.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 14/03/2025.
//


import Combine


//MARK: - UseCase
protocol LoginUseCaseProtocol {
//    func getUsers() -> AnyPublisher<[UserDomain], NetworkError>
}


final class LoginUseCase {
    let repository: AppRepositoryProtocol
    init(dependencies: LoginUseCaseDependanciesProtocol) {
        self.repository = dependencies.repository
    }
}

extension LoginUseCase: LoginUseCaseProtocol {
    
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
protocol LoginUseCaseDependanciesProtocol{
    var repository: AppRepositoryProtocol { get }
}


struct LoginUseCaseDependencies: LoginUseCaseDependanciesProtocol {
    var repository: AppRepositoryProtocol
}
