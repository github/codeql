/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs without checking the compression rate is dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id js/user-controlled-data-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import javascript
import semmle.javascript.frameworks.ReadableStream
import DataFlow::PathGraph

module DecompressionBomb {
  /**
   * the Sinks of uncontrolled data decompression
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
  abstract private class Range extends API::Node {
    /**
     * Gets the sink of responsible for decompression node
     *
     * it can be a path, stream of compressed data,
     * or a call to function that use pipe
     */
    abstract DataFlow::Node sink();
  }

  module ReadableStream {
    class ReadableStreamAdditionalTaintStep extends AdditionalTaintStep {
      ReadableStreamAdditionalTaintStep() { this = "AdditionalTaintStep" }

      override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
        // additional taint step for fs.readFile(pred)
        // It can be global additional step too
        exists(DataFlow::CallNode n | n = DataFlow::moduleMember("fs", "readFile").getACall() |
          pred = n.getArgument(0) and succ = n.getABoundCallbackParameter(1, 1)
        )
        or
        readablePipeAdditionalTaintStep(pred, succ)
        or
        streamPipelineAdditionalTaintStep(pred, succ)
        or
        promisesFileHandlePipeAdditionalTaintStep(pred, succ)
        or
        exists(FileSystemReadAccess cn |
          pred = cn.getAPathArgument() and
          succ = cn.getADataNode()
        )
      }
    }
  }

  module JsZip {
    /**
     * The decompression sinks of [jszip](https://www.npmjs.com/package/jszip) package
     */
    class DecompressionBomb extends Range {
      DecompressionBomb() { this = API::moduleImport("jszip").getMember("loadAsync") }

      override DataFlow::Node sink() {
        result = this.getParameter(0).asSink() and not this.sanitizer(this)
      }

      /**
       * Gets a jszip `loadAsync` instance
       * and Holds if member of name `uncompressedSize` exists
       */
      predicate sanitizer(API::Node loadAsync) {
        exists(loadAsync.getASuccessor*().getMember("_data").getMember("uncompressedSize"))
      }
    }
  }

  module NodeTar {
    /**
     * The decompression sinks of [node-tar](https://www.npmjs.com/package/tar) package
     */
    class DecompressionBomb extends Range {
      DecompressionBomb() { this = API::moduleImport("tar").getMember(["x", "extract"]) }

      override DataFlow::Node sink() {
        (
          // piping tar.x()
          result = this.getACall()
          or
          // tar.x({file: filename})
          result = this.getParameter(0).getMember("file").asSink()
        ) and
        // and there shouldn't be a  "maxReadSize: ANum" option
        not this.sanitizer(this.getParameter(0))
      }

      /**
       * Gets a options parameter that belong to a `tar` instance
       * and Holds if "maxReadSize: ANumber" option exists
       */
      predicate sanitizer(API::Node tarExtract) { exists(tarExtract.getMember("maxReadSize")) }
    }

    class DecompressionAdditionalSteps extends AdditionalTaintStep {
      DecompressionAdditionalSteps() { this = "AdditionalTaintStep" }

      override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
        exists(API::Node n | n = API::moduleImport("tar") |
          pred = n.asSource() and
          (
            succ = n.getMember("x").getACall() or
            succ = n.getMember("x").getACall().getArgument(0)
          )
        )
      }
    }
  }

  module Zlib {
    /**
     * The decompression sinks of `node:zlib`
     */
    class DecompressionBomb extends Range {
      boolean isSynk;

      DecompressionBomb() {
        this =
          API::moduleImport("zlib")
              .getMember([
                  "gunzip", "gunzipSync", "unzip", "unzipSync", "brotliDecompress",
                  "brotliDecompressSync", "inflateSync", "inflateRawSync", "inflate", "inflateRaw"
                ]) and
        isSynk = true
        or
        this =
          API::moduleImport("zlib")
              .getMember([
                  "createGunzip", "createBrotliDecompress", "createUnzip", "createInflate",
                  "createInflateRaw"
                ]) and
        isSynk = false
      }

      override DataFlow::Node sink() {
        result = this.getACall() and
        not this.sanitizer(this.getParameter(0)) and
        isSynk = false
        or
        result = this.getACall().getArgument(0) and
        not this.sanitizer(this.getParameter(1)) and
        isSynk = true
      }

      /**
       * Gets a options parameter that belong to a zlib instance
       * and Holds if "maxOutputLength: ANumber" option exists
       */
      predicate sanitizer(API::Node zlib) { exists(zlib.getMember("maxOutputLength")) }
    }
  }

  module Pako {
    /**
     * The decompression sinks of (pako)[https://www.npmjs.com/package/pako]
     */
    class DecompressionBomb extends Range {
      DecompressionBomb() {
        this = API::moduleImport("pako").getMember(["inflate", "inflateRaw", "ungzip"])
      }

      override DataFlow::Node sink() { result = this.getParameter(0).asSink() }
    }

    class DecompressionAdditionalSteps extends AdditionalTaintStep {
      DecompressionAdditionalSteps() { this = "AdditionalTaintStep" }

      override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
        // succ = new Uint8Array(pred)
        exists(DataFlow::Node n, NewExpr ne | ne = n.asExpr() |
          pred.asExpr() = ne.getArgument(0) and
          succ.asExpr() = ne and
          ne.getCalleeName() = "Uint8Array"
        )
      }
    }
  }

  module AdmZip {
    /**
     * The decompression sinks of (adm-zip)[https://www.npmjs.com/package/adm-zip]
     */
    class DecompressionBomb extends Range {
      DecompressionBomb() { this = API::moduleImport("adm-zip").getInstance() }

      override DataFlow::Node sink() {
        result =
          this.getMember(["extractAllTo", "extractEntryTo", "readAsText"]).getReturn().asSource()
        or
        result = this.getASuccessor*().getMember("getData").getReturn().asSource()
      }
    }

    class DecompressionAdditionalSteps extends AdditionalTaintStep {
      DecompressionAdditionalSteps() { this = "AdditionalTaintStep" }

      override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
        exists(API::Node n | n = API::moduleImport("adm-zip") |
          pred = n.getParameter(0).asSink() and
          (
            succ =
              n.getInstance()
                  .getMember(["extractAllTo", "extractEntryTo", "readAsText"])
                  .getReturn()
                  .asSource()
            or
            succ =
              n.getInstance()
                  .getMember("getEntries")
                  .getASuccessor*()
                  .getMember("getData")
                  .getReturn()
                  .asSource()
          )
        )
      }
    }
  }

  module Decompress {
    /**
     * The decompression sinks of (decompress)[https://www.npmjs.com/package/decompress]
     */
    class DecompressionBomb extends Range {
      DecompressionBomb() { this = API::moduleImport("decompress") }

      override DataFlow::Node sink() { result = this.getACall().getArgument(0) }
    }
  }

  module GunzipMaybe {
    /**
     * The decompression sinks of (gunzip-maybe)[https://www.npmjs.com/package/gunzip-maybe]
     */
    class DecompressionBomb extends Range {
      DecompressionBomb() { this = API::moduleImport("gunzip-maybe") }

      override DataFlow::Node sink() { result = this.getACall() }
    }
  }

  module Unbzip2Stream {
    /**
     * The decompression sinks of (unbzip2-stream)[https://www.npmjs.com/package/unbzip2-stream]
     */
    class DecompressionBomb extends Range {
      DecompressionBomb() { this = API::moduleImport("unbzip2-stream") }

      override DataFlow::Node sink() { result = this.getACall() }
    }
  }

  module Unzipper {
    /**
     * The decompression sinks of (unzipper)[https://www.npmjs.com/package/unzipper]
     */
    class DecompressionBomb extends Range {
      string funcName;

      DecompressionBomb() {
        this = API::moduleImport("unzipper").getMember(["Extract", "Parse", "ParseOne"]) and
        funcName = ["Extract", "Parse", "ParseOne"]
        or
        this = API::moduleImport("unzipper").getMember("Open") and
        // open has some functions which will be specified in sink predicate
        funcName = "Open"
      }

      override DataFlow::Node sink() {
        result = this.getMember(["buffer", "file", "url", "file"]).getACall().getArgument(0) and
        funcName = "Open"
        or
        result = this.getACall() and
        funcName = ["Extract", "Parse", "ParseOne"]
      }

      /**
       * Gets a
       * and Holds if unzipper instance has a member `uncompressedSize`
       *
       * it is really difficult to implement this sanitizer,
       * so i'm going to check if there is a member like `vars.uncompressedSize` in whole DB or not!
       */
      predicate sanitizer() {
        exists(this.getASuccessor*().getMember("vars").getMember("uncompressedSize")) and
        funcName = ["Extract", "Parse", "ParseOne"]
      }
    }
  }

  module Yauzl {
    /**
     * The decompression sinks of (yauzl)[https://www.npmjs.com/package/yauzl]
     */
    class DecompressionBomb extends Range {
      // open function has a sanitizer which we should label it with this boolean
      boolean isOpenFunc;

      DecompressionBomb() {
        this =
          API::moduleImport("yauzl")
              .getMember([
                  "fromFd", "fromBuffer", "fromRandomAccessReader", "fromRandomAccessReader"
                ]) and
        isOpenFunc = false
        or
        this = API::moduleImport("yauzl").getMember("open") and
        isOpenFunc = true
      }

      override DataFlow::Node sink() {
        result = this.getASuccessor*().getMember("readEntry").getACall() and
        not this.sanitizer() and
        isOpenFunc = true
        or
        result = this.getACall().getArgument(0) and
        isOpenFunc = false
      }

      /**
       * Gets a
       * and Holds if yauzl `open` instance has a member `uncompressedSize`
       */
      predicate sanitizer() {
        exists(this.getASuccessor*().getMember("uncompressedSize")) and
        isOpenFunc = true
      }
    }
  }
}

class BombConfiguration extends TaintTracking::Configuration {
  BombConfiguration() { this = "DecompressionBombs" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    sink instanceof DecompressionBomb::Sink
    // any()
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DecompressionBomb::AdditionalTaintStep addstep |
      addstep.isAdditionalTaintStep(pred, succ)
    )
  }
}

from BombConfiguration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This Decompression depends on a $@.", source.getNode(),
  "potentially untrusted source"
