/**
 * Provides utility classes and predicates for reasoning about `Kernel.open` and related methods.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.core.Kernel::Kernel

/** A call to a method that might access a file or start a process. */
class AmbiguousPathCall extends DataFlow::CallNode {
  string name;

  AmbiguousPathCall() {
    this.(KernelMethodCall).getKernelMethod() = "open" and
    name = "Kernel.open"
    or
    this = API::getTopLevelMember("IO").getAMethodCall("read") and
    not this = API::getTopLevelMember("File").getAMethodCall("read") and // needed in e.g. opal/opal, where some calls have both paths, but I'm not sure why
    name = "IO.read"
  }

  /** Gets the name for the method being called. */
  string getName() { result = name }

  /** Gets the name for a safer method that can be used instead. */
  string getReplacement() {
    result = "File.read" and name = "IO.read"
    or
    result = "File.open" and name = "Kernel.open"
  }

  /** Gets the argument that specifies the path to be accessed. */
  DataFlow::Node getPathArgument() { result = this.getArgument(0) }
}
