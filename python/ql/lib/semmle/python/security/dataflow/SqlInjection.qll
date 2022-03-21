/**
 * Provides a taint-tracking configuration for detecting "SQL injection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `SqlInjection::Configuration` is needed, otherwise
 * `SqlInjectionCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/**
 * Provides a taint-tracking configuration for detecting "SQL injection" vulnerabilities.
 */
module SqlInjection {
  import SqlInjectionQuery // ignore-query-import
}

/**
 * DEPRECATED: Don't extend this class for customization, since this will lead to bad
 * performance, instead use the new `SqlInjectionCustomizations.qll` file, and extend
 * its' classes.
 */
deprecated class SqlInjectionConfiguration = SqlInjection::Configuration;

/** DEPRECATED: Alias for SqlInjectionConfiguration */
deprecated class SQLInjectionConfiguration = SqlInjectionConfiguration;
