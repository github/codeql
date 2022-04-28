/** DEPRECATED. Import `CommandInjectionQuery` instead. */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/** DEPRECATED. Import `CommandInjectionQuery` instead. */
deprecated module CommandInjection {
  import CommandInjectionQuery // ignore-query-import
}

/** DEPRECATED. Import `CommandInjectionQuery` instead. */
deprecated class CommandInjectionConfiguration = CommandInjection::Configuration;
