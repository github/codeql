/**
 * Tool to generate C# stubs from a qltest snapshot.
 */

import csharp
import Stubs

/** All public declarations from assemblies. */
class AllExternalPublicDeclarations extends GeneratedDeclaration {
  AllExternalPublicDeclarations() { this.fromLibrary() }
}

/** All framework assemblies. */
class NonTargetAssembly extends ExcludedAssembly {
  NonTargetAssembly() {
    exists(this.getFile().getAbsolutePath().indexOf("Microsoft.NETCore.App.Ref"))
  }
}

from Assembly a
select a, generatedCode(a)
