/**
 * Tool to generate C# stubs from a qltest snapshot.
 */

import csharp
import Stubs

/** All public declarations from assemblies. */
class AllExternalPublicDeclarations extends GeneratedDeclaration {
  AllExternalPublicDeclarations() { this.fromLibrary() }
}

from Assembly a
select a.getFullName(), a.getName(), a.getVersion().toString(), a.getFile().getAbsolutePath(),
  generatedCode(a)
