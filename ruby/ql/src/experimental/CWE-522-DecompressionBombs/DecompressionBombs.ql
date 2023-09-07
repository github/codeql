/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id rb/user-controlled-file-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import codeql.ruby.AST
import codeql.ruby.frameworks.Files
import codeql.ruby.ApiGraphs
import codeql.ruby.DataFlow
import codeql.ruby.dataflow.RemoteFlowSources
import codeql.ruby.TaintTracking
import DataFlow::PathGraph

module DecompressionBombs {
  abstract class DecompressionBombSink extends DataFlow::Node { }

  module Zlib {
    /**
     * `Zlib::GzipReader`
     * > Note that if you use the lower level Zip::InputStream interface, rubyzip does not check the entry sizes.
     *
     * according to above warning from Doc we don't need to go forward after open()
     * or new() methods, we just need the argument node of them
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
    class ZipSink extends DecompressionBombSink {
      ZipSink() {
        this = gzipReaderInstance().getMethod(["open", "new", "zcat"]).getReturn().asSource()
      }
    }

    predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(API::Node zipnode | zipnode = gzipReaderInstance().getMethod(["open", "new", "zcat"]) |
        nodeFrom = zipnode.getParameter(0).asSink() and
        nodeTo = zipnode.getReturn().asSource()
      )
    }
  }

  module ZipInputStream {
    /**
     * `Zip::InputStream`
     * > Note that if you use the lower level Zip::InputStream interface, rubyzip does not check the entry sizes.
     *
     * according to above warning from Doc we don't need to go forward after open()
     * or new() methods, we just need the argument node of them
     */
    private API::Node zipInputStream() {
      result = API::getTopLevelMember("Zip").getMember("InputStream")
    }

    /**
     * A return values of following methods
     * `ZipIO.read`
     * `ZipEntry.extract`
     */
    class ZipSink extends DecompressionBombSink {
      ZipSink() {
        this = zipInputStream().getMethod(["open", "new"]).getReturn().asSource() and
        not this.getLocation().getFile().getBaseName().matches("%spec%")
      }
    }

    predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(API::Node zipnode | zipnode = zipInputStream().getMethod(["open", "new"]) |
        nodeFrom = zipnode.getParameter(0).asSink() and
        nodeTo = zipnode.getReturn().asSource()
      )
    }
  }

  module ZipFile {
    API::Node rubyZipNode() {
      result = zipFile()
      or
      result = rubyZipNode().getMethod(_)
      or
      result = rubyZipNode().getReturn()
      or
      result = rubyZipNode().getParameter(_)
      or
      result = rubyZipNode().getAnElement()
      or
      result = rubyZipNode().getBlock()
    }

    /**
     * A return values of following methods
     * `ZipIO.read`
     * `ZipEntry.extract`
     * sanitize the nodes which have `entry.size > someOBJ`
     */
    class ZipSink extends DecompressionBombSink {
      ZipSink() {
        exists(API::Node zipnodes | zipnodes = rubyZipNode() |
          this = zipnodes.getMethod(["extract", "read"]).getReturn().asSource() and
          not exists(zipnodes.getMethod("size").getReturn().getMethod(">").getParameter(0))
        )
      }
    }

    predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(API::Node zipnodes | zipnodes = rubyZipNode() |
        nodeTo = zipnodes.getMethod(["extract", "read"]).getReturn().asSource() and
        nodeFrom = zipnodes.getMethod(["new", "open"]).getParameter(0).asSink()
      )
    }

    /**
     * `Zip::File`
     */
    API::Node zipFile() { result = API::getTopLevelCall("Zip").getMember("File") }
  }
}

/**
 * A call to `IO.copy_stream`
 */
class IoCopyStream extends DataFlow::CallNode {
  IoCopyStream() { this = API::getTopLevelMember("IO").getAMethodCall("copy_stream") }

  DataFlow::Node getAPathArgument() { result = this.getArgument(0) }
}

class Bombs extends TaintTracking::Configuration {
  Bombs() { this = "Decompression Bombs" }

  override predicate isSanitizer(DataFlow::Node node) {
    not node.getLocation().hasLocationInfo("%spec%", _, _, _, _)
  }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
    // or
    // source instanceof DataFlow::LocalSourceNode
    // source = API::getTopLevelCall("Zip").getMember("InputStream").getASuccessor*()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof DecompressionBombs::DecompressionBombSink
  }

  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    DecompressionBombs::ZipFile::isAdditionalTaintStep(nodeFrom, nodeTo)
    or
    DecompressionBombs::ZipInputStream::isAdditionalTaintStep(nodeFrom, nodeTo)
    or
    DecompressionBombs::Zlib::isAdditionalTaintStep(nodeFrom, nodeTo)
    or
    exists(API::Node n | n = API::root().getMember("File").getMethod("open") |
      nodeFrom = n.getParameter(0).asSink() and
      nodeTo = n.getReturn().asSource()
    )
    or
    exists(File::FileOpen n |
      nodeFrom = n.getAPathArgument() and
      nodeTo = n
    )
    or
    exists(API::Node n | n = API::root().getMember("StringIO").getMethod("new") |
      nodeFrom = n.getParameter(0).asSink() and
      nodeTo = n.getReturn().asSource()
    )
    or
    exists(IoCopyStream n |
      nodeFrom = n.getAPathArgument() and
      nodeTo = n
    )
    or
    // following can be a global additional step
    exists(DataFlow::CallNode cn |
      cn.getMethodName() = "open" and cn.getReceiver().toString() = "self"
    |
      nodeFrom = cn.getArgument(0) and
      nodeTo = cn
    )
  }
}

from Bombs cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This file extraction depends on a $@.", source.getNode(),
  "potentially untrusted source"
