//
//  DBUpdateActionV.swift
//

import Foundation
import SQLite

protocol DBUpdateAction {
    
    func update(_ connection: Connection) throws
    
}

struct DBUpdateActionV1: DBUpdateAction {

    func update(_ connection: Connection) throws {
        try GamesEntity.createSchema(db: connection)
        try ParentPlatformEntity.createSchema(db: connection)
        try PlatformGameEntity.createSchema(db: connection)
    }
    
}
