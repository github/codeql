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
  /**
   * A type that is responsible for `SnappyInputStream` Class
   */
  class TypeInputStream extends RefType {
    TypeInputStream() {
      this.getASupertype*().hasQualifiedName("org.xerial.snappy", "SnappyInputStream")
    }
  }

  /**
   * Gets `n1` and `n2` which `SnappyInputStream n2 = new SnappyInputStream(n2)` or
   * `n1.read(n2)`,
   *  second one is added because of sanitizer, we want to compare return value of each `read` or similar method
   *  that whether there is a flow to a comparison between total read of decompressed stream and a constant value
   */
  predicate inputStreamAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(Call call |
      // Constructors
      call.getCallee().getDeclaringType() = any(TypeInputStream t) and
      call.getArgument(0) = n1.asExpr() and
      call = n2.asExpr()
      or
      // Method calls
      call.(MethodAccess).getReceiverType() = any(TypeInputStream t) and
      call.getCallee().hasName(["read", "readNBytes", "readAllBytes"]) and
      (
        call.getArgument(0) = n2.asExpr() and
        call.getQualifier() = n1.asExpr()
        or
        call.getArgument(0) = n1.asExpr() and
        call = n2.asExpr()
      )
    )
  }

  /**
   * The methods that read bytes and belong to `SnappyInputStream` Types
   */
  class ReadInputStreamCall extends MethodAccess {
    ReadInputStreamCall() {
      this.getReceiverType() instanceof TypeInputStream and
      this.getCallee().hasName(["read", "readNBytes", "readAllBytes"])
    }

    /**
     * An Argument which responsible for the destination of decompressed bytes and is used as a sink
     */
    Expr getAWriteArgument() { result = this.getArgument(0) }

    // look at Zip4j comments for this method
    predicate isControlledRead() { none() }
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
     * Gets `n1` and `n2` which `*CompressorInputStream n2 = new *CompressorInputStream(n2)` or
     * `n2 = inputStream.read(n1)` or `n1.read(n2)`,
     *  second one is added because of sanitizer, we want to compare return value of each `read` or similar method
     *  that whether there is a flow to a comparison between total read of decompressed stream and a constant value
     */
    predicate inputStreamAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
      exists(Call call |
        // Constructors
        call.getCallee().getDeclaringType() = any(TypeCompressors t) and
        call.getArgument(0) = n1.asExpr() and
        call = n2.asExpr()
        or
        // Method calls
        call.(MethodAccess).getReceiverType() = any(TypeCompressors t) and
        call.getCallee().hasName(["read", "readNBytes", "readAllBytes"]) and
        (
          call.getArgument(0) = n2.asExpr() and
          call.getQualifier() = n1.asExpr()
          or
          call.getArgument(0) = n1.asExpr() and
          call = n2.asExpr()
        )
      )
    }

    /**
     * The methods that read bytes and belong to `*CompressorInputStream` Types
     */
    class ReadInputStreamCall extends MethodAccess {
      ReadInputStreamCall() {
        this.getReceiverType() instanceof TypeCompressors and
        this.getCallee().hasName(["read", "readNBytes", "readAllBytes"])
      }

      /**
       * An Argument which responsible for the destination of decompressed bytes and is used as a sink
       */
      Expr getAWriteArgument() { result = this.getArgument(0) }

      // look at Zip4j comments for this method
      predicate isControlledRead() { none() }
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
     * Gets `n1` and `n2` which `*ArchiveInputStream n2 = new *ArchiveInputStream(n2)` or
     * `n2 = inputStream.read(n2)` or `n1.read(n2)`,
     *  second one is added because of sanitizer, we want to compare return value of each `read` or similar method
     *  that whether there is a flow to a comparison between total read of decompressed stream and a constant value
     */
    predicate inputStreamAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
      exists(Call call |
        // Constructors
        call.getCallee().getDeclaringType() = any(TypeArchivers t) and
        call.getArgument(0) = n1.asExpr() and
        call = n2.asExpr()
        or
        // Method calls
        call.(MethodAccess).getReceiverType() = any(TypeArchivers t) and
        call.getCallee().hasName(["read", "readNBytes", "readAllBytes"]) and
        (
          call.getArgument(0) = n2.asExpr() and
          call.getQualifier() = n1.asExpr()
          or
          call.getArgument(0) = n1.asExpr() and
          call = n2.asExpr()
        )
      )
    }

    /**
     * The methods that read bytes and belong to `*ArchiveInputStream` Types
     */
    class ReadInputStreamCall extends MethodAccess {
      ReadInputStreamCall() {
        this.getReceiverType() instanceof TypeArchivers and
        this.getCallee().hasName(["read", "readNBytes", "readAllBytes"])
      }

      /**
       * An Argument which responsible for the destination of decompressed bytes and is used as a sink
       */
      Expr getAWriteArgument() { result = this.getArgument(0) }

      // look at Zip4j comments for this method
      predicate isControlledRead() { none() }
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
     * Gets `n1` and `n2` which `CompressorInputStream n2 = new CompressorStreamFactory().createCompressorInputStream(n1)`
     * or `ArchiveInputStream n2 = new ArchiveStreamFactory().createArchiveInputStream(n1)` or
     * `n1.read(n2)`,
     * second one is added because of sanitizer, we want to compare return value of each `read` or similar method
     * that whether there is a flow to a comparison between total read of decompressed stream and a constant value
     */
    predicate inputStreamAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
      exists(Call call |
        // Constructors
        (
          call.getCallee().getDeclaringType() = any(TypeCompressors t)
          or
          call.getCallee().getDeclaringType() = any(TypeArchivers t)
        ) and
        call.getArgument(0) = n1.asExpr() and
        call = n2.asExpr()
        or
        // Method calls
        (
          call.(MethodAccess).getReceiverType() = any(TypeArchiveInputStream t)
          or
          call.(MethodAccess).getReceiverType() = any(TypeCompressorInputStream t)
        ) and
        call.getCallee().hasName(["read", "readNBytes", "readAllBytes"]) and
        (
          call.getArgument(0) = n2.asExpr() and
          call.getQualifier() = n1.asExpr()
          or
          call.getArgument(0) = n1.asExpr() and
          call = n2.asExpr()
        )
      )
    }

    /**
     * The methods that read bytes and belong to `CompressorInputStream` or `ArchiveInputStream` Types
     */
    class ReadInputStreamCall extends MethodAccess {
      ReadInputStreamCall() {
        (
          this.getReceiverType() instanceof TypeArchiveInputStream
          or
          this.getReceiverType() instanceof TypeCompressorInputStream
        ) and
        this.getCallee().hasName(["read", "readNBytes", "readAllBytes"])
      }

      /**
       * An Argument which responsible for the destination of decompressed bytes and is used as a sink
       */
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
  class ReadInputStreamCall extends MethodAccess {
    ReadInputStreamCall() {
      this.getReceiverType() instanceof TypeZipInputStream and
      this.getMethod().hasName(["read", "readNBytes", "readAllBytes"])
    }

    /**
     * An Argument which responsible for the destination of decompressed bytes and is used as a sink
     */
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
   * Gets `n1` and `n2` which `ZipInputStream n2 = new ZipInputStream(n1)` or `n2 = zipInputStream.read(n1)` or `n1.read(n2)`,
   * second one is added because of sanitizer, we want to compare return value of each `read` or similar method
   * that whether there is a flow to a comparison between total read of decompressed stream and a constant value
   */
  predicate inputStreamAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(Call call |
      // Constructors
      call.getCallee().getDeclaringType() = any(TypeZipInputStream t) and
      call.getArgument(0) = n1.asExpr() and
      call = n2.asExpr()
      or
      // Method calls
      call.(MethodAccess).getReceiverType() = any(TypeZipInputStream t) and
      call.getCallee().hasName(["read", "readNBytes", "readAllBytes"]) and
      (
        call.getArgument(0) = n2.asExpr() and
        call.getQualifier() = n1.asExpr()
        or
        call.getArgument(0) = n1.asExpr() and
        call = n2.asExpr()
      )
    )
  }
}

/**
 * Providing sinks that can be related to reading uncontrolled buffer and bytes for `org.apache.commons.io` package
 */
module CommonsIO {
  /**
   * The Access to Methods which work with byes and inputStreams and buffers
   */
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
  class ReadInputStreamCall extends MethodAccess {
    ReadInputStreamCall() {
      this.getReceiverType() instanceof TypeInputStream and
      this.getCallee().hasName(["read", "readNBytes", "readAllBytes"])
    }

    /**
     * An Argument which responsible for the destination of decompressed bytes and is used as a sink
     */
    Expr getAWriteArgument() { result = this.getArgument(0) }

    // look at Zip4j comments for this method
    predicate isControlledRead() { none() }
  }

  /**
   * Gets `n1` and `n2` which `*InputStream n2 = new *InputStream(n1)` or
   * `n2 = data.read(n1, 0, BUFFER)` or `n1.read(n2, 0, BUFFER)`,
   * second one is added because of sanitizer, we want to compare return value of each `read` or similar method
   * that whether there is a flow to a comparison between total read of decompressed stream and a constant value
   */
  predicate inputStreamAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(Call call |
      // Constructors
      call.getCallee().getDeclaringType() = any(TypeInputStream t) and
      call.getArgument(0) = n1.asExpr() and
      call = n2.asExpr()
      or
      // Method calls
      call.(MethodAccess).getReceiverType() = any(TypeInputStream t) and
      call.getCallee().hasName(["read", "readNBytes", "readAllBytes"]) and
      (
        call.getArgument(0) = n2.asExpr() and
        call.getQualifier() = n1.asExpr()
        or
        call.getArgument(0) = n1.asExpr() and
        call = n2.asExpr()
      )
    )
  }

  /**
   * A type that is responsible for `Inflater` Class
   */
  class TypeInflator extends RefType {
    TypeInflator() { this.hasQualifiedName("java.util.zip", "Inflater") }
  }

  /**
   * Gets `n1` and `n2` which `Inflater inflater_As_n2 = new Inflater(); inflater_As_n2 = inflater.setInput(n1)` or `n1.inflate(n2)` or
   * `n2 = inflater.inflate(n1)`,
   * third one is added because of sanitizer, we want to compare return value of each `read` or similar method
   * that whether there is a flow to a comparison between total read of decompressed stream and a constant value
   */
  predicate inflatorAdditionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    // n1.inflate(n2)
    exists(MethodAccess ma |
      ma.getReceiverType() instanceof TypeInflator and
      ma.getArgument(0) = n2.asExpr() and
      ma.getQualifier() = n1.asExpr() and
      ma.getCallee().hasName("inflate")
    )
    or
    // n2 = inflater.inflate(n1)
    exists(MethodAccess ma |
      ma.getReceiverType() instanceof TypeInflator and
      ma = n2.asExpr() and
      ma.getArgument(0) = n1.asExpr() and
      ma.getCallee().hasName("inflate")
    )
    or
    // Inflater inflater = new Inflater();
    // inflater_As_n2 = inflater.setInput(n1)
    exists(MethodAccess ma |
      ma.getReceiverType() instanceof TypeInflator and
      n1.asExpr() = ma.getArgument(0) and
      n2.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr() = ma.getQualifier() and
      ma.getCallee().hasName("setInput")
    )
  }

  /**
   * The methods that read bytes and belong to `Inflater` Type
   */
  class InflateCall extends MethodAccess {
    InflateCall() {
      this.getReceiverType() instanceof TypeInflator and
      this.getCallee().hasName("inflate")
    }

    /**
     * An Argument which responsible for the destination of decompressed bytes and is used as a sink
     */
    Expr getAWriteArgument() { result = this.getArgument(0) }

    // look at Zip4j comments for this method
    predicate isControlledRead() { none() }
  }

  /**
   * A type that is responsible for `ZipFile` Class
   */
  class TypeZipFile extends RefType {
    TypeZipFile() { this.hasQualifiedName("java.util.zip", "ZipFile") }
  }

  /**
   * Gets `n1` and `n2` which `ZipFile n2 = new ZipFile(n1);` or
   * `InputStream n2 = zipFile.getInputStream(n1);` or `zipFile_As_n1.getInputStream(n2);`
   */
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
 * Providing InputStream and it subClasses that mostly related to Sinks of ZipFile Type,
 * we can do
 */
module InputStream {
  /**
   * The Types that are responsible for `InputStream` Class and all classes that are child of InputStream Class
   */
  class TypeInputStream extends RefType {
    TypeInputStream() { this.getASupertype*().hasQualifiedName("java.io", "InputStream") }
  }

  /**
   * The methods that read bytes and belong to `InputStream` Type and all Types that are child of InputStream Type
   */
  class Read extends MethodAccess {
    Read() {
      this.getReceiverType() instanceof TypeInputStream and
      this.getCallee().hasName(["read", "readNBytes", "readAllBytes"])
    }
  }

  /**
   * general additional taint steps for all inputStream and all Types that are child of inputStream
   */
  predicate additionalTaintStep(DataFlow::Node n1, DataFlow::Node n2) {
    exists(Call call |
      // Method calls
      call.(MethodAccess).getReceiverType() = any(InputStream::TypeInputStream t) and
      call.getCallee().hasName(["read", "readNBytes", "readAllBytes"]) and
      (
        // call.getArgument(0) = n2.asExpr() and
        // call.getQualifier() = n1.asExpr()
        // or
        // call.getArgument(0) = n1.asExpr() and
        // call = n2.asExpr()
        // or
        // TODO: only implement following
        call.getQualifier() = n1.asExpr() and
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
