import python
import semmle.python.dataflow.new.TaintTracking
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.internal.DataFlowPublic
import FileAndFormRemoteFlowSource::FileAndFormRemoteFlowSource
import codeql.util.Unit

module DecompressionBomb {
  /**
   * The additional taint steps that need for creating taint tracking or dataflow.
   */
  class AdditionalTaintStep extends Unit {
    /**
     * Holds if there is a additional taint step between pred and succ.
     */
    abstract predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ);
  }

  /**
   * A abstract class responsible for extending new decompression sinks
   */
  abstract class Sink extends DataFlow::Node { }
}

module ZipFile {
  /**
   * Gets `zipfile` Instance
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
   * A Call to `extractall`, `extract()`, or `extractfile()` on an open ZipFile.
   */
  class DecompressionSink extends DecompressionBomb::Sink {
    DecompressionSink() {
      this =
        zipFileClass()
            .getReturn()
            .getMember(["extractall", "read", "extract", "testzip"])
            .getACall()
      or
      exists(API::Node zipOpen | zipOpen = zipFileClass().getReturn().getMember("open") |
        // this open function must reads uncompressed data with buffer
        // and checks the accumulated size at the end of each read to be called safe
        not zipFileDecompressionBombSanitizer(zipOpen) and
        this = zipOpen.getACall()
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
    DataFlow::localFlow(n.getReturn().getMember("read").getParameter(0).asSink(),
      DataFlow::exprNode(any(Compare i).getASubExpression*()))
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
    override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(API::Node zipFileInstance | zipFileInstance = zipFileClass() |
        nodeFrom =
          [zipFileInstance.getACall().getParameter(0, "file").asSink(), zipFileInstance.getACall()] and
        nodeTo =
          [
            zipFileInstance
                .getACall()
                .getReturn()
                .getMember(["extractall", "read", "extract", "testzip"])
                .getACall(), zipFileInstance.getReturn().getMember("open").getACall()
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
   * A Call to `extractall`, `extract()`, or `extractfile()` on an open tarfile,
   *  or
   * A Call to `gzopen`, `xzopen()`, or `bz2open()` on a tarfile.Tarfile.
   */
  class DecompressionSink extends DecompressionBomb::Sink {
    DecompressionSink() {
      this =
        tarfileExtractMember()
            .getReturn()
            .getMember(["extractall", "extract", "extractfile"])
            .getACall()
    }
  }

  /**
   * Gets tarfile instance for extracting compressed data
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
            .(StringLiteral)
            .getText()
      ) or
      not result
          .getACall()
          .getParameter(1, "mode")
          .getAValueReachingSink()
          .asExpr()
          .(StringLiteral)
          .getText()
          .matches("r:%")
    )
  }

  /**
   * The Additional taint steps that are necessary for data flow query
   */
  class DecompressionAdditionalTaintStep extends DecompressionBomb::AdditionalTaintStep {
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
  class DecompressionSink extends DecompressionBomb::Sink {
    DecompressionSink() {
      exists(API::CallNode callToPandasMethods |
        (
          callToPandasMethods =
            API::moduleImport("pandas")
                .getMember([
                    "read_csv", "read_json", "read_sas", "read_stata", "read_table", "read_xml"
                  ])
                .getACall() and
          this = callToPandasMethods.getArg(0)
          or
          callToPandasMethods =
            API::moduleImport("pandas")
                .getMember(["read_csv", "read_sas", "read_stata", "read_table"])
                .getACall() and
          this = callToPandasMethods.getArgByName("filepath_or_buffer")
          or
          callToPandasMethods = API::moduleImport("pandas").getMember("read_json").getACall() and
          this = callToPandasMethods.getArgByName("path_or_buf")
          or
          callToPandasMethods = API::moduleImport("pandas").getMember("read_xml").getACall() and
          this = callToPandasMethods.getArgByName("path_or_buffer")
        ) and
        (
          not exists(callToPandasMethods.getArgByName("compression"))
          or
          not callToPandasMethods
              .getKeywordParameter("compression")
              .getAValueReachingSink()
              .asExpr()
              .(StringLiteral)
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
  class DecompressionSink extends DecompressionBomb::Sink {
    DecompressionSink() {
      this =
        API::moduleImport("shutil")
            .getMember("unpack_archive")
            .getACall()
            .getParameter(0, "filename")
            .asSink()
    }
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
  class DecompressionSink extends DecompressionBomb::Sink {
    DecompressionSink() {
      exists(API::CallNode gzipCall | gzipCall = gzipInstance().getACall() |
        this = gzipCall.getParameter(0, "filename").asSink() and
        (
          not exists(
            gzipCall
                .getParameter(1, "mode")
                .getAValueReachingSink()
                .asExpr()
                .(StringLiteral)
                .getText()
          ) or
          gzipCall
              .getParameter(1, "mode")
              .getAValueReachingSink()
              .asExpr()
              .(StringLiteral)
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
  class DecompressionSink extends DecompressionBomb::Sink {
    DecompressionSink() {
      exists(API::CallNode bz2Call | bz2Call = bz2Instance().getACall() |
        this = bz2Call.getParameter(0, "filename").asSink() and
        (
          not exists(
            bz2Call
                .getParameter(1, "mode")
                .getAValueReachingSink()
                .asExpr()
                .(StringLiteral)
                .getText()
          ) or
          bz2Call
              .getParameter(1, "mode")
              .getAValueReachingSink()
              .asExpr()
              .(StringLiteral)
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
  class DecompressionSink extends DecompressionBomb::Sink {
    DecompressionSink() {
      exists(API::CallNode lzmaCall | lzmaCall = lzmaInstance().getACall() |
        this = lzmaCall.getParameter(0, "filename").asSink() and
        (
          not exists(
            lzmaCall
                .getParameter(1, "mode")
                .getAValueReachingSink()
                .asExpr()
                .(StringLiteral)
                .getText()
          ) or
          lzmaCall
              .getParameter(1, "mode")
              .getAValueReachingSink()
              .asExpr()
              .(StringLiteral)
              .getText()
              .matches("%r%")
        )
      )
    }
  }
}

/**
 * `io.TextIOWrapper(ip, encoding='utf-8')` like following:
 * ```python
 * with gzip.open(bomb_input, 'rb') as ip:
 *   with io.TextIOWrapper(ip, encoding='utf-8') as decoder:
 *     content = decoder.read()
 *     print(content)
 * ```
 * I saw this builtin method many places so I added it as a AdditionalTaintStep.
 * it would be nice if it is added as a global AdditionalTaintStep
 */
predicate isAdditionalTaintStepTextIOWrapper(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  exists(API::CallNode textIOWrapper |
    textIOWrapper = API::moduleImport("io").getMember("TextIOWrapper").getACall()
  |
    nodeFrom = textIOWrapper.getParameter(0, "input").asSink() and
    nodeTo = textIOWrapper
  )
}

module BombsConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
    or
    source instanceof FastApi
  }

  predicate isSink(DataFlow::Node sink) { sink instanceof DecompressionBomb::Sink }

  predicate isBarrierIn(DataFlow::Node node) {
    node.getScope()
        .getEnclosingModule()
        .getFile()
        .getAbsolutePath()
        .matches(["%/tarfile.py", "%/zipfile.py", "%/zipfile/__init__.py"]) and
    node.getScope().getEnclosingModule().getFile().inStdlib()
  }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    (
      any(DecompressionBomb::AdditionalTaintStep a).isAdditionalTaintStep(pred, succ) or
      isAdditionalTaintStepTextIOWrapper(pred, succ)
    )
  }
}

module BombsFlow = TaintTracking::Global<BombsConfig>;
