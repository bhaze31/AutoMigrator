//
//  AutoMigration.swift
//  
//
//  Created by Brian Hasenstab on 9/15/21.
//

import Fluent

/// AutoMigration is a class that allows us to dynamically load all migrations in a certain directory. It does this by conforming to the Migration protocol, allowing us to add it to app.migrations. It then overrides certain properties that Migration uses to add the migration to the database, forcing us in our subclasses to actually define them.
open class AutoMigration: Migration {
    open var name: String {
        fatalError("Must define name of AutoMigration in subclass")
    }
    
    open var defaultName: String {
        fatalError("Must define defaultName of AutoMigration in subclass")
    }
    
    open func prepare(on database: Database) -> EventLoopFuture<Void> {
        fatalError("Subclass must override prepare")
    }
    
    open func revert(on database: Database) -> EventLoopFuture<Void> {
        fatalError("Subclass must override revert")
    }
    
    required public init() {}
}

open class AsyncAutoMigration: AsyncMigration {
    open func prepare(on database: Database) async throws {
        fatalError("Subclass must override prepare")
    }
    
    open func revert(on database: Database) async throws {
        fatalError("Subclass must override revert")
    }
    
    open var name: String {
        fatalError("Must define name of AutoMigration in subclass")
    }
    
    open var defaultName: String {
        fatalError("Must define defaultName of AutoMigration in subclass")
    }
    
    required public init() {}
}
