/**
 * Provides taint tracking configurations for reasoning about unsafe extraction of symlinks
 * from archive files.
 *
 * Note: for performance reasons, only import this file if `UnsafeUnzipSymlink::EvalSymlinksConfiguration`
 * and/or `UnsafeUnzipSymlink::SymlinkConfiguration` is needed, otherwise
 * `UnsafeUnzipSymlinkCustomizations` should be imported instead.
 */

import go

/** Provides a taint tracking configuration for reasoning about zip-slip vulnerabilities. */
module UnsafeUnzipSymlink {
  import UnsafeUnzipSymlinkCustomizations::UnsafeUnzipSymlink

  /**
   * DEPRECATED: Use copies of `EvalSymlinksConfig` and `EvalSymlinksFlow` instead.
   *
   * A taint-flow configuration tracking archive header fields flowing to a `path/filepath.EvalSymlinks` call.
   */
  deprecated class EvalSymlinksConfiguration extends TaintTracking2::Configuration {
    EvalSymlinksConfiguration() { this = "Archive header field symlinks resolved" }

    override predicate isSource(DataFlow::Node source) { source instanceof FilenameWithSymlinks }

    override predicate isSink(DataFlow::Node sink) { sink instanceof EvalSymlinksSink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof EvalSymlinksInvalidator
    }
  }

  // Archive header field symlinks resolved
  private module EvalSymlinksConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { source instanceof FilenameWithSymlinks }

    predicate isSink(DataFlow::Node sink) { sink instanceof EvalSymlinksSink }

    predicate isBarrier(DataFlow::Node node) { node instanceof EvalSymlinksInvalidator }
  }

  /**
   * Tracks taint flow from archive header fields to
   * `path/filepath.EvalSymlinks` calls.
   */
  private module EvalSymlinksFlow = TaintTracking::Global<EvalSymlinksConfig>;

  /**
   * Holds if `node` is an archive header field read that flows to a `path/filepath.EvalSymlinks` call.
   */
  private predicate symlinksEvald(DataFlow::Node node) {
    EvalSymlinksFlow::flow(getASimilarReadNode(node), _)
  }

  /**
   * DEPRECATED: Use `Flow` instead.
   *
   * A taint-flow configuration tracking archive header fields flowing to an `os.Symlink` call,
   * which never flow to a `path/filepath.EvalSymlinks` call.
   */
  deprecated class SymlinkConfiguration extends TaintTracking::Configuration {
    SymlinkConfiguration() { this = "Unsafe unzipping of symlinks" }

    override predicate isSource(DataFlow::Node source) {
      source instanceof FilenameWithSymlinks and
      not symlinksEvald(source)
    }

    override predicate isSink(DataFlow::Node sink) { sink instanceof SymlinkSink }

    override predicate isSanitizer(DataFlow::Node node) {
      super.isSanitizer(node) or
      node instanceof SymlinkSanitizer
    }
  }

  private module Config implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      source instanceof FilenameWithSymlinks and
      not symlinksEvald(source)
    }

    predicate isSink(DataFlow::Node sink) { sink instanceof SymlinkSink }

    predicate isBarrier(DataFlow::Node node) { node instanceof SymlinkSanitizer }
  }

  /**
   * Tracks taint flow from archive header fields to an `os.Symlink` call,
   * which never flow to a `path/filepath.EvalSymlinks` call.
   */
  module Flow = TaintTracking::Global<Config>;
}
