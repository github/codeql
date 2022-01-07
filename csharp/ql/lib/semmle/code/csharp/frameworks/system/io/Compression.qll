/** Provides definitions related to the namespace `System.IO.Compression`. */

import csharp
private import semmle.code.csharp.frameworks.system.IO
private import semmle.code.csharp.dataflow.ExternalFlow

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

/** Data flow for `System.IO.Compression.DeflateStream`. */
private class SystemIOCompressionDeflateStreamFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.IO.Compression;DeflateStream;false;DeflateStream;(System.IO.Stream,System.IO.Compression.CompressionLevel);;Argument[0];ReturnValue;taint",
        "System.IO.Compression;DeflateStream;false;DeflateStream;(System.IO.Stream,System.IO.Compression.CompressionLevel,System.Boolean);;Argument[0];ReturnValue;taint",
        "System.IO.Compression;DeflateStream;false;DeflateStream;(System.IO.Stream,System.IO.Compression.CompressionMode);;Argument[0];ReturnValue;taint",
        "System.IO.Compression;DeflateStream;false;DeflateStream;(System.IO.Stream,System.IO.Compression.CompressionMode,System.Boolean);;Argument[0];ReturnValue;taint"
      ]
  }
}
