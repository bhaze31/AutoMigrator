//
//  AutoMigration.swift
//  
//
//  Created by Brian Hasenstab on 9/15/21.
//

import Fluent

/// AutoMigration is a class that allows us to dynamically load all migrations in a certain directory. It does this by conforming to the Migration protocol, allowing us to add it to app.migrations. It then overrides certain properties that Migration uses to add the migration to the database, forcing us in our subclasses to actually define them.
public class AutoMigration: Migration {
    public var name: String {
        fatalError("Must define name of AutoMigration in subclass")
    }
    
    public var defaultName: String {
        fatalError("Must define defaultName of AutoMigration in subclass")
    }
    
    public func prepare(on database: Database) -> EventLoopFuture<Void> {
        fatalError("Subclass must override prepare")
    }
    
    public func revert(on database: Database) -> EventLoopFuture<Void> {
        fatalError("Subclass must override revert")
    }
    
    required init() {}
}
