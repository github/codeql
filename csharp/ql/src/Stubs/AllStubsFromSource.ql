/**
 * Tool to generate C# stubs from a qltest snapshot.
 */

import csharp
import Stubs

/** All public declarations from source. */
class AllDeclarations extends GeneratedDeclaration {
  AllDeclarations() { not this.fromLibrary() }
}

select concat(generatedCode(_) + "\n\n")
