/**
 * Provides a taint-tracking configuration for reasoning about stored
 * cross-site scripting vulnerabilities.
 * Is boosted by ATM.
 */

import javascript
import AdaptiveThreatModeling
import semmle.javascript.security.dataflow.Xss::StoredXss

/**
 * This module provides logic to filter candidate sinks to those which are likely XSS sinks.
 */
module SinkEndpointFilter {
  private import StandardEndpointFilters as StandardEndpointFilters

  /**
   * Provides a set of reasons why a given data flow node should be excluded as a sink candidate.
   *
   * If this predicate has no results for a sink candidate `n`, then we should treat `n` as an
   * effective sink.
   */
  string getAReasonSinkExcluded(DataFlow::Node sinkCandidate) {
    result = StandardEndpointFilters::getAReasonSinkExcluded(sinkCandidate)
  }
}

class StoredXssATMConfig extends ATMConfig {
  StoredXssATMConfig() { this = "StoredXssATMConfig" }

  override predicate isKnownSource(DataFlow::Node source) { source instanceof Source }

  override predicate isKnownSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isEffectiveSink(DataFlow::Node sinkCandidate) {
    not exists(SinkEndpointFilter::getAReasonSinkExcluded(sinkCandidate))
  }

  override EndpointType getASinkEndpointType() { result instanceof XssSinkType }
}

/**
 * A taint-tracking configuration for reasoning about XSS.
 */
class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "StoredXssATMConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) {
    (sink instanceof Sink or any(StoredXssATMConfig cfg).isEffectiveSink(sink))
  }

  override predicate isSanitizer(DataFlow::Node node) {
    super.isSanitizer(node) or
    node instanceof Sanitizer
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode guard) {
    guard instanceof SanitizerGuard
  }
}

/** A file name, considered as a flow source for stored XSS. */
class FileNameSourceAsSource extends Source {
  FileNameSourceAsSource() { this instanceof FileNameSource }
}

/** An instance of user-controlled torrent information, considered as a flow source for stored XSS. */
class UserControlledTorrentInfoAsSource extends Source {
  UserControlledTorrentInfoAsSource() { this instanceof ParseTorrent::UserControlledTorrentInfo }
}
