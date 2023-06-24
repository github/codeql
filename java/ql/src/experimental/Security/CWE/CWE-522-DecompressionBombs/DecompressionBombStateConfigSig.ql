/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id java/user-controlled-file-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.DataFlow2
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.TaintTracking2
import RemoteSource
import CommandLineSource
import java

module XserialSnappy {
  class TypeInputStream extends RefType {
    TypeInputStream() {
      this.getASupertype*().hasQualifiedName("org.xerial.snappy", "SnappyInputStream")
    }
  }

  predicate inputStreamAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(Call call |
      (
        call.getCallee().getDeclaringType() instanceof TypeInputStream or
        call.(MethodAccess).getReceiverType() instanceof TypeInputStream
      ) and
      call.getArgument(0) = n1.asExpr() and
      call = n2.asExpr()
    )
  }

  class ReadInputStreamCall extends MethodAccess {
    ReadInputStreamCall() {
      this.getReceiverType() instanceof TypeInputStream and
      this.getCallee().hasName(["read", "readNBytes", "readAllBytes"])
    }

    Expr getAWriteArgument() { result = this.getArgument(0) }

    // look at Zip4j comments for this method
    predicate isControlledRead() { none() }
  }
}

module ApacheCommons {
  class TypeArchiveInputStream extends RefType {
    TypeArchiveInputStream() {
      this.getASupertype*()
          .hasQualifiedName("org.apache.commons.compress.archivers", "ArchiveInputStream")
    }
  }

  class TypeCompressorInputStream extends RefType {
    TypeCompressorInputStream() {
      this.getASupertype*()
          .hasQualifiedName("org.apache.commons.compress.compressors", "CompressorInputStream")
    }
  }

  module Compressors {
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

    predicate inputStreamAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
      exists(Call call |
        (
          call.getCallee().getDeclaringType() instanceof TypeCompressors or
          call.(MethodAccess).getReceiverType() instanceof TypeCompressors
        ) and
        call.getArgument(0) = n1.asExpr() and
        call = n2.asExpr()
      )
    }

    class ReadInputStreamCall extends MethodAccess {
      ReadInputStreamCall() {
        this.getReceiverType() instanceof TypeCompressors and
        this.getCallee().hasName(["read", "readNBytes", "readAllBytes"])
      }

      Expr getAWriteArgument() { result = this.getArgument(0) }

      // look at Zip4j comments for this method
      predicate isControlledRead() { none() }
    }
  }

  module Archivers {
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
     *```java
     *  ZipArchiveInputStream n2 = new ZipArchiveInputStream(n1);
     *  ZipArchiveInputStream n = new ZipArchiveInputStream(inputStream);
     *  n2 = n.read(n1);
     *```
     */
    predicate inputStreamAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
      exists(Call call |
        (
          // constructors
          call.getCallee().getDeclaringType() instanceof TypeArchivers
          or
          // Method calls
          call.(MethodAccess).getReceiverType() instanceof TypeArchivers
        ) and
        n1.asExpr() = call.getArgument(0) and
        n2.asExpr() = call
      )
    }

    class ReadInputStreamCall extends MethodAccess {
      ReadInputStreamCall() {
        this.getReceiverType() instanceof TypeArchivers and
        this.getCallee().hasName(["read", "readNBytes", "readAllBytes"])
      }

      Expr getAWriteArgument() { result = this.getArgument(0) }

      // look at Zip4j comments for this method
      predicate isControlledRead() { none() }
    }
  }

  module Factory {
    class TypeArchivers extends RefType {
      TypeArchivers() {
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.archivers", "ArchiveStreamFactory")
      }
    }

    class TypeCompressors extends RefType {
      TypeCompressors() {
        this.getASupertype*()
            .hasQualifiedName("org.apache.commons.compress.compressors", "CompressorStreamFactory")
      }
    }

    /**
     * ```java
     *CompressorInputStream n2 = new CompressorStreamFactory().createCompressorInputStream(n1)
     *ArchiveInputStream n2 = new ArchiveStreamFactory().createArchiveInputStream(n1)
     * ```
     */
    predicate inputStreamAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
      exists(Call call |
        (
          // Constructors
          call.getCallee().getDeclaringType() = any(TypeCompressors t)
          or
          call.getCallee().getDeclaringType() = any(TypeArchivers t)
          or
          // Method calls
          call.(MethodAccess).getReceiverType() = any(TypeArchiveInputStream t)
          or
          call.(MethodAccess).getReceiverType() = any(TypeCompressorInputStream t)
        ) and
        n1.asExpr() = call.getArgument(0) and
        n2.asExpr() = call
      )
    }

    class ReadInputStreamCall extends MethodAccess {
      ReadInputStreamCall() {
        (
          this.getReceiverType() instanceof TypeArchiveInputStream
          or
          this.getReceiverType() instanceof TypeCompressorInputStream
        ) and
        this.getCallee().hasName(["read", "readNBytes", "readAllBytes"])
      }

      Expr getAWriteArgument() { result = this.getArgument(0) }

      // look at Zip4j comments for this method
      predicate isControlledRead() { none() }
    }
  }
}

module Zip4j {
  class TypeZipInputStream extends RefType {
    TypeZipInputStream() {
      this.hasQualifiedName("net.lingala.zip4j.io.inputstream", "ZipInputStream")
    }
  }

  /**
   * ```java
   * n = new net.lingala.zip4j.io.inputstream.ZipInputStream(inputStream);
   * this = n.read(readBuffer);
   * ```
   */
  class ReadInputStreamCall extends MethodAccess {
    ReadInputStreamCall() {
      this.getReceiverType() instanceof TypeZipInputStream and
      this.getMethod().hasName(["read", "readNBytes", "readAllBytes"])
    }

    Expr getAWriteArgument() { result = this.getArgument(0) }

    // while ((readLen = zipInputStream.read(readBuffer)) != -1) {
    //   totallRead += readLen;
    //   if (totallRead > 1024 * 1024 * 4) {
    //     System.out.println("potential Bomb");
    //     break;
    //   }
    //   outputStream.write(readBuffer, 0, readLen);
    // }
    // TODO: I don't know why we can't reach totallRead with Local Tainting
    // the same behaviour exists in golang
    predicate isControlledRead() {
      exists(ComparisonExpr i |
        TaintTracking::localExprTaint([this, this.getArgument(2)], i.getAChildExpr*())
      )
    }
  }

  /**
   * ```java
   * n2 = new net.lingala.zip4j.io.inputstream.ZipInputStream(n1);
   * // or
   * n = new net.lingala.zip4j.io.inputstream.ZipInputStream(inputStream);
   * n2 = n.Method(n1);
   * ```
   */
  predicate inputStreamAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(Call call |
      (
        call.getCallee().getDeclaringType() instanceof TypeZipInputStream or
        call.(MethodAccess).getReceiverType() instanceof TypeZipInputStream
      ) and
      call.getCallee().hasName(["read", "readNBytes", "readAllBytes"]) and
      call.getArgument(0) = n1.asExpr() and
      call = n2.asExpr()
    )
  }
}

module Zip {
  class TypeZipInputStream extends RefType {
    TypeZipInputStream() {
      this.getASupertype*()
          .hasQualifiedName("java.util.zip",
            ["ZipInputStream", "GZIPInputStream", "InflaterInputStream"])
    }
  }

  predicate inputStreamAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(Call call |
      (
        call.getCallee().getDeclaringType() instanceof TypeZipInputStream or
        call.(MethodAccess).getReceiverType() instanceof TypeZipInputStream
      ) and
      call.getArgument(0) = n1.asExpr() and
      call = n2.asExpr()
    )
  }

  class ReadInputStreamCall extends MethodAccess {
    ReadInputStreamCall() {
      this.getReceiverType() instanceof TypeZipInputStream and
      this.getCallee().hasName(["read", "readNBytes", "readAllBytes"])
    }

    Expr getAWriteArgument() { result = this.getArgument(0) }

    // look at Zip4j comments for this method
    predicate isControlledRead() { none() }
  }
}

module CommonsIO {
  class IOUtils extends MethodAccess {
    IOUtils() {
      this.getMethod()
          .hasName([
              "copy", "copyLarge", "read", "readFully", "readLines", "toBufferedInputStream",
              "toByteArray", "toCharArray", "toString", "buffer"
            ]) and
      this.getMethod().getDeclaringType().hasQualifiedName("org.apache.commons.io", "IOUtils")
    }
  }
}

module DecompressionBombsConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    (
      source instanceof RemoteFlowSource
      or
      source instanceof CLIFlowSource
      or
      source instanceof FormRemoteFlowSource
      or
      source instanceof FileUploadRemoteFlowSource
    ) and
    state = ["Zip4j", "Zip", "ApacheCommons", "XserialSnappy"]
  }

  predicate isBarrier(DataFlow::Node sanitizer, FlowState state) { none() }

  /**
   * if getNumArgument > 1 then we can check for sanitizers before reading each Buffer of byte
   * otherwise it can be hard to write sanitizers
   */
  predicate isSink(DataFlow::Node sink, FlowState state) {
    (
      exists(CommonsIO::IOUtils ma |
        sink.asExpr() = ma.getArgument(0) and
        state = ["Zip4j", "Zip", "ApacheCommons", "XserialSnappy"]
      )
      or
      sink.asExpr() = any(Zip4j::ReadInputStreamCall r).getAWriteArgument() and
      state = "Zip4j"
      or
      sink.asExpr() = any(Zip::ReadInputStreamCall r).getAWriteArgument() and
      state = "Zip"
      or
      sink.asExpr() = any(ApacheCommons::Factory::ReadInputStreamCall r).getAWriteArgument() and
      state = "ApacheCommons"
      or
      sink.asExpr() = any(ApacheCommons::Compressors::ReadInputStreamCall r).getAWriteArgument() and
      state = "ApacheCommons"
      or
      sink.asExpr() = any(ApacheCommons::Archivers::ReadInputStreamCall r).getAWriteArgument() and
      state = "ApacheCommons"
      or
      sink.asExpr() = any(XserialSnappy::ReadInputStreamCall r).getAWriteArgument() and
      state = "XserialSnappy"
    )
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node nodeFrom, FlowState stateFrom, DataFlow::Node nodeTo, FlowState stateTo
  ) {
    (
      Zip::inputStreamAdditionalTaintStep(nodeFrom, nodeTo) and
      stateFrom = "Zip"
      or
      Zip4j::inputStreamAdditionalTaintStep(nodeFrom, nodeTo) and
      stateFrom = "Zip4j"
      or
      ApacheCommons::Factory::inputStreamAdditionalTaintStep(nodeFrom, nodeTo) and
      stateFrom = "ApacheCommons"
      or
      ApacheCommons::Compressors::inputStreamAdditionalTaintStep(nodeFrom, nodeTo) and
      stateFrom = "ApacheCommons"
      or
      ApacheCommons::Archivers::inputStreamAdditionalTaintStep(nodeFrom, nodeTo) and
      stateFrom = "ApacheCommons"
      or
      XserialSnappy::inputStreamAdditionalTaintStep(nodeFrom, nodeTo) and
      stateFrom = "XserialSnappy"
    ) and
    stateTo = ""
  }
}

module DecompressionBombsFlow = TaintTracking::GlobalWithState<DecompressionBombsConfig>;

import DecompressionBombsFlow::PathGraph

from DecompressionBombsFlow::PathNode source, DecompressionBombsFlow::PathNode sink
where DecompressionBombsFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This file extraction depends on a $@.", source.getNode(),
  "potentially untrusted source"
