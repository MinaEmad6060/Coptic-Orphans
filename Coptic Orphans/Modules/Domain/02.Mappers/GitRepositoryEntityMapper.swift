//
//  GitRepositoryEntityMapper.swift
//  Coptic Orphans
//
//  Created by Mina Emad on 15/03/2025.
//

extension GitRepositoryEntity {
    
    func toDomain() -> GitRepositoryDomain {
        return GitRepositoryDomain(
            name: self.name,
            description: self.description
        )
    }
    
}
