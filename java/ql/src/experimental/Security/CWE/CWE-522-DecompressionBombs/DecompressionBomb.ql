/**
 * @name Uncontrolled file decompression
 * @description Uncontrolled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id java/uncontrolled-file-decompression
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

/**
 * Providing Decompression sinks and additional taint steps for `org.xerial.snappy` package
 */
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

/**
 * Providing Decompression sinks and additional taint steps for `org.apache.commons.compress` package
 */
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

/**
 * Providing Decompression sinks and additional taint steps for `net.lingala.zip4j.io` package
 */
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
      call.getArgument(0) = n2.asExpr() and
      call.getQualifier() = n1.asExpr()
    )
  }
}

/**
 * Providing sinks that can be related to reading uncontrolled buffer and bytes for `org.apache.commons.io` package
 */
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

/**
 * Providing Decompression sinks and additional taint steps for `java.util.zip` package
 */
module Zip {
  class TypeInputStream extends RefType {
    TypeInputStream() {
      this.getASupertype*()
          .hasQualifiedName("java.util.zip",
            ["ZipInputStream", "GZIPInputStream", "InflaterInputStream"])
    }
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

  // *InputStream Izis = new *InputStream(inputStream)
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

  class TypeInflator extends RefType {
    TypeInflator() { this.hasQualifiedName("java.util.zip", "Inflater") }
  }

  class Inflatorsource extends Call {
    Inflatorsource() {
      exists(Call c | c.getCallee().(Constructor).getDeclaringType() instanceof TypeInflator |
        this = c
      )
    }
  }

  predicate inflatorAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    // inflater.inflate(n2)
    exists(MethodAccess ma |
      ma.getReceiverType() instanceof TypeInflator and
      ma.getArgument(0) = n2.asExpr() and
      ma.getQualifier() = n1.asExpr() and
      ma.getCallee().hasName("inflate")
    )
    or
    // Inflater inflater = new Inflater();
    // n2 = inflater.setInput(n1)
    exists(MethodAccess ma |
      ma.getReceiverType() instanceof TypeInflator and
      n1.asExpr() = ma.getArgument(0) and
      n2.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr() = ma.getQualifier() and
      ma.getCallee().hasName("setInput")
    )
  }

  class InflateCall extends MethodAccess {
    InflateCall() {
      this.getReceiverType() instanceof TypeInflator and
      this.getCallee().hasName("inflate")
    }

    Expr getAWriteArgument() { result = this.getArgument(0) }

    // look at Zip4j comments for this method
    predicate isControlledRead() { none() }
  }

  class TypeZipFile extends RefType {
    TypeZipFile() { this.hasQualifiedName("java.util.zip", "ZipFile") }
  }

  class ZipFilesource extends Call {
    ZipFilesource() {
      exists(Call c | c.getCallee().(Constructor).getDeclaringType() instanceof TypeZipFile |
        this = c
      )
    }
  }

  // ZipFile zipFileAsn2 = new ZipFile(n1);
  // InputStream n2 = zipFile.getInputStream(n1);
  predicate zipFileadditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(MethodAccess ma |
      ma.getReceiverType() instanceof TypeZipFile and
      ma = n2.asExpr() and
      ma.getQualifier() = n1.asExpr() and
      ma.getCallee().hasName("getInputStream")
    )
    or
    exists(Call c |
      c.getCallee().getDeclaringType() instanceof TypeZipFile and
      c.getArgument(0) = n1.asExpr() and
      c = n2.asExpr()
    )
  }
}

/**
 * Providing InputStream and it subClasses as Local Decompression sources
 */
module InputStream {
  class TypeInputStream extends RefType {
    TypeInputStream() { this.getASupertype*().hasQualifiedName("java.io", "InputStream") }
  }

  class Source extends Call {
    Source() {
      exists(Call c | c.getCallee().getDeclaringType() instanceof TypeInputStream | this = c)
    }

    DataFlow::Node getInputArgument() { result.asExpr() = this.(ConstructorCall).getArgument(0) }
  }

  class Read extends MethodAccess {
    Read() {
      this.getReceiverType() instanceof TypeInputStream and
      this.getCallee().hasName(["read", "readNBytes", "readAllBytes"])
    }
  }

  predicate additionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(Call call |
      (
        call.getCallee().getDeclaringType() instanceof TypeInputStream or
        call.(MethodAccess).getReceiverType() instanceof TypeInputStream
      ) and
      call.getCallee().hasName(["read", "readNBytes", "readAllBytes"]) and
      call.getQualifier() = n1.asExpr() and
      (
        call.getArgument(0) = n2.asExpr() or
        call = n2.asExpr()
      )
    )
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
    state = ["ZipFile", "Zip4j", "inflator", "Zip", "ApacheCommons", "XserialSnappy"]
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    (
      exists(CommonsIO::IOUtils ma |
        sink.asExpr() = ma.getArgument(0) and
        state = ["Zip4j", "inflator", "Zip", "ApacheCommons", "XserialSnappy", "ZipFile"]
      )
      or
      sink.asExpr() = any(Zip4j::ReadInputStreamCall r).getAWriteArgument() and
      state = "Zip4j"
      or
      sink.asExpr() = any(Zip::InflateCall r).getAWriteArgument() and
      state = "inflator"
      or
      sink.asExpr() instanceof InputStream::Read and
      state = "ZipFile"
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

  // predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  //   inputStreamAdditionalTaintStep(nodeFrom, nodeTo)
  // }
  predicate isAdditionalFlowStep(
    DataFlow::Node nodeFrom, FlowState stateFrom, DataFlow::Node nodeTo, FlowState stateTo
  ) {
    InputStream::additionalTaintStep(nodeFrom, nodeTo) and
    stateFrom = "ZipFile" and
    stateTo = "ZipFile"
    or
    Zip::inflatorAdditionalTaintStep(nodeFrom, nodeTo) and
    stateFrom = "inflator" and
    stateTo = "inflator"
    or
    Zip::zipFileadditionalTaintStep(nodeFrom, nodeTo) and
    stateFrom = "ZipFile" and
    stateTo = "ZipFile"
    or
    Zip::inputStreamAdditionalTaintStep(nodeFrom, nodeTo) and
    stateFrom = "Zip" and
    stateTo = "Zip"
    or
    Zip4j::inputStreamAdditionalTaintStep(nodeFrom, nodeTo) and
    stateFrom = "Zip4j" and
    stateTo = "Zip4j"
    or
    ApacheCommons::Factory::inputStreamAdditionalTaintStep(nodeFrom, nodeTo) and
    stateFrom = "ApacheCommons" and
    stateTo = "ApacheCommons"
    or
    ApacheCommons::Compressors::inputStreamAdditionalTaintStep(nodeFrom, nodeTo) and
    stateFrom = "ApacheCommons" and
    stateTo = "ApacheCommons"
    or
    ApacheCommons::Archivers::inputStreamAdditionalTaintStep(nodeFrom, nodeTo) and
    stateFrom = "ApacheCommons" and
    stateTo = "ApacheCommons"
    or
    XserialSnappy::inputStreamAdditionalTaintStep(nodeFrom, nodeTo) and
    stateFrom = "ApacheCommons" and
    stateTo = "ApacheCommons"
  }

  predicate isBarrier(DataFlow::Node sanitizer, FlowState state) { none() }
}

module DecompressionBombsFlow = TaintTracking::GlobalWithState<DecompressionBombsConfig>;

import DecompressionBombsFlow::PathGraph

from DecompressionBombsFlow::PathNode source, DecompressionBombsFlow::PathNode sink
where DecompressionBombsFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This file extraction depends on a $@.", source.getNode(),
  "potentially untrusted source"
