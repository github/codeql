/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * zip slip vulnerabilities, as well as extension points for
 * adding your own.
 */

private import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.ApiGraphs
private import semmle.code.powershell.dataflow.flowsources.FlowSources
private import semmle.code.powershell.Cfg

module ZipSlip {
  /**
   * A data flow source for zip slip vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a string that describes the type of this flow source. */
    abstract string getSourceType();
  }

  /**
   * A data flow sink for zip slip vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    abstract string getSinkType();
  }

  /**
   * A sanitizer for zip slip vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * Access to the `FullName` property of the archive item
   */
  class ArchiveEntryFullName extends Source {
    ArchiveEntryFullName() {
      this =
        API::getTopLevelMember("system")
            .getMember("io")
            .getMember("compression")
            .getMember("zipfile")
            .getReturn("openread")
            .getMember("entries")
            .getAnElement()
            .getField("fullname")
            .asSource()
    }

    override string getSourceType() {
      result = "read of System.IO.Compression.ZipArchiveEntry.FullName"
    }
  }

  /**
   * Argument to extract to file extension method
   */
  class SinkCompressionExtractToFileArgument extends Sink {
    SinkCompressionExtractToFileArgument() {
      exists(DataFlow::CallNode call |
        call =
          API::getTopLevelMember("system")
              .getMember("io")
              .getMember("compression")
              .getMember("zipfileextensions")
              .getMember("extracttofile")
              .asCall() and
        this = call.getArgument(1)
      )
    }

    override string getSinkType() { result = "argument to archive extraction" }
  }

  class SinkFileOpenArgument extends Sink {
    SinkFileOpenArgument() {
      exists(DataFlow::CallNode call |
        call =
          API::getTopLevelMember("system")
              .getMember("io")
              .getMember("file")
              .getMethod(["open", "openwrite", "create"])
              .asCall() and
        this = call.getArgument(0)
      )
    }

    override string getSinkType() { result = "argument to file opening" }
  }

  private class ExternalZipSlipSink extends Sink {
    ExternalZipSlipSink() { this = ModelOutput::getASinkNode("zip-slip").asSink() }

    override string getSinkType() { result = "zip slip" }
  }
}
