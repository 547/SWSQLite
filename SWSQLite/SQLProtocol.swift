//
//  SQLProtocol.swift
//  iFoodMacau-Delivery
//
//  Created by seven on 2017/8/13.
//  Copyright © 2017年 Supernova Software. All rights reserved.
//

import Foundation
import SQLite
public protocol SQLProtocol {
    var sqlBase:SQLBase {get}
    var tableName:String? {get set}
    var table:Table? {get set}
    func createTable() -> Table?
}
extension SQLProtocol {
    public var sqlBase: SQLBase{
        return SQLBase.default
    }
}
extension SQLProtocol {
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

