/** DEPRECATED. Import `ReflectedXSSQuery` instead. */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/** DEPRECATED. Import `ReflectedXSSQuery` instead. */
deprecated module ReflectedXss {
  import ReflectedXssQuery // ignore-query-import
}

/** DEPRECATED. Import `ReflectedXSSQuery` instead. */
deprecated module ReflectedXSS = ReflectedXss;

/** DEPRECATED. Import `ReflectedXSSQuery` instead. */
deprecated class ReflectedXssConfiguration = ReflectedXss::Configuration;
