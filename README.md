# AutoMigrator

An extension to Swift Vapor applications that allows migrations to be automatically added to the application, removing the repetitive task of needing to add each one manually.

## How it works

There are two parts to the package:
* Application Extension
* AutoMigration class

The extension adds a method to the Application class called loadAutoMigration. That method loads a directory that includes the migrations and attempts to dynamically load migrations using NSClassFromString. It gets the class names using the name of the file, which in turn means that the name of the Migration class should be the same as the file name itself, barring a prefix (see 1234_Migration in Application Extension piece below).
Each of these Migration classes should be subclasses of the second part of the package, AutoMigration. AutoMigration conforms to the protocol Migration, allowing it to be added to the app through app.migrations.add(). However, it also overrides the variables for name and displayName, along with prepare and revert. The reason for this is that Fluent prevents migration names from conflicting and should be the same as the default name. However, since we dynamically are loading all of these Migration classes as AutoMigration, every Migration name would be Bundle.AutoMigration, resulting in conflicts.
By overriding the name and defaultName classes, we ensure we prevent the naming issues by giving them the same values, and the AutoMigration class has fatalError in these values if they are not overwritten by the subclasses.

## Application Extension

The extension by default looks in the working directory using DirectoryConfiguration from Vapor, which means with a basic setup it is looking in the base folder. Currently, the extension will not search anywhere outside this directory. Therefore the default location searched, which can be changed by supplying the migrationsPath parameter, is Sources/App/Migrations. This will then pick up all files in the directory non-recursively (although there are plans to support this) and load them all by name.
As an example, if the file name is 1234_MigrationABC.swift, it will attempt to load a class named 1234_MigrationABC.swift. However, since classes must start with a letter and not a number, a prefix can be supplied using the migrationPrefix parameter, which defaults to M. The reason it defaults to this is that I currently use timestamps to prefix my filenames (with a cli, to be released) with a timestamp and make my classes the same timestamp. Since Fluent loads migration in alphabetical order this keeps them in the correct order they were generated in. However if you choose to not use numbers, you can pass in an empty value for migrationPrefix, which will then only use the file name.
NSClassFromString also requires that the namespace be supplied. By default for Vapor applications this is App, but if you use another format (you can check this by going into your dbconsole for a current application and looking in your fluent_migrations table. It too uses the namespace name for the migration name) you can supply this using the namespace parameter.
Finally, if the extension encounters a non AutoMigration class in that directory or cannot load the files you can optionally have it call a fatalError. This will allow the migrations to stop running and displaying the reason for the failure.

## AutoMigration

The AutoMigration class is only needed as we cannot use a protocol with NSClassFromString. As mentioned above, this allows us to dynamically load any migration that is needed since it will have the proper type to be added to app.migrations. It also adds a required init method which is necessary so the return type from NSClassFromString can be initialized.
However, you do not need to backfill all of your migrations to add this extension. By default, application extension ignores any class that is not a subclass of AutoMigraiton. Therefore, you can start adding your own AutoMigration classes and not worry about old migrations. However, if you want to backfill these classes, you need to ensure that there is an overwritten name and defaultName variables in the classes. These should correspond to what the migrations are called in the current fluent_migrations table or they will be attempted again, and will fail due to those tables/columns/etc already existing.

## License

There is none, use it, change it, do whatever you like with it.

## Authors

[Brian Hasenstab](https://github.com/bhaze31)
