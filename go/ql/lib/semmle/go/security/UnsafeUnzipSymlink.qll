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
