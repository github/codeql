import csharp

module DecompressionBomb {
  /**
   * A data flow sink for unsafe zip extraction.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A data flow Additional step for unsafe zip extraction.
   */
  class AdditionalStep extends string {
    AdditionalStep() { this = "DecompressionBomb AdditionalStep" }

    abstract predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2);
  }
}

module SystemIoCompression {
  /** A `Open` method of ZipFile. */
  class ZipArchiveOpen extends MethodCall {
    ZipArchiveOpen() {
      exists(MethodCall c |
        c.getTarget().hasFullyQualifiedName("System.IO.Compression", "ZipFile", "Open") and
        this = c
      )
    }
  }

  /** A Call to `Open` method considered as Decompression Bomb sink. */
  class ZipArchiveEntryOpen extends DecompressionBomb::Sink {
    ZipArchiveEntryOpen() {
      exists(MethodCall c |
        c.getTarget().hasFullyQualifiedName("System.IO.Compression", "ZipArchiveEntry", "Open") and
        this.asExpr() = c
      )
    }
  }

  /** A Caller of the `ExtractToFile` method. */
  class ZipFileExtensionsCallSink extends DecompressionBomb::Sink {
    ZipFileExtensionsCallSink() {
      exists(MethodCall mc |
        mc.getTarget()
            .hasFullyQualifiedName("System.IO.Compression", "ZipFileExtensions", "ExtractToFile") and
        this.asExpr() = mc.getArgumentForName("source") and
        mc.getArgumentForName("source")
            .getType()
            .hasFullyQualifiedName("System.IO.Compression", "ZipArchiveEntry")
        or
        mc.getTarget()
            .hasFullyQualifiedName("System.IO.Compression", "ZipFileExtensions",
              "ExtractToDirectory") and
        this.asExpr() = mc.getArgumentForName("source") and
        mc.getArgumentForName("source")
            .getType()
            .hasFullyQualifiedName("System.IO.Compression", "ZipArchive")
      )
    }
  }

  /** A Call to the `GZipStream` first argument of Constructor Call . */
  class GZipStreamSink extends DecompressionBomb::Sink {
    GZipStreamSink() {
      exists(Constructor mc |
        mc.getDeclaringType().hasFullyQualifiedName("System.IO.Compression", "GZipStream") and
        this.asExpr() = mc.getACall().getArgument(0) and
        mc.getACall().getArgument(1) =
          any(EnumConstant e |
            e.hasFullyQualifiedName("System.IO.Compression", "CompressionMode", "Decompress")
          ).getAnAccess()
      )
    }
  }

  /** A Call to the `BrotliStream` first argument of Constructor Call . */
  class BrotliStreamSink extends DecompressionBomb::Sink {
    BrotliStreamSink() {
      exists(Constructor mc |
        mc.getDeclaringType().hasFullyQualifiedName("System.IO.Compression", "BrotliStream") and
        this.asExpr() = mc.getACall().getArgument(0) and
        mc.getACall().getArgument(1) =
          any(EnumConstant e |
            e.hasFullyQualifiedName("System.IO.Compression", "CompressionMode", "Decompress")
          ).getAnAccess()
      )
    }
  }

  /** A Call to the `BrotliStream` first argument of Constructor Call . */
  class DeflateStreamSink extends DecompressionBomb::Sink {
    DeflateStreamSink() {
      exists(Constructor mc |
        mc.getDeclaringType().hasFullyQualifiedName("System.IO.Compression", "DeflateStream") and
        this.asExpr() = mc.getACall().getArgument(0) and
        mc.getACall().getArgument(1) =
          any(EnumConstant e |
            e.hasFullyQualifiedName("System.IO.Compression", "CompressionMode", "Decompress")
          ).getAnAccess()
      )
    }
  }

  /** A Call to the `ZLibStream` first argument of Constructor Call . */
  class ZLibStreamSink extends DecompressionBomb::Sink {
    ZLibStreamSink() {
      exists(Constructor mc |
        mc.getDeclaringType().hasFullyQualifiedName("System.IO.Compression", "ZLibStream") and
        this.asExpr() = mc.getACall().getArgument(0) and
        mc.getACall().getArgument(1) =
          any(EnumConstant e |
            e.hasFullyQualifiedName("System.IO.Compression", "CompressionMode", "Decompress")
          ).getAnAccess()
      )
    }
  }

  class DecompressionAdditionalStep extends DecompressionBomb::AdditionalStep {
    override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      exists(MethodCall mc |
        mc.getTarget()
            .hasFullyQualifiedName("System.IO.Compression", "ZipFileExtensions", "ExtractToFile") and
        node2.asExpr() = mc and
        node1.asExpr() = mc.getArgumentForName("source")
      )
      or
      exists(MethodCall mc |
        mc.getTarget().hasFullyQualifiedName("System.IO.Compression", "ZipArchive", "GetEntry") and
        node1.asExpr() = mc.getQualifier() and
        node2.asExpr() = mc
      )
      or
      exists(Call mc |
        mc.getTarget()
            .getDeclaringType()
            .hasFullyQualifiedName("System.IO.Compression", "ZipArchive") and
        node1.asExpr() = mc.getArgument(0) and
        node2.asExpr() = mc
      )
      or
      exists(ZipArchiveOpen zo |
        node1.asExpr() = zo.getArgument(0) and
        node2.asExpr() = zo
      )
      or
      exists(MethodCall mc |
        mc.getTarget().hasFullyQualifiedName("System.IO.Compression", "ZipArchiveEntry", "Open")
      |
        node1.asExpr() = mc.getQualifier() and
        node2.asExpr() = mc
      )
    }
  }
}

module K4osLz4 {
  /** A Decode MethodCall of LZ4Stream */
  class K4osLZ4InitializeMethod extends MethodCall {
    K4osLZ4InitializeMethod() {
      this.getTarget().hasFullyQualifiedName("K4os.Compression.LZ4.Streams", "LZ4Stream", "Decode")
    }
  }

  /** The Methods responsible for reading Decompressed data */
  class K4osLZ4DecompressionMethod extends MethodCall {
    K4osLZ4DecompressionMethod() {
      exists(string methodName | methodName = ["Read", "ReadAsync", "CopyToAsync", "CopyTo"] |
        this.getTarget()
            .hasFullyQualifiedName("K4os.Compression.LZ4.Streams", "LZ4DecoderStream", methodName)
      )
    }
  }

  /** The first argument of LZ4DecoderStream decompression methods as decompression bomb sink */
  class K4osLZ4LibSink extends DecompressionBomb::Sink {
    K4osLZ4LibSink() { exists(K4osLZ4DecompressionMethod mc | this.asExpr() = mc.getArgument(0)) }
  }

  class DecompressionAdditionalStep extends DecompressionBomb::AdditionalStep {
    override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
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
}

/** The first argument of LZ4DecoderStream decompression methods as decompression bomb sink */
module SharpZip {
  class SharpZipLibType extends RefType {
    SharpZipLibType() {
      this.hasFullyQualifiedName("ICSharpCode.SharpZipLib.Zip", "ZipInputStream") or
      this.hasFullyQualifiedName("ICSharpCode.SharpZipLib.BZip2", "BZip2InputStream") or
      this.hasFullyQualifiedName("ICSharpCode.SharpZipLib.GZip", "GZipInputStream") or
      this.hasFullyQualifiedName("ICSharpCode.SharpZipLib.Lzw", "LzwInputStream") or
      this.hasFullyQualifiedName("ICSharpCode.SharpZipLib.Tar", "TarInputStream") or
      this.hasFullyQualifiedName("ICSharpCode.SharpZipLib.Zip.Compression.Streams",
        "InflaterInputStream")
    }
  }

  /** The methods for decompressing data */
  class SharpZipLibDecompressionMethod extends MethodCall {
    SharpZipLibDecompressionMethod() {
      exists(string methodName |
        methodName =
          [
            "Read", "ReadAsync", "ReadAtLeast", "CopyToAsync", "CopyTo", "CopyEntryContentsAsync",
            "CopyEntryContents"
          ]
      |
        this.getTarget()
            .hasFullyQualifiedName("ICSharpCode.SharpZipLib.Zip", "ZipInputStream", methodName) or
        this.getTarget()
            .hasFullyQualifiedName("ICSharpCode.SharpZipLib.BZip2", "BZip2InputStream", methodName) or
        this.getTarget()
            .hasFullyQualifiedName("ICSharpCode.SharpZipLib.GZip", "GZipInputStream", methodName) or
        this.getTarget()
            .hasFullyQualifiedName("ICSharpCode.SharpZipLib.Lzw", "LzwInputStream", methodName) or
        this.getTarget()
            .hasFullyQualifiedName("ICSharpCode.SharpZipLib.Tar", "TarInputStream", methodName) or
        this.getTarget()
            .hasFullyQualifiedName("ICSharpCode.SharpZipLib.Zip.Compression.Streams",
              "InflaterInputStream", methodName)
      )
    }
  }

  /** The first argument of SharpZipLib decompression methods as decompression bomb sink */
  class SharpZipLibSink extends DecompressionBomb::Sink {
    SharpZipLibSink() {
      exists(SharpZipLibDecompressionMethod mc | this.asExpr() = mc.getArgument(0))
    }
  }

  /** The `ExtractZip` first argument or method call considered as decompression sink bomb */
  class SharpZipLibFastZipSink extends DecompressionBomb::Sink {
    SharpZipLibFastZipSink() {
      exists(MethodCall mc |
        mc.getTarget()
            .hasFullyQualifiedName("ICSharpCode.SharpZipLib.Zip", "ZipInputStream", "ExtractZip") and
        this.asExpr() = mc.getArgument(0)
      )
    }
  }

  class DecompressionAdditionalStep extends DecompressionBomb::AdditionalStep {
    override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
      exists(MethodCall mc, string methodName |
        methodName =
          [
            "Read", "ReadAsync", "ReadAtLeast", "CopyToAsync", "CopyTo", "CopyEntryContentsAsync",
            "CopyEntryContents"
          ]
      |
        (
          mc.getTarget().getDeclaringType() instanceof SharpZipLibType or
          mc.getTarget().hasFullyQualifiedName("System.IO", "Stream", methodName)
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
    }
  }
}
