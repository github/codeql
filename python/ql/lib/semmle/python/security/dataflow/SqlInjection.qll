/** DEPRECATED. Import `SqlInjectionQuery` instead. */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/** DEPRECATED. Import `SqlInjectionQuery` instead. */
deprecated module SqlInjection {
  import SqlInjectionQuery // ignore-query-import
}

/** DEPRECATED. Import `SqlInjectionQuery` instead. */
deprecated class SqlInjectionConfiguration = SqlInjection::Configuration;

/** DEPRECATED. Import `SqlInjectionQuery` instead. */
deprecated class SQLInjectionConfiguration = SqlInjectionConfiguration;
