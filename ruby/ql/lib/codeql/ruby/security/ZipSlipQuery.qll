/**
 * Provides a taint tracking configuration for reasoning about
 * zip slip vulnerabilities.
 */

import ZipSlipCustomizations
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking
private import codeql.ruby.ApiGraphs

/**
 * A taint-tracking configuration for reasoning about zip slip
 * vulnerabilities.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "ZipSlip" }

  override predicate isSource(DataFlow::Node source) { source instanceof ZipSlip::Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof ZipSlip::Sink }

  /**
   * This should actually be
   * `and cn = API::getTopLevelMember("Gem").getMember("Package").getMember("TarReader").getMember("Entry").getAMethodCall("full_name")` and similar for other classes
   * but I couldn't make it work so there's only check for the method name called on the entry. It is `full_name` for `Gem::Package::TarReader::Entry` and `Zlib`
   * and `name` for `Zip::File`
   */
  override predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(DataFlow::CallNode cn |
      cn.getReceiver() = nodeFrom and
      cn.getMethodName() in ["full_name", "name"] and
      cn = nodeTo
    )
  }

  override predicate isSanitizer(DataFlow::Node node) { node instanceof ZipSlip::Sanitizer }
}
