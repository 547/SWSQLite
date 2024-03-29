//
//  SWSQLProtocol.swift
//  SWSQLite
//
//  Created by Supernova SanDick SSD on 2019/6/20.
//  Copyright © 2019 Seven. All rights reserved.
//

import Foundation
import SQLite
public protocol SWSQLProtocol {
    var sqlBase:SWSQLBase {get}
    var tableName:String? {get set}
    var table:Table? {get set}
    func createTable() -> Table?
}
extension SWSQLProtocol {
    public var sqlBase: SWSQLBase{
        return SWSQLBase.default
    }
}
extension SWSQLProtocol {
    @discardableResult
    public func add(inster:Insert) -> Int? {
        guard let db = sqlBase.dataBase else { return nil }
        do {
            let rowId = try db.run(inster)
            return Int(rowId)
        } catch {
            let err = error as NSError
            print("\(#function)\n\(err.domain)")
        }
        return nil
    }
    public func clear(delete:Delete) -> () {
        self.delete(del: delete)
    }
    public func prepare(table:Table) -> AnySequence<Row>? {
        guard let db = sqlBase.dataBase else { return nil }
        do {
            let prepareResult = try db.prepare(table)
            return prepareResult
        } catch {
            let err = error as NSError
            print("\(#function)\n\(err.domain)")
        }
        return nil
    }
    public func delete(del:Delete) -> () {
        guard let db = sqlBase.dataBase else { return }
        do {
            try db.run(del)
        } catch {
            let err = error as NSError
            print("\(#function)\n\(err.domain)")
        }
    }
    public func update(up:Update) -> () {
        guard let db = sqlBase.dataBase else { return }
        do {
            try db.run(up)
        } catch {
            let err = error as NSError
            print("\(#function)\n\(err.domain)")
        }
    }
    public func scalar(table:Table) -> Int {
        var result = 0
        guard let db = sqlBase.dataBase else { return result }
        do {
           result = try db.scalar(table.count)
        } catch {
            let err = error as NSError
            print("\(#function)\n\(err.domain)")
        }
        return result
    }
}

