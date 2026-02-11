import javascript
import experimental.semmle.javascript.FormParsers
import experimental.semmle.javascript.ReadableStream

module DecompressionBomb {
  /**
   * The Sinks of uncontrolled data decompression
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

/**
 * Provides additional taint steps for Readable Stream object
 */
module ReadableStream {
  class ReadableStreamAdditionalTaintStep extends DecompressionBomb::AdditionalTaintStep {
    ReadableStreamAdditionalTaintStep() { this = "AdditionalTaintStep" }

    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      (
        readablePipeAdditionalTaintStep(pred, succ)
        or
        streamPipelineAdditionalTaintStep(pred, succ)
        or
        promisesFileHandlePipeAdditionalTaintStep(pred, succ)
      )
    }
  }
}

/**
 * Provides additional taint steps for File system access functions
 */
module FileSystemAccessAdditionalTaintStep {
  class ReadableStreamAdditionalTaintStep extends DecompressionBomb::AdditionalTaintStep {
    ReadableStreamAdditionalTaintStep() { this = "AdditionalTaintStep" }

    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      // additional taint step for fs.readFile(pred)
      // It can be global additional step too
      exists(DataFlow::CallNode n | n = DataFlow::moduleMember("fs", "readFile").getACall() |
        pred = n.getArgument(0) and succ = n.getABoundCallbackParameter(1, 1)
      )
      or
      exists(FileSystemReadAccess cn |
        pred = cn.getAPathArgument() and
        succ = cn.getADataNode()
      )
    }
  }
}

/**
 * Provides Models for [jszip](https://www.npmjs.com/package/jszip) package
 */
module JsZip {
  /**
   * The decompression bomb sinks
   */
  class DecompressionBomb extends DecompressionBomb::Range {
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

/**
 * Provides Models for [node-tar](https://www.npmjs.com/package/tar) package
 */
module NodeTar {
  /**
   * The decompression bomb sinks
   */
  class DecompressionBomb extends DecompressionBomb::Range {
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

  /**
   * The decompression Additional Taint Steps
   */
  class DecompressionAdditionalSteps extends DecompressionBomb::AdditionalTaintStep {
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

/**
 * Provides Models for `node:zlib` package
 */
module Zlib {
  /**
   * The decompression sinks of `node:zlib`
   */
  class DecompressionBomb extends DecompressionBomb::Range {
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

/**
 * Provides Models for [pako](https://www.npmjs.com/package/pako) package
 */
module Pako {
  /**
   * The decompression bomb sinks
   */
  class DecompressionBomb extends DecompressionBomb::Range {
    DecompressionBomb() {
      this = API::moduleImport("pako").getMember(["inflate", "inflateRaw", "ungzip"])
    }

    override DataFlow::Node sink() { result = this.getParameter(0).asSink() }
  }

  /**
   * The decompression Additional Taint Steps
   */
  class DecompressionAdditionalSteps extends DecompressionBomb::AdditionalTaintStep {
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

/**
 * Provides Models for [adm-zip](https://www.npmjs.com/package/adm-zip) package
 */
module AdmZip {
  /**
   * The decompression bomb sinks
   */
  class DecompressionBomb extends DecompressionBomb::Range {
    DecompressionBomb() { this = API::moduleImport("adm-zip").getInstance() }

    override DataFlow::Node sink() {
      result =
        this.getMember(["extractAllTo", "extractEntryTo", "readAsText"]).getReturn().asSource()
      or
      result = this.getASuccessor*().getMember("getData").getReturn().asSource()
    }
  }

  /**
   * The decompression Additional Taint Steps
   */
  class DecompressionAdditionalSteps extends DecompressionBomb::AdditionalTaintStep {
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

/**
 * Provides Models for [decompress](https://www.npmjs.com/package/decompress) package
 */
module Decompress {
  /**
   * The decompression bomb sinks
   */
  class DecompressionBomb extends DecompressionBomb::Range {
    DecompressionBomb() { this = API::moduleImport("decompress") }

    override DataFlow::Node sink() { result = this.getACall().getArgument(0) }
  }
}

/**
 * Provides Models for [gunzip-maybe][https://www.npmjs.com/package/gunzip-maybe] package
 */
module GunzipMaybe {
  /**
   * The decompression bomb sinks
   */
  class DecompressionBomb extends DecompressionBomb::Range {
    DecompressionBomb() { this = API::moduleImport("gunzip-maybe") }

    override DataFlow::Node sink() { result = this.getACall() }
  }
}

/**
 * Provides Models for [unbzip2-stream](https://www.npmjs.com/package/unbzip2-stream) package
 */
module Unbzip2Stream {
  /**
   * The decompression bomb sinks
   */
  class DecompressionBomb extends DecompressionBomb::Range {
    DecompressionBomb() { this = API::moduleImport("unbzip2-stream") }

    override DataFlow::Node sink() { result = this.getACall() }
  }
}

/**
 * Provides Models for [unzipper](https://www.npmjs.com/package/unzipper) package
 */
module Unzipper {
  /**
   * The decompression bomb sinks
   */
  class DecompressionBomb extends DecompressionBomb::Range {
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

/**
 * Provides Models for [yauzl](https://www.npmjs.com/package/yauzl) package
 */
module Yauzl {
  API::Node test() { result = API::moduleImport("yauzl").getASuccessor*() }

  /**
   * The decompression bomb sinks
   */
  class DecompressionBomb extends DecompressionBomb::Range {
    // open function has a sanitizer
    string methodName;

    DecompressionBomb() {
      this =
        API::moduleImport("yauzl").getMember(["fromFd", "fromBuffer", "fromRandomAccessReader"]) and
      methodName = "from"
      or
      this = API::moduleImport("yauzl").getMember("open") and
      methodName = "open"
    }

    override DataFlow::Node sink() {
      (
        result = this.getParameter(2).getParameter(1).getMember("readEntry").getACall() or
        result =
          this.getParameter(2)
              .getParameter(1)
              .getMember("openReadStream")
              .getParameter(1)
              .getParameter(1)
              .asSource()
      ) and
      not this.sanitizer() and
      methodName = "open"
      or
      result = this.getParameter(0).asSink() and
      methodName = "from"
    }

    /**
     * Gets a
     * and Holds if yauzl `open` instance has a member `uncompressedSize`
     */
    predicate sanitizer() {
      exists(this.getASuccessor*().getMember("uncompressedSize")) and
      methodName = ["readStream", "open"]
    }
  }

  /**
   * The decompression Additional Taint Steps
   */
  class DecompressionAdditionalSteps extends DecompressionBomb::AdditionalTaintStep {
    DecompressionAdditionalSteps() { this = "AdditionalTaintStep" }

    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(API::Node open | open = API::moduleImport("yauzl").getMember("open") |
        pred = open.getParameter(0).asSink() and
        (
          succ = open.getParameter(2).getParameter(1).getMember("readEntry").getACall() or
          succ =
            open.getParameter(2)
                .getParameter(1)
                .getMember("openReadStream")
                .getParameter(1)
                .getParameter(1)
                .asSource()
        )
      )
    }
  }
}
