import codeql.ruby.AST
import codeql.ruby.frameworks.Files
import codeql.ruby.ApiGraphs
import codeql.ruby.DataFlow
import codeql.ruby.dataflow.RemoteFlowSources

module DecompressionBomb {
  /**
   * A abstract class responsible for extending new decompression sinks
   *
   * can be a path, stream of compressed data,
   * or a call to function that use pipe
   */
  abstract class Sink extends DataFlow::Node { }

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
}

module Zlib {
  /**
   * Gets a node of `Zlib::GzipReader` member
   *
   * Note that if you use the lower level Zip::InputStream interface, rubyzip does not check the entry sizes.
   */
  private API::Node gzipReaderInstance() {
    result = API::getTopLevelMember("Zlib").getMember("GzipReader")
  }

  /**
   * A return values of following methods
   * `Zlib::GzipReader.open`
   * `Zlib::GzipReader.zcat`
   * `Zlib::GzipReader.new`
   */
  class DecompressionBombSink extends DecompressionBomb::Sink {
    DecompressionBombSink() {
      this = gzipReaderInstance().getMethod(["open", "new", "zcat"]).getReturn().asSource()
    }
  }

  /**
   * The additional taint steps that need for creating taint tracking or dataflow for `Zlib`.
   */
  class AdditionalTaintStep extends DecompressionBomb::AdditionalTaintStep {
    AdditionalTaintStep() { this = "AdditionalTaintStep" }

    override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(API::Node openOrNewOrZcat |
        openOrNewOrZcat = gzipReaderInstance().getMethod(["open", "new", "zcat"])
      |
        nodeFrom = openOrNewOrZcat.getParameter(0).asSink() and
        nodeTo = openOrNewOrZcat.getReturn().asSource()
      )
    }
  }
}

module ZipInputStream {
  /**
   * Gets a node of `Zip::InputStream` member
   *
   * Note that if you use the lower level Zip::InputStream interface, rubyZip does not check the entry sizes.
   */
  private API::Node zipInputStream() {
    result = API::getTopLevelMember("Zip").getMember("InputStream")
  }

  /**
   * The methods
   * `Zip::InputStream.read`
   * `Zip::InputStream.extract`
   *
   * as source of decompression bombs, they need an additional taint step for a dataflow or taint tracking query
   */
  class DecompressionBombSink extends DecompressionBomb::Sink {
    DecompressionBombSink() {
      this = zipInputStream().getMethod(["open", "new"]).getReturn().asSource()
    }
  }

  /**
   * The additional taint steps that need for creating taint tracking or dataflow for `Zip`.
   */
  class AdditionalTaintStep extends DecompressionBomb::AdditionalTaintStep {
    AdditionalTaintStep() { this = "AdditionalTaintStep" }

    override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(API::Node openOrNew | openOrNew = zipInputStream().getMethod(["open", "new"]) |
        nodeFrom = openOrNew.getParameter(0).asSink() and
        nodeTo = openOrNew.getReturn().asSource()
      )
    }
  }
}

module ZipFile {
  /**
   * Gets a node of `Zip::File` member
   */
  API::Node zipFile() { result = API::getTopLevelMember("Zip").getMember("File") }

  /**
   * Gets nodes that have a `base` at the beginning
   */
  API::Node rubyZipNode(API::Node base) {
    result = base
    or
    result = rubyZipNode(base).getMethod(_)
    or
    result = rubyZipNode(base).getReturn()
    or
    result = rubyZipNode(base).getParameter(_)
    or
    result = rubyZipNode(base).getAnElement()
    or
    result = rubyZipNode(base).getBlock()
  }

  /**
   * The return values of following methods
   * `ZipIO.read`
   * `ZipEntry.extract`
   * A sanitizer exists inside the nodes which have `entry.size > someOBJ`
   */
  class DecompressionBombSink extends DecompressionBomb::Sink {
    DecompressionBombSink() {
      exists(API::Node rubyZip | rubyZip = rubyZipNode(zipFile()) |
        this = rubyZip.getMethod(["extract", "read"]).getReturn().asSource() and
        not exists(
          rubyZip.getMethod("size").getReturn().getMethod([">", " <", "<=", " >="]).getParameter(0)
        )
      )
    }
  }

  /**
   * The additional taint steps that need for creating taint tracking or dataflow for `Zip::File`.
   */
  class AdditionalTaintStep extends DecompressionBomb::AdditionalTaintStep {
    AdditionalTaintStep() { this = "AdditionalTaintStep" }

    override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(API::Node zipFile | zipFile = zipFile().getMethod("open") |
        nodeFrom = zipFile.getParameter(0).asSink() and
        nodeTo = rubyZipNode(zipFile).getMethod(["extract", "read"]).getReturn().asSource()
      )
    }
  }

  predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(API::Node zipFile | zipFile = zipFile().getMethod("open") |
      nodeFrom = zipFile.getParameter(0).asSink() and
      nodeTo = rubyZipNode(zipFile).getMethod(["extract", "read"]).getReturn().asSource()
    )
  }
  // /**
  //  * The additional taint steps that need for creating taint tracking or dataflow for `Zip::File`.
  //  */
  // class AdditionalTaintStep1 extends DecompressionBomb::AdditionalTaintStep {
  //   AdditionalTaintStep1() { this = "AdditionalTaintStep" }
  //   override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  //     exists(API::Node zipFile | zipFile = zipFile().getMethod("open") |
  //       nodeFrom = zipFile.getParameter(0).asSink() and
  //       nodeTo = zipFile.asSource()
  //     )
  //   }
  // }
  // API::Node rubyZipNode2() {
  //   result = zipFile().getMethod("open")
  //   or
  //   result = rubyZipNode2().getMethod(_)
  //   or
  //   result = rubyZipNode2().getReturn()
  //   or
  //   result = rubyZipNode2().getParameter(_)
  //   or
  //   result = rubyZipNode2().getAnElement()
  //   or
  //   result = rubyZipNode2().getBlock()
  // }
  // /**
  //  * The additional taint steps that need for creating taint tracking or dataflow for `Zip::File`.
  //  */
  // class AdditionalTaintStep2 extends DecompressionBomb::AdditionalTaintStep {
  //   AdditionalTaintStep2() { this = "AdditionalTaintStep" }
  //   override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  //     exists(API::Node zipFileOpen | zipFileOpen = rubyZipNode2() |
  //       nodeFrom = zipFileOpen.getReturn().asSource() and
  //       nodeTo = zipFileOpen.getMethod(["extract", "read"]).getReturn().asSource()
  //     )
  //   }
  // }
  // /**
  //  * The additional taint steps that need for creating taint tracking or dataflow for `Zip::File`.
  //  */
  // class AdditionalTaintStep3 extends DecompressionBomb::AdditionalTaintStep {
  //   AdditionalTaintStep3() { this = "AdditionalTaintStep" }
  //   override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  //     exists(API::Node zipFileOpen | zipFileOpen = rubyZipNode2() |
  //       nodeFrom = zipFileOpen.asCall() and
  //       nodeTo = zipFileOpen.getMethod(["extract", "read"]).getReturn().asSource()
  //     )
  //   }
  // }
}
