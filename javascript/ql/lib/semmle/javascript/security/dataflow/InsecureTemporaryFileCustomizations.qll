/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * insecure temporary file creation, as well as
 * extension points for adding your own.
 */

import javascript

/**
 * Classes and predicates for reasoning about insecure temporary file creation.
 */
module InsecureTemporaryFile {
  /**
   * A data flow source for insecure temporary file creation.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for insecure temporary file creation.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for random insecure temporary file creation.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A call that opens a file with a given path. */
  class OpenFileCall extends DataFlow::CallNode {
    string methodName;

    OpenFileCall() {
      methodName =
        [
          "open", "openSync", "writeFile", "writeFileSync", "writeJson", "writeJSON",
          "writeJsonSync", "writeJSONSync", "outputJson", "outputJSON", "outputJsonSync",
          "outputJSONSync", "outputFile", "outputFileSync"
        ] and
      this = NodeJSLib::FS::moduleMember(methodName).getACall()
    }

    DataFlow::Node getPath() { result = this.getArgument(0) }

    DataFlow::Node getMode() {
      methodName = ["open", "openSync"] and
      result = this.getArgument(2)
      or
      not methodName = ["open", "openSync"] and
      result = this.getOptionArgument(2, "mode")
    }
  }

  /** Holds if the `mode` ensure no access to other users. */
  bindingset[mode]
  private predicate isSecureMode(int mode) {
    // the lowest 6 bits should be 0.
    // E.g. `0o600` is secure (each digit in a octal number is 3 bits)
    mode.bitAnd(1) = 0 and
    mode.bitAnd(2) = 0 and
    mode.bitAnd(4) = 0 and
    mode.bitAnd(8) = 0 and
    mode.bitAnd(16) = 0 and
    mode.bitAnd(32) = 0
  }

  /** The path in a call that opens a file without specifying a secure `mode`. Seen as a sink for insecure temporary file creation. */
  class InsecureFileOpen extends Sink {
    InsecureFileOpen() {
      exists(OpenFileCall call |
        not exists(call.getMode())
        or
        exists(int mode | mode = call.getMode().getIntValue() | not isSecureMode(mode))
      |
        this = call.getPath()
      )
    }
  }

  /** A string that references the global tmp dir. Seen as a source for insecure temporary file creation. */
  class OSTempDir extends Source {
    OSTempDir() {
      this = DataFlow::moduleImport("os").getAMemberCall("tmpdir")
      or
      this.getStringValue().matches("/tmp/%")
    }
  }

  /** A non-first leaf in a string-concatenation. Seen as a sanitizer for insecure temporary file creation. */
  class NonFirstStringConcatLeaf extends Sanitizer {
    NonFirstStringConcatLeaf() {
      exists(StringOps::ConcatenationRoot root |
        this = root.getALeaf() and
        not this = root.getFirstLeaf()
      )
      or
      exists(DataFlow::CallNode join |
        join = DataFlow::moduleMember("path", "join").getACall() and
        this = join.getArgument([1 .. join.getNumArgument() - 1])
      )
    }
  }
}
