/**
 * Provides default sources, sinks and sanitizers for reasoning about code
 * constructed from libary input vulnerabilities, as well as extension points for
 * adding your own.
 */

import javascript

module UnsafeCodeConstruction {
  private import semmle.javascript.security.dataflow.CodeInjectionCustomizations::CodeInjection as CodeInjection
  private import semmle.javascript.PackageExports as Exports

  /**
   * A source for code constructed from library input vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A parameter of an exported function, seen as a source.
   */
  class ExternalInputSource extends Source, DataFlow::ParameterNode {
    ExternalInputSource() { this = Exports::getALibraryInputParameter() }
  }

  /**
   * A sink for unsafe code constructed from library input vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    abstract DataFlow::Node getCodeSink();
  }

  /**
   * Gets a node that is later executed as code in `codeSink`.
   */
  private DataFlow::Node isExecutedAsCode(DataFlow::TypeBackTracker t, CodeInjection::Sink codeSink) {
    t.start() and result = codeSink
    or
    exists(DataFlow::TypeBackTracker t2 | t2 = t.smallstep(result, isExecutedAsCode(t, codeSink)))
  }

  /**
   * A string concatenation leaf that is later executed as code.
   */
  class StringConcatExecutedAsCode extends Sink, StringOps::ConcatenationLeaf {
    CodeInjection::Sink codeSink;

    StringConcatExecutedAsCode() {
      this.getRoot() = isExecutedAsCode(DataFlow::TypeBackTracker::end(), codeSink)
    }

    override DataFlow::Node getCodeSink() { result = codeSink }
  }
}
