/**
 * Provides default sources, sinks and sanitizers for detecting
 * "path injection"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards

/**
 * Provides default sources, and sinks for detecting
 * "path injection"
 * vulnerabilities, as well as extension points for adding your own.
 *
 * Since the path-injection configuration setup is rather complicated, we do not
 * expose a `Sanitizer` class, and instead you should extend
 * `Path::PathNormalization::Range` and `Path::SafeAccessCheck::Range` from
 * `semmle.python.Concepts` instead.
 */
module PathInjection {
  /**
   * A data flow source for "path injection" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "path injection" vulnerabilities.
   * Such as a file system access.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer guard for "path injection" vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * A file system access, considered as a flow sink.
   */
  class FileSystemAccessAsSink extends Sink {
    FileSystemAccessAsSink() { this = any(FileSystemAccess e).getAPathArgument() }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizerGuard extends SanitizerGuard, StringConstCompare { }
}
