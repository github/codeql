/** Provides definitions related to `System.IO.StreamReader`. */

import csharp
private import semmle.code.csharp.frameworks.system.IO

/** The `System.IO.StreamReader` class. */
class SystemIOStreamReader extends SystemIOClass {
  SystemIOStreamReader() { this.hasName("StreamReader") }
}
