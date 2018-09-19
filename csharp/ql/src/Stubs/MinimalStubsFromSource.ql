/*
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
      exists(ValueOrRefType t | t.fromSource() | this = t.getABaseType())
      or
      exists(Variable v | v.fromSource() | this = v.getType())
      or
      exists(Virtualizable v | v.fromSource() | this = v.getImplementee() or this = v.getOverridee())
    )
    and
    this.fromLibrary()
  }
}

select generatedCode()
