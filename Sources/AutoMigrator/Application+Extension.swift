//
//  Application+Extension.swift
//
//
//  Created by Brian Hasenstab on 9/15/21.
//

import Vapor

public extension Application {
    /// Attempts to create migration classes out of the file names in the migration folder. It does this by loading the file names, removing the .swift suffix, and attempting to instantiate a class based on that name using NSClassFromString.
    /// Since migrations run in alphabetical order, using migration names with a [Prefix][Timestamp]_[MigrationName] is
    /// recommended, as this will automatically load migrations in the order they were created. The method loadAutoMigrations assumes that the migrations are in a subfolder of the working directory using DirectoryConfiguration.detect().workingDirectory.
    ///
    /// For this to work properly, have your classes be subclasses of AutoMigration. The reason is that NSClassFromString returns AnyClass, and we need to cast it to a class that conforms to Migration in order to add to app.migrations. You also need to override the variables name and defaultName and the methods prepare and revert. This is necessary to prevent migration collisions in the fluent_migrations table, since we are only casting to AutoMigration, which would return the name AutoMigration for every migration name, regardless of the actual class that is loaded.
    ///
    /// - Parameters:
    ///   - path: Path where the migrations folder exists. Does not do folder traversal.
    ///   - namespace: Required to use NSClassFromString. Unless changed Vapor defaults to App
    ///   - prefix: Prefix for migrations. If prepending timestamps to class names to have migrations run in a proper order, a prefix is needed since classes cannot start with a number. Defaulted to 'M' as thats what I use as a default. Pass in an empty string if you want no prefixes to your migration files
    ///   - fatal: Will kill the application, preventing migrations from running, if any file in the migrations folder does not conform to the AutoMigration class. This is necessary to add the classes to app.migrations. The reason is we need to pass a type that has a required init, and overridden name and defaultName in order for migrations to run properly.
    func loadAutoMigrations(
        migrationsPath path: String = "Sources/App/Migrations",
        namespace: String = "App",
        migrationPrefix prefix: String = "M",
        fatalErrorOnInvalidClass fatal: Bool = false) {
        let fm = FileManager.default
        let directory = DirectoryConfiguration.detect()
        if let items = try? fm.contentsOfDirectory(atPath: directory.workingDirectory + path) {
            for item in items {
                let migration = item.split(separator: ".")[0]
                
                if let klass = NSClassFromString("\(namespace).\(prefix)\(migration)") as? AutoMigration.Type {
                    self.migrations.add(klass.init())
                } else {
                    if fatal {
                        fatalError("Non AutoMigration class in Migrations folder")
                    } else {
                        print("[XX] Invalid class \(migration) does not conform to AutoMigrate class")
                    }
                }
            }
        } else {
            if fatal {
                fatalError("Cannot load files in migrationsPath")
            } else {
                print("[XX] Could not load files at path \(directory.workingDirectory + path)")
            }
        }
    }
}
