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

/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * zip slip vulnerabilities, as well as extension points for
 * adding your own.
 */
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
  private class GzipReaderOpen extends Source {
    GzipReaderOpen() {
      (
        this = API::getTopLevelMember("Zlib").getMember("GzipReader").getReturn("open").asSource()
        or
        this = API::getTopLevelMember("Zlib").getMember("GzipReader").getInstance().asSource()
      ) and
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
  private class TarReaderInstance extends Source {
    TarReaderInstance() {
      exists(API::MethodAccessNode newTarReader |
        newTarReader =
          API::getTopLevelMember("Gem").getMember("Package").getMember("TarReader").getMethod("new")
      |
        // Unlike in two other modules, there's no check for the constant path because TarReader class is called with an `io` object and not filepath.
        // This, of course, can be modeled but probably in the internal IO.qll file
        // For now, I'm leaving this prone to false-positives
        not exists(newTarReader.getBlock()) and this = newTarReader.getReturn().asSource()
        or
        this = newTarReader.getBlock().getParameter(0).asSource()
      )
    }
  }

  /**
   * A call to `Zip::File.open(path)`, considered a flow source.
   */
  private class ZipFileOpen extends Source {
    ZipFileOpen() {
      exists(API::MethodAccessNode zipOpen |
        zipOpen = API::getTopLevelMember("Zip").getMember("File").getMethod("open") and
        // If argument refers to a string object, then it's a hardcoded path and
        // this file is safe.
        not zipOpen
            .asCall()
            .getArgument(0)
            .getALocalSource()
            .getConstantValue()
            .isStringlikeValue(_)
      |
        // the case with variable assignment `zip_file = Zip::File.open(path)`
        not exists(zipOpen.getBlock()) and this = zipOpen.getReturn().asSource()
        or
        // the case with direct block`Zip::File.open(path) do |zip_file|` case
        this = zipOpen.getBlock().getParameter(0).asSource()
      )
    }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  private class StringConstCompareAsSanitizer extends Sanitizer, StringConstCompareBarrier { }

  /**
   * An inclusion check against an array of constant strings, considered as a
   * sanitizer-guard.
   */
  private class StringConstArrayInclusionCallAsSanitizer extends Sanitizer,
    StringConstArrayInclusionCallBarrier
  { }

  /**
   * A sanitizer like `File.expand_path(path).start_with?` where `path` is a path of a single entry inside the archive.
   * It is assumed that if `File.expand_path` is called, it is to verify the path is safe so there's no modeling of `start_with?` or other comparisons to avoid false-negatives.
   */
  private class ExpandedPathStartsWithAsSanitizer extends Sanitizer {
    ExpandedPathStartsWithAsSanitizer() {
      exists(DataFlow::CallNode cn |
        cn.getMethodName() = "expand_path" and
        this = cn.getArgument(0)
      )
    }
  }

  /**
   * Existing PathSanitization model created for regular path traversals
   */
  private class PathSanitizationAsSanitizer extends Sanitizer instanceof Path::PathSanitization { }
}
