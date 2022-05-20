/** DEPRECATED. Import `CodeInjectionQuery` instead. */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/** DEPRECATED. Import `CodeInjectionQuery` instead. */
deprecated module CodeInjection {
  import CodeInjectionQuery // ignore-query-import
}

/** DEPRECATED. Import `CodeInjectionQuery` instead. */
deprecated class CodeInjectionConfiguration = CodeInjection::Configuration;
