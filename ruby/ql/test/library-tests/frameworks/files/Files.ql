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

query predicate fileSystemReadAccesses(FileSystemReadAccess a) { any() }

query predicate fileSystemAccesses(FileSystemAccess a) { any() }

query predicate fileNameSources(FileNameSource s) { any() }

query predicate ioWriters(IO::IOWriter r) { any() }

query predicate fileWriters(IO::FileWriter r) { any() }

query predicate fileSystemWriteAccesses(FileSystemWriteAccess a) { any() }
