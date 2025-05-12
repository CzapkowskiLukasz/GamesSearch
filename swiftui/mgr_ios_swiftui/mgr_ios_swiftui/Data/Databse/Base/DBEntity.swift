//
//  DBEntity.swift
//

import Foundation
import SQLite

protocol DBEntity {
    
    associatedtype DataType
    associatedtype Schema: SchemaType
    
    static var schemaName: String { get }
    static var schema: Schema { get }

    static func create(from row: Row) -> DataType
    static func toSetterMap(object: DataType) -> [Setter]
    static func createSchema(db: Connection) throws
    
}

extension DBEntity where Schema == Table {
    
    static var schema: Schema { .init(schemaName) }
    
}
