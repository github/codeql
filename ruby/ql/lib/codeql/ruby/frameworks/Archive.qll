/**
 * Provides classes for working with archive libraries.
 */

private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs

/**
 * Classes and predicates for modeling the RubyZip library
 */
module RubyZip {
  /**
   * A call to `Zip::File.new`, considered as a `FileSystemAccess`
   */
  class RubyZipFileNew extends DataFlow::CallNode, FileSystemAccess::Range {
    RubyZipFileNew() { this = API::getTopLevelMember("Zip").getMember("File").getAnInstantiation() }

    override DataFlow::Node getAPathArgument() { result = this.getArgument(0) }
  }

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
