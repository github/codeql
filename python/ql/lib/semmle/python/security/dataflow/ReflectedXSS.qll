/**
 * Provides a taint-tracking configuration for detecting "reflected server-side cross-site scripting" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `ReflectedXSS::Configuration` is needed, otherwise
 * `ReflectedXSSCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/**
 * Provides a taint-tracking configuration for detecting "reflected server-side cross-site scripting" vulnerabilities.
 */
module ReflectedXss {
  import ReflectedXSSQuery // ignore-query-import
}

/** DEPRECATED: Alias for ReflectedXss */
deprecated module ReflectedXSS = ReflectedXss;

/**
 * DEPRECATED: Don't extend this class for customization, since this will lead to bad
 * performance, instead use the new `ReflectedXSSCustomizations.qll` file, and extend
 * its' classes.
 */
deprecated class ReflectedXssConfiguration = ReflectedXss::Configuration;
