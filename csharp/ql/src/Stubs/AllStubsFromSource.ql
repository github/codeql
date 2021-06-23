/**
 * Tool to generate C# stubs from a qltest snapshot.
 */

import csharp
import Stubs

/** All public declarations from source. */
class AllDeclarations extends GeneratedDeclaration {
  AllDeclarations() { not this.fromLibrary() }
}

/** Exclude types from these standard assemblies. */
private class DefaultLibs extends ExcludedAssembly {
  DefaultLibs() {
    this.getName() = "System.Private.CoreLib" or
    this.getName() = "mscorlib" or
    this.getName() = "System.Runtime"
  }
}

select concat(generatedCode(_) + "\n\n")
