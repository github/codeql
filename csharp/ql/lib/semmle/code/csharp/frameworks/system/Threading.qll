/** Provides definitions related to the namespace `System.Threading`. */
overlay[local?]
module;

import csharp
private import semmle.code.csharp.frameworks.System

/** The `System.Threading` namespace. */
class SystemThreadingNamespace extends Namespace {
  SystemThreadingNamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("Threading")
  }
}
