//
//  SWSQLBase.swift
//  SWSQLite
//
//  Created by Supernova SanDick SSD on 2019/6/20.
//  Copyright © 2019 Seven. All rights reserved.
//

import Foundation
import SQLite
public class SWSQLBase {
    public static let `default` = SWSQLBase()
    public var dataPath: String? {
        guard let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else { return nil }
        return path + "/db.sqlite3"
    }
    public lazy var dataBase: Connection? = {
        return SWSQLBase.default.createDataBase()
    }()
    private func createDataBase() -> Connection? {
        do {
            guard let path = dataPath else { return nil }
            let db = try Connection(path)
            return db
        } catch {
            let err = error as NSError
            print("\(#function)\n\(err.domain)")
            return nil
        }
    }
    fileprivate func deleteDataBase() -> () {
        guard let path = dataPath else { return }
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            do {
                try fileManager.removeItem(atPath: path)
            } catch {
                print("remove data base failure")
            }
        }
    }
    
}
extension SWSQLBase {
    public func disposeDataBase() -> () {
        let key = "CFBundleVersion"
        guard let currentBuild = Bundle.main.infoDictionary?[key] as? String else {
            deleteDataBase()
            return
        }
        let userDefaults = UserDefaults.standard
        
        guard let build:String = userDefaults.string(forKey: "key"), build == currentBuild else {
            deleteDataBase()
            userDefaults.set(currentBuild, forKey: key)
            userDefaults.synchronize()
            return
        }
    }
}


