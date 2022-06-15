/**
 * Provides classes for working with archive libraries.
 */

private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs

/**
 * Classes and predicates for modeling the RubyZip library
 */
module RubyZip {
  /**
   * A call to `Zip::File.open`, considered as a `FileSystemAccess`.
   */
  class RubyZipFileOpen extends DataFlow::CallNode, FileSystemAccess::Range {
    RubyZipFileOpen() {
      this = API::getTopLevelMember("Zip").getMember("File").getAMethodCall("open")
    }

    override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }
  }
}
