/** Provides definitions related to the namespace `System.DirectoryServices`. */

import csharp
private import semmle.code.csharp.frameworks.System

/** The `System.DirectoryServices` namespace. */
class SystemDirectoryServicesNamespace extends Namespace {
  SystemDirectoryServicesNamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("DirectoryServices")
  }
}

/** A class in the `System.DirectoryServices` namespace. */
class SystemDirectoryServicesClass extends Class {
  SystemDirectoryServicesClass() { this.getNamespace() instanceof SystemDirectoryServicesNamespace }
}

/** The `System.DirectoryServices.DirectorySearcher` class. */
class SystemDirectoryServicesDirectorySearcherClass extends SystemDirectoryServicesClass {
  SystemDirectoryServicesDirectorySearcherClass() { this.hasName("DirectorySearcher") }
}

/** The `System.DirectoryServices.DirectoryEntry` class. */
class SystemDirectoryServicesDirectoryEntryClass extends SystemDirectoryServicesClass {
  SystemDirectoryServicesDirectoryEntryClass() { this.hasName("DirectoryEntry") }
}
