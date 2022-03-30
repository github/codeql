/**
 * Tool to generate C# stubs from a qltest snapshot.
 *
 * It finds all declarations used in the source code,
 * and generates minimal C# stubs containing those declarations
 * and their dependencies.
 */

import csharp
import Stubs

/** Declarations used by source code. */
class UsedInSource extends GeneratedDeclaration {
  UsedInSource() {
    (
      this = any(Access a).getTarget()
      or
      this = any(Call c).getTarget()
      or
      this = any(TypeMention tm).getType()
      or
      exists(Virtualizable v | v.fromSource() |
        this = v.getImplementee() or this = v.getOverridee()
      )
      or
      this = any(Attribute a).getType().getAConstructor()
    ) and
    this.fromLibrary()
  }
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
