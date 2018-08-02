/** Provides definitions related to the namespace `System.Threading`. */
import csharp
private import semmle.code.csharp.frameworks.System

/** The `System.Threading` namespace. */
class SystemThreadingNamespace extends Namespace {
  SystemThreadingNamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("Threading")
  }
}

/** DEPRECATED. Gets the `System.Threading` namespace. */
deprecated
SystemThreadingNamespace getSystemThreadingNamespace() { any() }
