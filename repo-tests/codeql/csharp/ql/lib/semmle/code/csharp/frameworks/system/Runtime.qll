/** Provides definitions related to the namespace `System.Runtime`. */

import csharp
private import semmle.code.csharp.frameworks.System

/** The `System.Runtime` namespace. */
class SystemRuntimeNamespace extends Namespace {
  SystemRuntimeNamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("Runtime")
  }
}
