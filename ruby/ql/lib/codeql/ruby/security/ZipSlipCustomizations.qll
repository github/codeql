/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * zip slip vulnerabilities, as well as extension points for
 * adding your own.
 */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.CFG
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.BarrierGuards
private import codeql.ruby.dataflow.RemoteFlowSources

module ZipSlip {
  /**
   * A data flow source for zip slip vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for zip slip vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for zip slip vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A file system access, considered as a flow sink.
   */
  class FileSystemAccessAsSink extends Sink {
    FileSystemAccessAsSink() { this = any(FileSystemAccess e).getAPathArgument() }
  }

  /**
   * A call to `Zlib::GzipReader.open(path)`, considered a flow source.
   */
  class GzipReaderOpen extends Source {
    GzipReaderOpen() {
      this = API::getTopLevelMember("Zlib").getMember("GzipReader").getReturn("open").asSource() and
      // If argument refers to a string object, then it's a hardcoded path and
      // this file is safe.
      not this.(DataFlow::CallNode)
          .getArgument(0)
          .getALocalSource()
          .getConstantValue()
          .isStringlikeValue(_)
    }
  }

  /**
   * A call to `Gem::Package::TarReader.new(file_stream)`, considered a flow source.
   */
  class TarReaderInstance extends Source {
    TarReaderInstance() {
      this =
        API::getTopLevelMember("Gem")
            .getMember("Package")
            .getMember("TarReader")
            .getInstance()
            .asSource() and
      // If argument refers to a string object, then it's a hardcoded path and
      // this file is safe.
      not this.(DataFlow::CallNode)
          .getArgument(0)
          .getALocalSource()
          .getConstantValue()
          .isStringlikeValue(_)
    }
  }

  /**
   * A call to `Zip::File.open(path)`, considered a flow source.
   */
  class ZipFileOpen extends Source {
    ZipFileOpen() {
      this = API::getTopLevelMember("Zip").getMember("File").getReturn("open").asSource() and
      // If argument refers to a string object, then it's a hardcoded path and
      // this file is safe.
      not this.(DataFlow::CallNode)
          .getArgument(0)
          .getALocalSource()
          .getConstantValue()
          .isStringlikeValue(_)
    }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizer extends Sanitizer, StringConstCompareBarrier { }

  /**
   * An inclusion check against an array of constant strings, considered as a
   * sanitizer-guard.
   */
  class StringConstArrayInclusionCallAsSanitizer extends Sanitizer,
    StringConstArrayInclusionCallBarrier { }

  /**
   * A sanitizer like `File.expand_path(path).start_with?` where `path` is a path of a single entry inside the archive.
   * It is assumed that if `File.expand_path` is called, it is to verify the path is safe so there's no modelling of `start_with?` or other comparisons to avoid false-negatives.
   */
  class ExpandedPathStartsWithAsSanitizer extends Sanitizer {
    ExpandedPathStartsWithAsSanitizer() {
      exists(DataFlow::CallNode cn |
        cn.getMethodName() = "expand_path" and
        this = cn.getArgument(0)
      )
    }
  }
}
