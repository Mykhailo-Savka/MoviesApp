//
//  DatabaseService.swift
//  MoviesApp
//
//  Created by Savka Mykhailo on 30.03.2023.
//

import Foundation
import RealmSwift

// MARK: - DatabaseServiceProtocol
protocol DatabaseServiceProtocol {
    associatedtype EntityType
    
    func getObjects() -> [EntityType]
    func add(object: EntityType)
    func delete(object: EntityType)
    func edit(_ block: @escaping () -> Void)
}

// MARK: - DatabaseService
final class DatabaseService<T: Object>: DatabaseServiceProtocol {
    
    // MARK: - Private properties
    private var realm: Realm {
        return try! Realm()
    }
    private var databaseServiceQueue: DispatchQueue
    
    // MARK: - Lifecycle
    init() {
        databaseServiceQueue = DispatchQueue(label: "databaseServiceQueue", qos: .background, attributes: .concurrent)
    }
    
    // MARK: - Public methods
    func getObjects() -> [T] {
        var objects: [T]!
        databaseServiceQueue.sync {
            objects = realm.objects(T.self).map { $0 }
        }
        return objects
    }
    
    func add(object: T) {
        self.edit {
            self.realm.add(object)
        }
    }
    
    func delete(object: T) {
        self.edit {
            self.realm.delete(object)
        }
    }
    
    func edit(_ block: @escaping () -> Void) {
        try! realm.write {
            block()
        }
    }
}
