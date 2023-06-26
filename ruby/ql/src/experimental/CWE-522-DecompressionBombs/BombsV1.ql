/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs could be dangerous
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
import codeql.ruby.ApiGraphs
import codeql.ruby.DataFlow
import codeql.ruby.dataflow.RemoteFlowSources
import codeql.ruby.TaintTracking
import DataFlow::PathGraph

module Zip {
  module InputStream {
    /**
     * `Zip::InputStream`
     */
    private API::Node zipInputStream() {
      result = [API::getTopLevelMember("Zip").getMember("InputStream")]
    }

    /**
     * An input in following
     * ```ruby
     * input = ip::InputStream.open(path)
     * Zip::InputStream.open(path) do |input|
     *    ...
     * end
     * ```
     */
    private API::Node instance() {
      result =
        zipInputStream().getMethod("open").(GetReturnOrGetBlock).getReturnOrGetBlockParameter()
    }

    predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(API::Node zipInputStreamOpen |
        zipInputStreamOpen = zipInputStream().getMethod("open")
      |
        nodeFrom = zipInputStreamOpen.getParameter(0).asSink() and
        nodeTo =
          [
            zipInputStreamOpen
                .(GetReturnOrGetBlock)
                .getReturnOrGetBlockParameter()
                .getMethod(_)
                .getReturn()
                .asSource()
          ]
      )
    }

    DataFlow::Node isSink() {
      exists(string ioMethods | not ioMethods = "get_next_entry" |
        result = instance().getMethod(ioMethods).getReturn().asSource()
      )
    }
  }

  class AdditionalGlobStep extends API::Node {
    API::Node additionalGlobStepHelper() {
      result = this
      or
      result = this.getMethod("glob").getReturn()
    }
  }

  class GetReturnOrGetBlock extends API::Node {
    API::Node getReturnOrGetBlockParameter() {
      result = this.getBlock().getParameter(0) or
      result = this.getReturn()
    }
  }

  module File {
    /**
     * ```ruby
     * Zip::File.open(path)
     * # or
     * Zip::File.new(path)
     * ```
     */
    module OpenAndNew {
      /**
       * myZip in following
       *
       * ```ruby
       * myZip = Zip::File.open(path)
       * # or
       * myZip = Zip::File.new(path)
       *
       * Zip::File.open(path) do |myZip|
       *
       *   end
       * ```
       */
      API::Node instance() {
        result =
          zipFile().getMethod(["open", "new"]).(GetReturnOrGetBlock).getReturnOrGetBlockParameter()
      }

      /**
       * `extract` and `read` can be sink
       *  ```ruby
       *  ```
       */
      DataFlow::Node isSink() {
        result =
          instance()
              .getMethod(["each", "each_entry", "first"])
              .getBlock()
              .getParameter(0)
              .getMethod(["extract", "read", "first"])
              .getReturn()
              .asSource()
        or
        result =
          instance()
              .getMethod(["each", "each_entry", "first"])
              .getBlock()
              .getParameter(0)
              .getMethod("get_input_stream")
              .getReturn()
              .asSource()
        or
        exists(string ioMethods | not ioMethods = ["each", "each_entry", "glob", "first"] |
          result = instance().getAMethodCall(ioMethods)
        )
      }

      predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        exists(API::Node zipFileOpen, API::Node zipFileOpenGlob |
          zipFileOpen = zipFile().getMethod(["open", "new"])
        |
          nodeFrom = zipFileOpen.getParameter(0).asSink() and
          zipFileOpenGlob = zipFileOpen.(GetReturnOrGetBlock).getReturnOrGetBlockParameter() and
          nodeTo =
            [
              zipFileOpen
                  .(GetReturnOrGetBlock)
                  .getReturnOrGetBlockParameter()
                  .(AdditionalGlobStep)
                  .additionalGlobStepHelper()
                  .asSource(),
              zipFileOpen
                  .(GetReturnOrGetBlock)
                  .getReturnOrGetBlockParameter()
                  .(AdditionalGlobStep)
                  .additionalGlobStepHelper()
                  .getMethod(["read", "extract"])
                  .getReturn()
                  .asSource(),
              zipFileOpen
                  .(GetReturnOrGetBlock)
                  .getReturnOrGetBlockParameter()
                  .(AdditionalGlobStep)
                  .additionalGlobStepHelper()
                  .getMethod(["each", "each_entry", "first"])
                  .getBlock()
                  .getParameter(0)
                  .asSource(),
              isAdditionalTaintStepHelper(zipFileOpen
                    .(GetReturnOrGetBlock)
                    .getReturnOrGetBlockParameter()
                    .(AdditionalGlobStep)
                    .additionalGlobStepHelper()
                    .getMethod(["each", "each_entry", "first"])
                    .getBlock()
                    .getParameter(0))
            ]
        )
      }
    }

    /**
     * # Find specific entry with Zip::File.open(zipfile_path).glob(pattern)
     */
    module Glob {
      /**
       * `extract` and `read` can be sink
       *  ```ruby
       *  ```
       */
      DataFlow::Node isSink() {
        result =
          zipFile()
              .getMethod(["open", "new"])
              .getReturn()
              .getMethod("glob")
              .getBlock()
              .getParameter(0)
              .getMethod("get_input_stream")
              .getReturn()
              .asSource()
        or
        result =
          zipFile()
              .getMethod(["open", "new"])
              .getReturn()
              .getMethod("glob")
              .getReturn()
              .getMethod("get_input_stream")
              .getReturn()
              .asSource()
        or
        result =
          zipFile()
              .getMethod(["open", "new"])
              .getBlock()
              .getParameter(0)
              .getMethod("glob")
              .getReturn()
              .getMethod("first")
              .getReturn()
              .getMethod("get_input_stream")
              .getReturn()
              .asSource()
      }

      predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        exists(API::Node zipFileOpen | zipFileOpen = zipFile().getMethod(["open", "new"]) |
          nodeFrom = zipFileOpen.getParameter(0).asSink() and
          nodeTo =
            isAdditionalTaintStepHelper(zipFileOpen
                  .(GetReturnOrGetBlock)
                  .getReturnOrGetBlockParameter()
                  .getMethod("glob")
                  .(GetReturnOrGetBlock)
                  .getReturnOrGetBlockParameter())
        )
      }
    }

    /**
     * `Zip::File`
     */
    private API::Node zipFile() { result = API::getTopLevelMember("Zip").getMember("File") }

    DataFlow::Node isAdditionalTaintStepHelper(API::Node nodeMiddle) {
      result = nodeMiddle.getMethod(_).getReturn().asSource() or
      result = nodeMiddle.getMethod(_).getReturn().getMethod(_).getReturn().asSource()
    }
  }

  DataFlow::Node isSink() {
    result = [File::Glob::isSink(), File::OpenAndNew::isSink(), InputStream::isSink()]
  }

  predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    File::Glob::isAdditionalTaintStep(nodeFrom, nodeTo)
    or
    File::OpenAndNew::isAdditionalTaintStep(nodeFrom, nodeTo)
    or
    InputStream::isAdditionalTaintStep(nodeFrom, nodeTo)
  }
}

module Zlib {
  /**
   * `zlib::GzipReader`
   */
  API::Node gzipReaderInstance() { result = API::getTopLevelMember("Zlib").getMember("GzipReader") }

  API::Node gzipReaderOpen() {
    result =
      [
        gzipReaderInstance().getMethod("open").getReturn(),
        gzipReaderInstance().getMethod("open").getBlock().getParameter(0)
      ]
  }

  API::Node gzipReaderNew() { result = gzipReaderInstance().getMethod("new").getReturn() }

  /**
   * `entry` and `read` can be sink
   *  ```ruby
   *Zlib::GzipReader.open(gzip_path) do |uncompressedfile|
   *  uncompressedfile.each do |entry|
   *    entry
   *  end
   *end
   *
   *uncompressedfile = Zlib::GzipReader.open(gzip_path)
   *uncompressedfile.each do |entry|
   *  entry
   *end
   *
   *Zlib::GzipReader.new(File.open(gzip_path, 'rb')).read
   *Zlib::GzipReader.new(File.open(gzip_path, 'rb')).each do |entry|
   *  entry
   *end
   *  ```
   */
  DataFlow::Node isSink() {
    result =
      gzipReaderOpen()
          .getMethod(["glob", "each", "each_entry"])
          .getBlock()
          .getParameter(0)
          .asSource()
    or
    result =
      gzipReaderNew()
          .getMethod(["glob", "each", "each_entry"])
          .getBlock()
          .getParameter(0)
          .asSource()
    or
    // _ is one of ["read", "readlines", "readpartial", "readline", "gets"] and more because gzipReader return an IO instance, there are a lot of methods and gzipReader is for reading gzip files, so there is low FP rate here if we use _ instead of exact IO method names
    exists(string ioMethods | not ioMethods = ["glob", "each", "each_entry"] |
      result = gzipReaderNew().getMethod(ioMethods).getReturn().asSource() or
      result = gzipReaderOpen().getMethod(ioMethods).getReturn().asSource()
    )
    or
    // no need for any other methods after opening gzip with zcat method
    result = gzipReaderInstance().getMethod("zcat").getParameter(0).asSink()
  }

  predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    isAdditionalTaintStepCustomizeMiddleNode(nodeFrom, nodeTo, gzipReaderOpen()) or
    isAdditionalTaintStepCustomizeBeginningNode(nodeFrom, nodeTo, "open", gzipReaderInstance()) or
    isAdditionalTaintStepCustomizeMiddleNode(nodeFrom, nodeTo, gzipReaderNew()) or
    isAdditionalTaintStepCustomizeBeginningNode(nodeFrom, nodeTo, "new", gzipReaderInstance()) or
    isAdditionalTaintStepCustomizeBeginningNode(nodeFrom, nodeTo, "zcat", gzipReaderInstance())
  }

  /**
   * `uncompressedfile` is nodeFrom/nodeMiddle
   *
   * `entry` is nodeTo
   *
   * ```ruby
   * Zlib::GzipReader.open(gzip_path) do |uncompressedfile|
   *  uncompressedfile.each do |entry|
   *    entry.bytes
   *  end
   *end
   *uncompressedfile = Zlib::GzipReader.open(gzip_path)
   *uncompressedfile.each do |entry|
   *  entry.read
   *end
   * ```
   */
  predicate isAdditionalTaintStepCustomizeMiddleNode(
    DataFlow::Node nodeFrom, DataFlow::Node nodeTo, API::Node nodeMiddle
  ) {
    nodeFrom = nodeMiddle.asSource() and
    nodeTo =
      nodeMiddle.getMethod(["glob", "each", "each_entry"]).getBlock().getParameter(0).asSource()
  }

  /**
   * `gzip_path` is nodeFrom
   *
   * `compressed_file`/`Zlib::GzipReader.open(gzip_path)` are nodeTo
   *
   * `Zlib::GzipReader` is nodeInstance
   *
   * `open` is beginMethodName
   *   ```ruby
   *Zlib::GzipReader.open(gzip_path) do |compressed_file|
   *  compressed_file.each do |entry|
   *    entry.bytes
   *  end
   *end
   *```
   */
  predicate isAdditionalTaintStepCustomizeBeginningNode(
    DataFlow::Node nodeFrom, DataFlow::Node nodeTo, string beginMethodName, API::Node nodeInstance
  ) {
    nodeFrom = nodeInstance.getMethod(beginMethodName).getParameter(0).asSink() and
    nodeTo =
      [
        nodeInstance.getMethod(beginMethodName).getBlock().getParameter(0).asSource(),
        nodeInstance
            .getMethod(beginMethodName)
            .getBlock()
            .getParameter(0)
            .getMethod(_)
            .getReturn()
            .asSource(), nodeInstance.getMethod(beginMethodName).getReturn().asSource(),
        nodeInstance.getMethod(beginMethodName).getReturn().getMethod(_).getReturn().asSource()
      ]
  }
}

class Bombs extends TaintTracking::Configuration {
  Bombs() { this = "Decompression Bombs" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource or
    source instanceof DataFlow::LocalSourceNode
  }

  override predicate isSink(DataFlow::Node sink) { sink = [Zip::isSink(), Zlib::isSink()] }

  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    Zip::isAdditionalTaintStep(nodeFrom, nodeTo)
    or
    Zlib::isAdditionalTaintStep(nodeFrom, nodeTo)
    or
    exists(API::Node n | n = API::root().getMember("File").getMethod("open") |
      nodeFrom = n.getParameter(0).asSink() and
      nodeTo = n.getReturn().asSource()
    )
    or
    exists(API::Node n | n = API::root().getMember("StringIO").getMethod("new") |
      nodeFrom = n.getParameter(0).asSink() and
      nodeTo = n.getReturn().asSource()
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
