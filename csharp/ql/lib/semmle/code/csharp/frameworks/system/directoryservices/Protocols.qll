/** Provides definitions related to the namespace `System.DirectoryServices.Protocols`. */

import csharp
private import semmle.code.csharp.frameworks.system.DirectoryServices

/** The `System.DirectoryServices.Protocols` namespace. */
class SystemDirectoryServicesProtocolsNamespace extends Namespace {
  SystemDirectoryServicesProtocolsNamespace() {
    this.getParentNamespace() instanceof SystemDirectoryServicesNamespace and
    this.hasName("Protocols")
  }
}

/** A class in the `System.DirectoryServices.Protocols` namespace. */
class SystemDirectoryServicesProtocolsClass extends Class {
  SystemDirectoryServicesProtocolsClass() {
    this.getNamespace() instanceof SystemDirectoryServicesProtocolsNamespace
  }
}

/** The `System.DirectoryServices.Protocols.SearchRequest` class. */
class SystemDirectoryServicesProtocolsSearchRequest extends SystemDirectoryServicesProtocolsClass {
  SystemDirectoryServicesProtocolsSearchRequest() { this.hasName("SearchRequest") }
}
