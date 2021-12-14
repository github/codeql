/** Provides definitions related to the namespace `System.IO.Compression`. */

import csharp
private import semmle.code.csharp.frameworks.system.IO

/** The `System.IO.Compression` namespace. */
class SystemIOCompressionNamespace extends Namespace {
  SystemIOCompressionNamespace() {
    this.getParentNamespace() instanceof SystemIONamespace and
    this.hasName("Compression")
  }
}

/** A class in the `System.IO.Compression` namespace. */
class SystemIOCompressionClass extends Class {
  SystemIOCompressionClass() { this.getNamespace() instanceof SystemIOCompressionNamespace }
}

/** The `System.IO.Compression.DeflateStream` class. */
class SystemIOCompressionDeflateStream extends SystemIOCompressionClass {
  SystemIOCompressionDeflateStream() { this.hasName("DeflateStream") }
}
