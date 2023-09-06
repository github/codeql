/**
 * @name Uncontrolled file decompression
 * @description Uncontrolled decompressionwithout checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id cs/user-controlled-file-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import csharp
import semmle.code.csharp.security.dataflow.flowsources.Remote

/**
 * A data flow source for unsafe Decompression extraction.
 */
abstract class DecompressionSource extends DataFlow::Node { }

/**
 * A data flow sink for unsafe zip extraction.
 */
abstract class DecompressionSink extends DataFlow::Node { }

class ZipFile extends DecompressionSource {
  ZipFile() {
    exists(MethodCall mc |
      (
        mc.getTarget().hasQualifiedName("System.IO.Compression", "ZipFile", "Open") and
        this.asExpr() = mc.getArgument(0) and
        mc.getArgument(1) =
          any(EnumConstant e |
            e.hasQualifiedName("System.IO.Compression", "ZipArchiveMode", ["Update", "Read"])
          ).getAnAccess()
        or
        mc.getTarget().hasQualifiedName("System.IO.Compression", "ZipFile", "OpenRead") and
        this.asExpr() = mc.getArgument(0)
      ) and
      not mc.getArgument(0).getType().isConst()
    )
  }
}

/** A path argument to a call to the `ZipArchive` constructor call. */
class ZipArchive extends DecompressionSource {
  ZipArchive() {
    exists(Constructor c |
      c.getDeclaringType().hasQualifiedName("System.IO.Compression", "ZipArchive")
    |
      this.asExpr() = c.getACall() and
      not c.getACall().getArgument(0).getType().isConst() and
      c.getACall().getArgument(1) =
        any(EnumConstant e |
          e.hasQualifiedName("System.IO.Compression", "ZipArchiveMode", ["Update", "Read"])
        ).getAnAccess()
    )
  }
}

/** A Qualifier of the `Open()` method. */
class ZipArchiveEntry extends DecompressionSink {
  ZipArchiveEntry() {
    exists(MethodCall mc |
      mc.getTarget().hasQualifiedName("System.IO.Compression", "ZipArchiveEntry", "Open") and
      this.asExpr() = mc.getQualifier()
    )
  }
}

/** A Caller of the `ExtractToFile` method. */
class ZipFileExtensionsCallSink extends DecompressionSink {
  ZipFileExtensionsCallSink() {
    exists(MethodCall mc |
      mc.getTarget().hasQualifiedName("System.IO.Compression", "ZipFileExtensions", "ExtractToFile") and
      this.asExpr() = mc.getArgumentForName("source") and
      mc.getArgumentForName("source")
          .getType()
          .hasQualifiedName("System.IO.Compression", "ZipArchiveEntry")
      or
      mc.getTarget()
          .hasQualifiedName("System.IO.Compression", "ZipFileExtensions", "ExtractToDirectory") and
      this.asExpr() = mc.getArgumentForName("source") and
      mc.getArgumentForName("source")
          .getType()
          .hasQualifiedName("System.IO.Compression", "ZipArchive")
    )
  }
}

/** A Call to the `GZipStream` first arugument of Constructor Call . */
class GZipStreamSink extends DecompressionSink, DecompressionSource {
  GZipStreamSink() {
    exists(Constructor mc |
      mc.getDeclaringType().hasQualifiedName("System.IO.Compression", "GZipStream") and
      this.asExpr() = mc.getACall().getArgument(0) and
      mc.getACall().getArgument(1) =
        any(EnumConstant e |
          e.hasQualifiedName("System.IO.Compression", "CompressionMode", "Decompress")
        ).getAnAccess()
    )
  }
}

/** A Call to the `BrotliStream` first arugument of Constructor Call . */
class BrotliStreamSink extends DecompressionSink, DecompressionSource {
  BrotliStreamSink() {
    exists(Constructor mc |
      mc.getDeclaringType().hasQualifiedName("System.IO.Compression", "BrotliStream") and
      this.asExpr() = mc.getACall().getArgument(0) and
      mc.getACall().getArgument(1) =
        any(EnumConstant e |
          e.hasQualifiedName("System.IO.Compression", "CompressionMode", "Decompress")
        ).getAnAccess()
    )
  }
}

/** A Call to the `BrotliStream` first arugument of Constructor Call . */
class DeflateStreamSink extends DecompressionSink, DecompressionSource {
  DeflateStreamSink() {
    exists(Constructor mc |
      mc.getDeclaringType().hasQualifiedName("System.IO.Compression", "DeflateStream") and
      this.asExpr() = mc.getACall().getArgument(0) and
      mc.getACall().getArgument(1) =
        any(EnumConstant e |
          e.hasQualifiedName("System.IO.Compression", "CompressionMode", "Decompress")
        ).getAnAccess()
    )
  }
}

/** A Call to the `ZLibStream` first arugument of Constructor Call . */
class ZLibStreamSink extends DecompressionSink, DecompressionSource {
  ZLibStreamSink() {
    exists(Constructor mc |
      mc.getDeclaringType().hasQualifiedName("System.IO.Compression", "ZLibStream") and
      this.asExpr() = mc.getACall().getArgument(0) and
      mc.getACall().getArgument(1) =
        any(EnumConstant e |
          e.hasQualifiedName("System.IO.Compression", "CompressionMode", "Decompress")
        ).getAnAccess()
    )
  }
}

class SharpZipLibType extends RefType {
  SharpZipLibType() {
    this.hasQualifiedName("ICSharpCode.SharpZipLib.Zip", "ZipInputStream") or
    this.hasQualifiedName("ICSharpCode.SharpZipLib.BZip2", "BZip2InputStream") or
    this.hasQualifiedName("ICSharpCode.SharpZipLib.GZip", "GZipInputStream") or
    this.hasQualifiedName("ICSharpCode.SharpZipLib.Lzw", "LzwInputStream") or
    this.hasQualifiedName("ICSharpCode.SharpZipLib.Tar", "TarInputStream") or
    this.hasQualifiedName("ICSharpCode.SharpZipLib.Zip.Compression.Streams", "InflaterInputStream")
  }
}

class SharpZipLibSource extends DecompressionSource {
  SharpZipLibSource() {
    exists(Constructor c |
      c.getDeclaringType() instanceof SharpZipLibType and
      this.asExpr() = c.getACall() and
      not c.getDeclaringType().hasQualifiedName("ICSharpCode.SharpZipLib.Tar", "TarInputStream")
    )
  }
}

class SharpZipLibDecompressionMethod extends MethodCall {
  SharpZipLibDecompressionMethod() {
    exists(string methodName |
      methodName =
        [
          "Read", "ReadAsync", "ReadAtLeast", "CopyToAsync", "CopyTo", "CopyEntryContentsAsync",
          "CopyEntryContents"
        ]
    |
      this.getTarget().hasQualifiedName("ICSharpCode.SharpZipLib.Zip", "ZipInputStream", methodName) or
      this.getTarget()
          .hasQualifiedName("ICSharpCode.SharpZipLib.BZip2", "BZip2InputStream", methodName) or
      this.getTarget()
          .hasQualifiedName("ICSharpCode.SharpZipLib.GZip", "GZipInputStream", methodName) or
      this.getTarget().hasQualifiedName("ICSharpCode.SharpZipLib.Lzw", "LzwInputStream", methodName) or
      this.getTarget().hasQualifiedName("ICSharpCode.SharpZipLib.Tar", "TarInputStream", methodName) or
      this.getTarget()
          .hasQualifiedName("ICSharpCode.SharpZipLib.Zip.Compression.Streams",
            "InflaterInputStream", methodName) or
      this.getTarget().hasQualifiedName("System.IO", "Stream", methodName)
    )
  }
}

class K4osLZ4Source extends DecompressionSource {
  K4osLZ4Source() { exists(K4osLZ4InitializeMethod ma | this.asExpr() = ma.getArgument(0)) }
}

class K4osLZ4InitializeMethod extends MethodCall {
  K4osLZ4InitializeMethod() {
    this.getTarget().hasQualifiedName("K4os.Compression.LZ4.Streams", "LZ4Stream", "Decode")
  }
}

class K4osLZ4DecompressionMethod extends MethodCall {
  K4osLZ4DecompressionMethod() {
    exists(string methodName | methodName = ["Read", "ReadAsync", "CopyToAsync", "CopyTo"] |
      this.getTarget()
          .hasQualifiedName("K4os.Compression.LZ4.Streams", "LZ4DecoderStream", methodName)
    )
  }
}

class K4osLZ4LibSink extends DecompressionSink {
  K4osLZ4LibSink() { exists(K4osLZ4DecompressionMethod mc | this.asExpr() = mc.getArgument(0)) }
}

class SharpZipLibSink extends DecompressionSink {
  SharpZipLibSink() {
    exists(SharpZipLibDecompressionMethod mc | this.asExpr() = mc.getArgument(0))
  }
}

class SharpZipLibFastZipSink extends DecompressionSink {
  SharpZipLibFastZipSink() {
    exists(MethodCall mc |
      mc.getTarget().hasQualifiedName("ICSharpCode.SharpZipLib.Zip", "ZipInputStream", "ExtractZip") and
      this.asExpr() = mc.getArgument(0)
    )
  }
}

/**
 * A taint tracking configuration for Decompression Bomb.
 */
private module DecompressionBombConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof DecompressionSource
    or
    source instanceof RemoteFlowSource
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof DecompressionSink }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // var node2 = node1.ExtractToFile("./output.txt", true)
    exists(MethodCall mc |
      mc.getTarget().hasQualifiedName("System.IO.Compression", "ZipFileExtensions", "ExtractToFile") and
      node2.asExpr() = mc and
      node1.asExpr() = mc.getArgumentForName("source")
    )
    or
    exists(MethodCall mc |
      mc.getTarget().hasQualifiedName("System.IO.Compression", "ZipArchive", "GetEntry") and
      node1.asExpr() = mc.getQualifier() and
      node2.asExpr() = mc
    )
    or
    // var node2 = node1.OpenReadStream()
    exists(MethodCall mc |
      mc.getTarget().hasQualifiedName("Microsoft.AspNetCore.Http", "IFormFile", "OpenReadStream") and
      node2.asExpr() = mc and
      node1.asExpr() = mc.getQualifier()
    )
    or
    exists(MethodCall mc, string methodName |
      methodName =
        [
          "Read", "ReadAsync", "ReadAtLeast", "CopyToAsync", "CopyTo", "CopyEntryContentsAsync",
          "CopyEntryContents"
        ]
    |
      (
        mc.getTarget().getDeclaringType() instanceof SharpZipLibType or
        mc.getTarget().hasQualifiedName("System.IO", "Stream", methodName)
      ) and
      node1.asExpr() = mc.getQualifier() and
      node2.asExpr() = mc.getArgument(0)
    )
    or
    exists(Constructor c |
      c.getDeclaringType() instanceof SharpZipLibType and
      node1.asExpr() = c.getACall().getArgument(0) and
      node2.asExpr() = c.getACall()
    )
    or
    exists(K4osLZ4DecompressionMethod mc |
      node1.asExpr() = mc.getQualifier() and
      node2.asExpr() = mc.getArgument(0)
    )
    or
    exists(K4osLZ4InitializeMethod mc |
      node2.asExpr() = mc and
      node1.asExpr() = mc.getArgument(0)
    )
  }
}

module DecompressionBomb = TaintTracking::Global<DecompressionBombConfig>;

import DecompressionBomb::PathGraph

from DecompressionBomb::PathNode source, DecompressionBomb::PathNode sink
where DecompressionBomb::flowPath(source, sink)
select sink.getNode(), source, sink, "This uncontrolled depends on a $@.", source.getNode(), "this"
