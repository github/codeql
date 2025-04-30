deprecated module;

import java
private import semmle.code.java.dataflow.TaintTracking

module DecompressionBomb {
  /**
   * The Decompression bomb Sink
   *
   * Extend this class for creating new decompression bomb sinks
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * The Additional flow steps that help to create a dataflow or taint tracking query
   *
   * Extend this class for creating new additional taint steps
   */
  class AdditionalStep extends Unit {
    abstract predicate step(DataFlow::Node n1, DataFlow::Node n2);
  }

  abstract class BombReadInputStreamCall extends MethodCall { }

  private class ReadInputStreamQualifierSink extends DecompressionBomb::Sink {
    ReadInputStreamQualifierSink() { this.asExpr() = any(BombReadInputStreamCall r).getQualifier() }
  }
}

/**
 * Providing Decompression sinks and additional taint steps for `org.xerial.snappy` package
 */
module XerialSnappy {
  /**
   * A type that is responsible for `SnappyInputStream` Class
   */
  class TypeInputStream extends RefType {
    TypeInputStream() {
      this.getASupertype*().hasQualifiedName("org.xerial.snappy", "SnappyInputStream")
    }
  }

  /**
   * The methods that read bytes and belong to `SnappyInputStream` Types
   */
  class ReadInputStreamCall extends DecompressionBomb::BombReadInputStreamCall {
    ReadInputStreamCall() {
      this.getReceiverType() instanceof TypeInputStream and
      this.getCallee().hasName(["read", "readNBytes", "readAllBytes"])
    }
  }

  /**
   * Gets `n1` and `n2` which `SnappyInputStream n2 = new SnappyInputStream(n1)` or
   * `n1.read(n2)`,
   *  second one is added because of sanitizer, we want to compare return value of each `read` or similar method
   *  that whether there is a flow to a comparison between total read of decompressed stream and a constant value
   */
  private class InputStreamAdditionalTaintStep extends DecompressionBomb::AdditionalStep {
    override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
      exists(ConstructorCall call |
        call.getCallee().getDeclaringType() instanceof TypeInputStream and
        call.getArgument(0) = n1.asExpr() and
        call = n2.asExpr()
      )
    }
  }
}

/**
 * Providing Decompression sinks and additional taint steps for `org.apache.commons.compress` package
 */
module ApacheCommons {
  /**
   * A type that is responsible for `ArchiveInputStream` Class
   */
  class TypeArchiveInputStream extends RefType {
    TypeArchiveInputStream() {
      this.getASupertype*()
          .hasQualifiedName("org.apache.commons.compress.archivers", "ArchiveInputStream")
    }
  }

  /**
   * A type that is responsible for `CompressorInputStream` Class
   */
  class TypeCompressorInputStream extends RefType {
    TypeCompressorInputStream() {
      this.getASupertype*()
          .hasQualifiedName("org.apache.commons.compress.compressors", "CompressorInputStream")
    }
  }

  /**
   * Providing Decompression sinks and additional taint steps for `org.apache.commons.compress.compressors.*` Types
   */
  module Compressors {
    /**
     * The types that are responsible for specific compression format of `CompressorInputStream` Class
     */
    class TypeCompressors extends RefType {
      TypeCompressors() {
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.compressors.gzip",
              "GzipCompressorInputStream") or
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.compressors.brotli",
              "BrotliCompressorInputStream") or
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.compressors.bzip2",
              "BZip2CompressorInputStream") or
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.compressors.deflate",
              "DeflateCompressorInputStream") or
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.compressors.deflate64",
              "Deflate64CompressorInputStream") or
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.compressors.lz4",
              "BlockLZ4CompressorInputStream") or
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.compressors.lzma",
              "LZMACompressorInputStream") or
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.compressors.pack200",
              "Pack200CompressorInputStream") or
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.compressors.snappy",
              "SnappyCompressorInputStream") or
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.compressors.xz",
              "XZCompressorInputStream") or
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.compressors.z", "ZCompressorInputStream") or
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.compressors.zstandard",
              "ZstdCompressorInputStream")
      }
    }

    /**
     * The methods that read bytes and belong to `*CompressorInputStream` Types
     */
    class ReadInputStreamCall extends DecompressionBomb::BombReadInputStreamCall {
      ReadInputStreamCall() {
        this.getReceiverType() instanceof TypeCompressors and
        this.getCallee().hasName(["read", "readNBytes", "readAllBytes"])
      }
    }

    /**
     * Gets `n1` and `n2` which `GzipCompressorInputStream n2 = new GzipCompressorInputStream(n1)`
     */
    private class CompressorsAndArchiversAdditionalTaintStep extends DecompressionBomb::AdditionalStep
    {
      override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
        exists(ConstructorCall call |
          call.getCallee().getDeclaringType() instanceof TypeCompressors and
          call.getArgument(0) = n1.asExpr() and
          call = n2.asExpr()
        )
      }
    }
  }

  /**
   * Providing Decompression sinks and additional taint steps for Types from `org.apache.commons.compress.archivers.*` packages
   */
  module Archivers {
    /**
     * The types that are responsible for specific compression format of `ArchiveInputStream` Class
     */
    class TypeArchivers extends RefType {
      TypeArchivers() {
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.archivers.ar", "ArArchiveInputStream") or
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.archivers.arj", "ArjArchiveInputStream") or
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.archivers.cpio", "CpioArchiveInputStream") or
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.archivers.ar", "ArArchiveInputStream") or
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.archivers.jar", "JarArchiveInputStream") or
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.archivers.zip", "ZipArchiveInputStream")
      }
    }

    /**
     * The methods that read bytes and belong to `*ArchiveInputStream` Types
     */
    class ReadInputStreamCall extends DecompressionBomb::BombReadInputStreamCall {
      ReadInputStreamCall() {
        this.getReceiverType() instanceof TypeArchivers and
        this.getCallee().hasName(["read", "readNBytes", "readAllBytes"])
      }
    }

    /**
     * Gets `n1` and `n2` which `CompressorInputStream n2 = new CompressorStreamFactory().createCompressorInputStream(n1)`
     * or `ArchiveInputStream n2 = new ArchiveStreamFactory().createArchiveInputStream(n1)` or
     * `n1.read(n2)`,
     * second one is added because of sanitizer, we want to compare return value of each `read` or similar method
     * that whether there is a flow to a comparison between total read of decompressed stream and a constant value
     */
    private class CompressorsAndArchiversAdditionalTaintStep extends DecompressionBomb::AdditionalStep
    {
      override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
        exists(ConstructorCall call |
          call.getCallee().getDeclaringType() instanceof TypeArchivers and
          call.getArgument(0) = n1.asExpr() and
          call = n2.asExpr()
        )
      }
    }
  }

  /**
   * Providing Decompression sinks and additional taint steps for `CompressorStreamFactory` and `ArchiveStreamFactory` Types
   */
  module Factory {
    /**
     * A type that is responsible for `ArchiveInputStream` Class
     */
    class TypeArchivers extends RefType {
      TypeArchivers() {
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.archivers", "ArchiveStreamFactory")
      }
    }

    /**
     * A type that is responsible for `CompressorStreamFactory` Class
     */
    class TypeCompressors extends RefType {
      TypeCompressors() {
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.compressors", "CompressorStreamFactory")
      }
    }

    /**
     * Gets `n1` and `n2` which `ZipInputStream n2 = new ZipInputStream(n1)`
     */
    private class CompressorsAndArchiversAdditionalTaintStep extends DecompressionBomb::AdditionalStep
    {
      override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
        exists(MethodCall call |
          (
            call.getCallee().getDeclaringType() instanceof TypeCompressors
            or
            call.getCallee().getDeclaringType() instanceof TypeArchivers
          ) and
          call.getArgument(0) = n1.asExpr() and
          call = n2.asExpr()
        )
      }
    }

    /**
     * The methods that read bytes and belong to `CompressorInputStream` or `ArchiveInputStream` Types
     */
    class ReadInputStreamCall extends DecompressionBomb::BombReadInputStreamCall {
      ReadInputStreamCall() {
        (
          this.getReceiverType() instanceof TypeArchiveInputStream
          or
          this.getReceiverType() instanceof TypeCompressorInputStream
        ) and
        this.getCallee().hasName(["read", "readNBytes", "readAllBytes"])
      }
    }
  }
}

/**
 * Providing Decompression sinks and additional taint steps for `net.lingala.zip4j.io` package
 */
module Zip4j {
  /**
   * A type that is responsible for `ZipInputStream` Class
   */
  class TypeZipInputStream extends RefType {
    TypeZipInputStream() {
      this.hasQualifiedName("net.lingala.zip4j.io.inputstream", "ZipInputStream")
    }
  }

  /**
   * The methods that read bytes and belong to `CompressorInputStream` or `ArchiveInputStream` Types
   */
  class ReadInputStreamCall extends DecompressionBomb::BombReadInputStreamCall {
    ReadInputStreamCall() {
      this.getReceiverType() instanceof TypeZipInputStream and
      this.getMethod().hasName(["read", "readNBytes", "readAllBytes"])
    }
  }

  /**
   * Gets `n1` and `n2` which `CompressorInputStream n2 = new CompressorStreamFactory().createCompressorInputStream(n1)`
   * or `ArchiveInputStream n2 = new ArchiveStreamFactory().createArchiveInputStream(n1)` or
   * `n1.read(n2)`,
   * second one is added because of sanitizer, we want to compare return value of each `read` or similar method
   * that whether there is a flow to a comparison between total read of decompressed stream and a constant value
   */
  private class CompressorsAndArchiversAdditionalTaintStep extends DecompressionBomb::AdditionalStep
  {
    override predicate step(DataFlow::Node n1, DataFlow::Node n2) {
      exists(ConstructorCall call |
        call.getCallee().getDeclaringType() instanceof TypeZipInputStream and
        call.getArgument(0) = n1.asExpr() and
        call = n2.asExpr()
      )
    }
  }
}

/**
 * Providing Decompression sinks and additional taint steps for `java.util.zip` package
 */
module Zip {
  /**
   * The Types that are responsible for `ZipInputStream`, `GZIPInputStream`, `InflaterInputStream` Classes
   */
  class TypeInputStream extends RefType {
    TypeInputStream() {
      this.getASupertype*()
          .hasQualifiedName("java.util.zip",
            ["ZipInputStream", "GZIPInputStream", "InflaterInputStream"])
    }
  }

  /**
   * The methods that read bytes and belong to `*InputStream` Types
   */
  class ReadInputStreamCall extends DecompressionBomb::BombReadInputStreamCall {
    ReadInputStreamCall() {
      this.getReceiverType() instanceof TypeInputStream and
      this.getCallee().hasName(["read", "readNBytes", "readAllBytes"])
    }
  }

  /**
   * A type that is responsible for `Inflater` Class
   */
  class TypeInflator extends RefType {
    TypeInflator() { this.hasQualifiedName("java.util.zip", "Inflater") }
  }

  class InflateSink extends DecompressionBomb::Sink {
    InflateSink() {
      exists(MethodCall ma |
        ma.getReceiverType() instanceof TypeInflator and
        ma.getCallee().hasName("inflate") and
        ma.getArgument(0) = this.asExpr()
        or
        ma.getReceiverType() instanceof TypeInflator and
        ma.getMethod().hasName("setInput") and
        ma.getArgument(0) = this.asExpr()
      )
    }
  }

  class ZipFileSink extends DecompressionBomb::Sink {
    ZipFileSink() {
      exists(MethodCall call |
        call.getCallee().getDeclaringType() instanceof TypeZipFile and
        call.getCallee().hasName("getInputStream") and
        call.getQualifier() = this.asExpr()
      )
    }
  }

  /**
   * A type that is responsible for `ZipFile` Class
   */
  class TypeZipFile extends RefType {
    TypeZipFile() { this.hasQualifiedName("java.util.zip", "ZipFile") }
  }
}
