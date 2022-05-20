/** DEPRECATED. Import `UrlRedirectQuery` instead. */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/** DEPRECATED. Import `UrlRedirectQuery` instead. */
deprecated module UrlRedirect {
  import UrlRedirectQuery // ignore-query-import
}

/** DEPRECATED. Import `UrlRedirectQuery` instead. */
deprecated class UrlRedirectConfiguration = UrlRedirect::Configuration;
