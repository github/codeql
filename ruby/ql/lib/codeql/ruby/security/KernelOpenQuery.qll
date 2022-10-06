/**
 * Provides a utility classes and predicates for queries reasoning about Kernel.open and related methods.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.core.Kernel::Kernel

/** A call to a method that might access a file or start a process. */
abstract class AmbiguousPathCall extends DataFlow::CallNode {
  /** Gets the name for the method being called. */
  abstract string getName();

  /** Gets the name for a safer method that can be used instead. */
  abstract string getReplacement();

  /** Gets the argument that specifies the path to be accessed. */
  abstract DataFlow::Node getPathArgument();
}

private class KernelOpenCall extends KernelMethodCall, AmbiguousPathCall {
  KernelOpenCall() { this.getMethodName() = "open" }

  override string getName() { result = "Kernel.open" }

  override string getReplacement() { result = "File.open" }

  override DataFlow::Node getPathArgument() { result = this.getArgument(0) }
}

private class IOReadCall extends DataFlow::CallNode, AmbiguousPathCall {
  IOReadCall() {
    this = API::getTopLevelMember("IO").getAMethodCall("read") and
    not this = API::getTopLevelMember("File").getAMethodCall("read") // needed in e.g. opal/opal, where some calls have both paths, but I'm not sure why
  }

  override string getName() { result = "IO.read" }

  override string getReplacement() { result = "File.read" }

  override DataFlow::Node getPathArgument() { result = this.getArgument(0) }
}
