//
//  DBRepositoryFetchtable+Distinct.swift
//

import Foundation
import SQLite

extension DBRepositoryFetchtable {
    
    func fetchDistinct<DataType: Value>(
        column: Expression<DataType?>,
        query: SchemaType = Entity.schema,
        predicate: Expression<Bool>? = nil,
        orderBy order: [Expressible] = []) -> [DataType] {
            
            var fetchQuery = query.select(distinct: [column])
            
            if let predicate {
                fetchQuery = fetchQuery.filter(predicate)
            }
            
            if order.notEmpty {
                fetchQuery = fetchQuery.order(order)
            }
            
            do {
                let queryResult = try db.prepare(fetchQuery)
                
                let result = queryResult.compactMap {
                    try? $0.get(column)
                }
                
                return result
            } catch {
                print(error.localizedDescription)
            }
            
            return []
        }
    
    func fetchDistinct<DataType: Value>(
        column: Expression<DataType>,
        query: SchemaType = Entity.schema,
        predicate: Expression<Bool>? = nil,
        orderBy order: [Expressible] = []) -> [DataType] {
            
            var fetchQuery = query.select(distinct: [column])
            
            if let predicate {
                fetchQuery = fetchQuery.filter(predicate)
            }
            
            if order.notEmpty {
                fetchQuery = fetchQuery.order(order)
            }
            
            do {
                let queryResult = try db.prepare(fetchQuery)
                
                let result = queryResult.compactMap {
                    try? $0.get(column)
                }
                
                return result
            } catch {
                print(error.localizedDescription)
            }
            
            return []
        }
}
