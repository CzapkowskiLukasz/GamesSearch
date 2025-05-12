//
//  MainDatabase.swift
//
//

import Foundation
import SQLite

class MainDatabase {

    static let shared: MainDatabase = .init()
    
    let db: Connection
    
    init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

        do {
            db = try Connection(path + "/app.sqlite3")

            print("Database location: \(path)")
            
            try db.execute("PRAGMA foreign_keys=ON")
            
            try configure()
        } catch {
            fatalError("Database connection or configuration error: \(error.localizedDescription)")
        }
    }
    
    private func configure() throws {
        try db.configure(
            DBUpdateActionV1()
        )
    }

}

extension Connection {
    
//    func deleteTables(whitelist: [String] = []) throws {
//        let allTables = DBInfoEntity.repository.fetch(type: Table.self)
//            .filter({ !whitelist.contains($0.name) })
//            .map({ Table($0.name) })
//        
//        try allTables.forEach { table in
//            try run(table.delete())
//        }
//    }
    
    func configure(_ actions: DBUpdateAction...) throws {
        
        try actions
            .forEach { action in
                
                try savepoint { try action.update(self) }
            }
        
    }
    
}
