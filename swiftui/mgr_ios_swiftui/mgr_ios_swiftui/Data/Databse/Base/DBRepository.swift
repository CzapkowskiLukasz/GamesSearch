//
//  DBRepository.swift
//

import Foundation
import SQLite

protocol DBRepositoryFetchtable {
    
    associatedtype Entity: DBEntity
    
    func fetch(by predicate: Expression<Bool>, order: [Expressible], limit: Limit?) throws -> [Entity.DataType]
    func fetch(by predicate: Expression<Bool?>, order: [Expressible], limit: Limit?) throws -> [Entity.DataType]
    
    func pluck(by predicate: Expression<Bool>, order: [Expressible]) throws -> Entity.DataType?
    func pluck(by predicate: Expression<Bool?>, order: [Expressible]) throws -> Entity.DataType?
    
    func count(by predicate: Expression<Bool>?) -> Int
    func count(by predicate: Expression<Bool?>) -> Int
    
}

extension DBRepositoryFetchtable {

    var db: Connection { MainDatabase.shared.db }
    
    func fetch(
        by predicate: Expression<Bool> = .init(value: true),
        order: [Expressible] = [], limit: Limit? = nil
    ) throws -> [Entity.DataType] {
        
        try fetch(
            by: Expression<Bool?>(predicate),
            order: order,
            limit: limit
        )
        
    }
    
    func fetch(
        by predicate: Expression<Bool?>,
        order: [Expressible] = [], limit: Limit? = nil
    ) throws -> [Entity.DataType] {
        
        try db
            .prepare(Entity.schema.filter(predicate).order(order).limit(limit))
            .map { Entity.create(from: $0) }
        
    }
    
    func fetch(query: SchemaType) -> [Entity.DataType] {
        (try? db.prepare(query).map { Entity.create(from: $0) }) ?? []
    }
    
    func pluck(
        by predicate: Expression<Bool> = .init(value: true),
        order: [Expressible] = []
    ) throws -> Entity.DataType? {
        
        try pluck(
            by: Expression<Bool?>(predicate),
            order: order
        )
        
    }
    
    func pluck(
        by predicate: Expression<Bool?>,
        order: [Expressible] = []
    ) throws -> Entity.DataType? {
        
        try db
            .pluck(Entity.schema.filter(predicate).order(order))
            .map { Entity.create(from: $0) }
        
    }
    
    func count(by predicate: Expression<Bool>? = nil) -> Int {
        if let predicate = predicate {
            return (try? db.scalar(Entity.schema.filter(predicate).count)) ?? 0
        }

        return (try? db.scalar(Entity.schema.count)) ?? 0
    }
    
    func count(by predicate: Expression<Bool?>) -> Int {
        return (try? db.scalar(Entity.schema.filter(predicate).count)) ?? 0
    }
    
}

protocol DBRepository: DBRepositoryFetchtable {
    
    func insert(object: Entity.DataType) throws
    func insert(objects: [Entity.DataType]) throws
    
    func dropAndInsert(item: Entity.DataType) throws
    func dropAndInsert(items: [Entity.DataType]) throws
    
    @discardableResult
    func delete(by predicate: Expression<Bool>) throws -> Int
    @discardableResult
    func delete(by predicate: Expression<Bool?>) throws -> Int
    
    @discardableResult
    func deleteAll() throws -> Int
    
}

extension DBRepository where Entity.Schema == Table {
    
    func defaultInsert(object: Entity.DataType) throws {
        let setters = Entity.toSetterMap(object: object)
        let query = Entity.schema.insert(or: .replace, setters)
        
        try db.run(query)
    }
    
    func defaultInsert(objects: [Entity.DataType]) throws {
        guard !objects.isEmpty else { return }
    
        try insert(setters: objects.map { Entity.toSetterMap(object: $0) } )
    }

    func insert(setters: [[Setter]]) throws {
        func insertMutliple(_ setters: [[Setter]]) throws {
            let query = Entity.schema.insertMany(or: .replace, setters)
            try db.run(query)
        }
        
        let chunks = setters.chunked(into: 5000)
        
        for chunk in chunks {
            try insertMutliple(chunk)
        }
    }
    
    func insert(object: Entity.DataType) throws {
        try defaultInsert(object: object)
    }

    func insert(objects: [Entity.DataType]) throws {
        try defaultInsert(objects: objects)
    }
    
    func dropAndInsert(item: Entity.DataType) throws {
        try deleteAll()
        try insert(object: item)
    }
    
    func dropAndInsert(items: [Entity.DataType]) throws {
        try deleteAll()
        try insert(objects: items)
    }
    
    @discardableResult
    func delete(by predicate: Expression<Bool> = .init(value: true)) throws -> Int {
        try db.run(Entity.schema.filter(predicate).delete())
    }
    
    @discardableResult
    func delete(by predicate: Expression<Bool?> = .init(value: true)) throws -> Int {
        try db.run(Entity.schema.filter(predicate).delete())
    }
    
    @discardableResult
    func deleteAll() throws -> Int {
        return try db.run(Entity.schema.delete())
    }
}

protocol DBDecodableRepository: DBRepository where Entity.DataType: Decodable {
    func getDataType() -> Entity.DataType.Type
}

extension DBDecodableRepository {
    func getDataType() -> Entity.DataType.Type {
        Entity.DataType.self
    }
}

extension QueryType {
    
    func limit(_ limit: Limit?) -> Self {
        guard let limit else { return self }
        return self.limit(limit.limit, offset: limit.offset)
    }

}
