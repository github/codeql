/**
 * Provides a taint tracking configuration for reasoning about
 * zip slip vulnerabilities.
 */

import ZipSlipCustomizations
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
private import codeql.ruby.ApiGraphs

private module ZipSlipConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ZipSlip::Source }

  predicate isSink(DataFlow::Node sink) { sink instanceof ZipSlip::Sink }

  /**
   * This should actually be
   * `and cn = API::getTopLevelMember("Gem").getMember("Package").getMember("TarReader").getMember("Entry").getAMethodCall("full_name")` and similar for other classes
   * but I couldn't make it work so there's only check for the method name called on the entry. It is `full_name` for `Gem::Package::TarReader::Entry` and `Zlib`
   * and `name` for `Zip::File`
   */
  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(DataFlow::CallNode cn |
      cn.getReceiver() = nodeFrom and
      cn.getMethodName() in ["full_name", "name"] and
      cn = nodeTo
    )
  }

  predicate isBarrier(DataFlow::Node node) { node instanceof ZipSlip::Sanitizer }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking for reasoning about zip slip vulnerabilities.
 */
module ZipSlipFlow = TaintTracking::Global<ZipSlipConfig>;
