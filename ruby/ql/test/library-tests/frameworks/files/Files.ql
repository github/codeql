private import ruby
private import codeql.ruby.frameworks.Files
private import codeql.ruby.Concepts

query predicate fileInstances(File::FileInstance i) { any() }

query predicate ioInstances(IO::IOInstance i) { any() }

query predicate fileModuleReaders(File::FileModuleReader r) { any() }

query predicate ioReaders(IO::IOReader r) { any() }

query predicate fileReaders(IO::FileReader r) { any() }

query predicate fileModuleFilenameSources(File::FileModuleFilenameSource s) { any() }

query predicate fileUtilsFilenameSources(FileUtils::FileUtilsFilenameSource s) { any() }

query predicate fileSystemReadAccesses(FileReadAccess a) { any() }

query predicate fileSystemAccesses(FileAccess a) { any() }

query predicate fileNameSources(FileNameSource s) { any() }

query predicate ioWriters(IO::IOWriter r) { any() }

query predicate fileWriters(IO::FileWriter r) { any() }

query predicate fileSystemWriteAccesses(FileWriteAccess a) { any() }
