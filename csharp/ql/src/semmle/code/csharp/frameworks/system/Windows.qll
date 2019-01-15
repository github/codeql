/** Provides definitions related to the namespace `System.Windows`. */

import csharp
private import semmle.code.csharp.frameworks.System

/** The `System.Windows` namespace. */
class SystemWindowsNamespace extends Namespace {
  SystemWindowsNamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("Windows")
  }
}

/** A class in the `System.Windows` namespace. */
class SystemWindowsClass extends Class {
  SystemWindowsClass() { this.getNamespace() instanceof SystemWindowsNamespace }
}
