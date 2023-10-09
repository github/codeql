import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.internal.DataFlowPublic

module DecompressionBomb {
  /**
   * The Sinks of uncontrolled data decompression, use this class in your queries
   */
  class Sink extends DataFlow::Node {
    Sink() { this = any(Range r).sink() }
  }

  /**
   * The additional taint steps that need for creating taint tracking or dataflow.
   */
  abstract class AdditionalTaintStep extends string {
    AdditionalTaintStep() { this = "AdditionalTaintStep" }

    /**
     * Holds if there is a additional taint step between pred and succ.
     */
    abstract predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ);
  }

  /**
   * A abstract class responsible for extending new decompression sinks
   */
  abstract class Range extends API::Node {
    /**
     * Gets the sink of responsible for decompression node
     *
     * it can be a path, stream of compressed data,
     * or a call to function that use pipe
     */
    abstract DataFlow::Node sink();
  }
}

module ZipFile {
  /**
   * A `zipfile` Instance
   *
   * ```python
   * zipfile.ZipFile()
   * ```
   */
  API::Node zipFileClass() {
    result =
      [
        API::moduleImport("zipfile").getMember("ZipFile"),
        API::moduleImport("zipfile").getMember("PyZipFile")
      ]
  }

  /**
   * The Decompression Sinks of `zipfile` library
   *
   * ```python
   * myzip = zipfile.ZipFile("zipfileName.zip")
   * myzip.open('eggs.txt',"r").read()
   * myzip.extractall()
   * ```
   */
  class DecompressionSink extends DecompressionBomb::Range {
    override string toString() { result = "DecompressionSink" }

    DecompressionSink() { this = zipFileClass() }

    /**
     * An function call of tarfile for extracting compressed data
     *
     * `tarfile.open(filepath).extractall()` or `tarfile.open(filepath).extract()`or `tarfile.open(filepath).extractfile()`
     * or `tarfile.Tarfile.xzopen()` or `tarfile.Tarfile.gzopen()` or `tarfile.Tarfile.bz2open()`
     */
    override DataFlow::Node sink() {
      (
        result = this.getReturn().getMember(["extractall", "read", "extract", "testzip"]).getACall()
        or
        exists(API::Node openInstance |
          openInstance = this.getReturn().getMember("open") and
          (
            not exists(
              openInstance
                  .getACall()
                  .getParameter(1, "mode")
                  .getAValueReachingSink()
                  .asExpr()
                  .(StrConst)
                  .getText()
            ) or
            openInstance
                .getACall()
                .getParameter(1, "mode")
                .getAValueReachingSink()
                .asExpr()
                .(StrConst)
                .getText() = "r"
          ) and
          (
            not exists(
              this.getACall()
                  .getParameter(1, "mode")
                  .getAValueReachingSink()
                  .asExpr()
                  .(StrConst)
                  .getText()
            ) or
            this.getACall()
                .getParameter(1, "mode")
                .getAValueReachingSink()
                .asExpr()
                .(StrConst)
                .getText() = "r"
          ) and
          not zipFileDecompressionBombSanitizer(this) and
          result = openInstance.getACall()
        )
      )
    }
  }

  /**
   * Gets a `zipfile.ZipFile` and checks if there is a size controlled read or not
   * ```python
   *    with zipfile.ZipFile(zipFileName) as myzip:
   *      with myzip.open(fileinfo.filename, mode="r") as myfile:
   *        while chunk:
   *          chunk = myfile.read(buffer_size)
   *          total_size += buffer_size
   *          if total_size > SIZE_THRESHOLD:
   *            ...
   * ```
   */
  predicate zipFileDecompressionBombSanitizer(API::Node n) {
    TaintTracking::localExprTaint(n.getReturn().getMember("read").getParameter(0).asSink().asExpr(),
      any(Compare i).getASubExpression*())
  }

  /**
   * The Additional taint steps that are necessary for data flow query
   *
   * ```python
   * nodeFrom = "zipFileName.zip"
   * myZip = zipfile.ZipFile(nodeFrom)
   * nodeTo = myZip.open('eggs.txt',"r")
   * nodeTo = myZip.extractall()
   * nodeTo = myZip.read()
   * nodeTo = myZip.extract()
   * # testzip not a RAM consumer but it uses as much CPU as possible
   * nodeTo = myZip.testzip()
   * ```
   */
  class DecompressionAdditionalTaintStep extends DecompressionBomb::AdditionalTaintStep {
    DecompressionAdditionalTaintStep() { this = "AdditionalTaintStep" }

    override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(DecompressionSink zipFileInstance |
        nodeFrom =
          [zipFileInstance.getACall().getParameter(0, "file").asSink(), zipFileInstance.getACall()] and
        nodeTo =
          [
            zipFileInstance.sink(),
            zipFileInstance
                .getACall()
                .getReturn()
                .getMember(["extractall", "read", "extract", "testzip"])
                .getACall()
          ]
      )
    }
  }
}

/**
 * Provides Sinks and additional taint steps related to `tarfile` library
 */
module TarFile {
  /**
   * The Decompression Sinks of `tarfile` library
   */
  class DecompressionSink extends DecompressionBomb::Range {
    override string toString() { result = "DecompressionSink" }

    DecompressionSink() { this = tarfileExtractMember() }

    /**
     * An function call of tarfile for extracting compressed data
     * `tarfile.open(filepath).extractall()` or `tarfile.open(filepath).extract()`or `tarfile.open(filepath).extractfile()`
     * or `tarfile.Tarfile.xzopen()` or `tarfile.Tarfile.gzopen()` or `tarfile.Tarfile.bz2open()`
     */
    override DataFlow::Node sink() {
      result = this.getReturn().getMember(["extractall", "extract", "extractfile"]).getACall()
    }
  }

  /**
   * A tarfile instance for extracting compressed data
   */
  API::Node tarfileExtractMember() {
    result =
      [
        API::moduleImport("tarfile").getMember("open"),
        API::moduleImport("tarfile")
            .getMember("TarFile")
            .getMember(["xzopen", "gzopen", "bz2open", "open"])
      ] and
    (
      not exists(
        result
            .getACall()
            .getParameter(1, "mode")
            .getAValueReachingSink()
            .asExpr()
            .(StrConst)
            .getText()
      ) or
      not result
          .getACall()
          .getParameter(1, "mode")
          .getAValueReachingSink()
          .asExpr()
          .(StrConst)
          .getText()
          .matches("r:%")
    )
  }

  /**
   * The Additional taint steps that are necessary for data flow query
   */
  class DecompressionAdditionalTaintStep extends DecompressionBomb::AdditionalTaintStep {
    DecompressionAdditionalTaintStep() { this = "AdditionalTaintStep" }

    override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(API::Node tarfileInstance | tarfileInstance = tarfileExtractMember() |
        nodeFrom = tarfileInstance.getACall().getParameter(0, "name").asSink() and
        nodeTo =
          tarfileInstance.getReturn().getMember(["extractall", "extract", "extractfile"]).getACall()
      )
    }
  }
}

/**
 * Provides Sinks and additional taint steps related to `pandas` library
 */
module Pandas {
  /**
   * The Decompression Sinks of `pandas` library
   */
  class DecompressionSink extends DecompressionBomb::Range {
    override string toString() { result = "DecompressionSink" }

    DecompressionSink() { this = API::moduleImport("pandas") }

    override DataFlow::Node sink() {
      exists(API::CallNode calltoPandasMethods |
        (
          calltoPandasMethods =
            this.getMember([
                "read_csv", "read_json", "read_sas", "read_stata", "read_table", "read_xml"
              ]).getACall() and
          result = calltoPandasMethods.getArg(0)
          or
          calltoPandasMethods =
            this.getMember(["read_csv", "read_sas", "read_stata", "read_table"]).getACall() and
          result = calltoPandasMethods.getArgByName("filepath_or_buffer")
          or
          calltoPandasMethods = this.getMember("read_json").getACall() and
          result = calltoPandasMethods.getArgByName("path_or_buf")
          or
          calltoPandasMethods = this.getMember("read_xml").getACall() and
          result = calltoPandasMethods.getArgByName("path_or_buffer")
        ) and
        (
          not exists(calltoPandasMethods.getArgByName("compression"))
          or
          not calltoPandasMethods
              .getKeywordParameter("compression")
              .getAValueReachingSink()
              .asExpr()
              .(StrConst)
              .getText() = "tar"
        )
      )
    }
  }
}

/**
 * Provides Sinks and additional taint steps related to `shutil` library
 */
module Shutil {
  /**
   * The Decompression Sinks of `shutil` library
   */
  class DecompressionSink extends DecompressionBomb::Range {
    override string toString() { result = "DecompressionSink" }

    DecompressionSink() { this = API::moduleImport("shutil").getMember("unpack_archive") }

    override DataFlow::Node sink() { result = this.getACall().getParameter(0, "filename").asSink() }
  }
}

/**
 * Provides Sinks and additional taint steps related to `gzip` library
 */
module Gzip {
  private API::Node gzipInstance() {
    result = API::moduleImport("gzip").getMember(["GzipFile", "open"])
  }

  /**
   * The Decompression Sinks of `gzip` library
   *
   * `gzip.open(sink)`
   * `gzip.GzipFile(sink)`
   *
   * only read mode is sink
   */
  class DecompressionSink extends DecompressionBomb::Range {
    override string toString() { result = "DecompressionSink" }

    DecompressionSink() { this = gzipInstance() }

    override DataFlow::Node sink() {
      exists(API::CallNode gzipCall | gzipCall = this.getACall() |
        result = gzipCall.getParameter(0, "filename").asSink() and
        (
          not exists(
            gzipCall.getParameter(1, "mode").getAValueReachingSink().asExpr().(StrConst).getText()
          ) or
          gzipCall
              .getParameter(1, "mode")
              .getAValueReachingSink()
              .asExpr()
              .(StrConst)
              .getText()
              .matches("%r%")
        )
      )
    }
  }
}

/**
 * Provides Sinks and additional taint steps related to `bz2` library
 */
module Bz2 {
  private API::Node bz2Instance() {
    result = API::moduleImport("bz2").getMember(["BZ2File", "open"])
  }

  /**
   * The Decompression Sinks of `bz2` library
   *
   * `bz2.open(sink)`
   * `bz2.BZ2File(sink)`
   *
   * only read mode is sink
   */
  class DecompressionSink extends DecompressionBomb::Range {
    override string toString() { result = "DecompressionSink" }

    DecompressionSink() { this = bz2Instance() }

    override DataFlow::Node sink() {
      exists(API::CallNode bz2Call | bz2Call = this.getACall() |
        result = bz2Call.getParameter(0, "filename").asSink() and
        (
          not exists(
            bz2Call.getParameter(1, "mode").getAValueReachingSink().asExpr().(StrConst).getText()
          ) or
          bz2Call
              .getParameter(1, "mode")
              .getAValueReachingSink()
              .asExpr()
              .(StrConst)
              .getText()
              .matches("%r%")
        )
      )
    }
  }
}

/**
 * Provides Sinks and additional taint steps related to `lzma` library
 */
module Lzma {
  private API::Node lzmaInstance() {
    result = API::moduleImport("lzma").getMember(["LZMAFile", "open"])
  }

  /**
   * The Decompression Sinks of `bz2` library
   *
   * `lzma.open(sink)`
   * `lzma.LZMAFile(sink)`
   *
   * only read mode is sink
   */
  class DecompressionSink extends DecompressionBomb::Range {
    override string toString() { result = "DecompressionSink" }

    DecompressionSink() { this = lzmaInstance() }

    override DataFlow::Node sink() {
      exists(API::CallNode lzmaCall | lzmaCall = this.getACall() |
        result = lzmaCall.getParameter(0, "filename").asSink() and
        (
          not exists(
            lzmaCall.getParameter(1, "mode").getAValueReachingSink().asExpr().(StrConst).getText()
          ) or
          lzmaCall
              .getParameter(1, "mode")
              .getAValueReachingSink()
              .asExpr()
              .(StrConst)
              .getText()
              .matches("%r%")
        )
      )
    }
  }
}
