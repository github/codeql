/**
 * Provides utility classes and predicates for reasoning about `Kernel.open` and related methods.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.BarrierGuards
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.frameworks.core.Kernel::Kernel
private import codeql.ruby.frameworks.Files
private import codeql.ruby.TaintTracking

/** A call to a method that might access a file or start a process. */
class AmbiguousPathCall extends DataFlow::CallNode {
  string name;

  AmbiguousPathCall() {
    this.(KernelMethodCall).getMethodName() = "open" and
    name = "Kernel.open"
    or
    exists(string methodName |
      methodName = ["read", "write", "binread", "binwrite", "foreach", "readlines"]
    |
      methodCallOnlyOnIO(this, methodName) and
      name = "IO." + methodName
    )
    or
    this = API::getTopLevelMember("URI").getAMethodCall("open") and
    name = "URI.open"
  }

  /** Gets the name for the method being called. */
  string getName() { result = name }

  /** Gets the name for a safer method that can be used instead. */
  string getReplacement() {
    result = "File.open" and name = "Kernel.open"
    or
    result = "File.read" and name = "IO.read"
    or
    result = "File.write" and name = "IO.write"
    or
    result = "File.binread" and name = "IO.binread"
    or
    result = "File.binwrite" and name = "IO.binwrite"
    or
    result = "File.foreach" and name = "IO.foreach"
    or
    result = "File.readlines" and name = "IO.readlines"
    or
    result = "URI(<uri>).open" and name = "URI.open"
  }

  /** Gets the argument that specifies the path to be accessed. */
  DataFlow::Node getPathArgument() { result = this.getArgument(0) }
}

private predicate methodCallOnlyOnIO(DataFlow::CallNode node, string methodName) {
  // Use local flow to find calls to 'IO' without subclasses
  node = DataFlow::getConstant("IO").getAMethodCall(methodName) and
  not node = API::getTopLevelMember("File").getAMethodCall(methodName) // needed in e.g. opal/opal, where some calls have both paths (opal implements an own corelib)
}

/**
 * A sanitizer for kernel open vulnerabilities.
 */
abstract class Sanitizer extends DataFlow::Node { }

/**
 * If a `File.join` is performed the resulting string will not start with a pipe `|`.
 * This is true as long the tainted data doesn't flow into the first argument.
 */
private class FileJoinSanitizer extends Sanitizer {
  FileJoinSanitizer() { this = any(File::FileJoinSummary s).getParameter("1..") }
}

private module KernelOpenConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink = any(AmbiguousPathCall r).getPathArgument() }

  predicate isBarrier(DataFlow::Node node) {
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier or
    node instanceof Sanitizer
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for detecting insecure uses of `Kernel.open` and similar sinks.
 */
module KernelOpenFlow = TaintTracking::Global<KernelOpenConfig>;
