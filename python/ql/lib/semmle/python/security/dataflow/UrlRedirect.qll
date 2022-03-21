/**
 * Provides a taint-tracking configuration for detecting "URL redirection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `UrlRedirect::Configuration` is needed, otherwise
 * `UrlRedirectCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/**
 * Provides a taint-tracking configuration for detecting "URL redirection" vulnerabilities.
 */
module UrlRedirect {
  import UrlRedirectQuery // ignore-query-import
}

/**
 * DEPRECATED: Don't extend this class for customization, since this will lead to bad
 * performance, instead use the new `UrlRedirectCustomizations.qll` file, and extend
 * its' classes.
 */
deprecated class UrlRedirectConfiguration = UrlRedirect::Configuration;
