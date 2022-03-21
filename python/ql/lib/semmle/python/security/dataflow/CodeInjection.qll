/**
 * Provides a taint-tracking configuration for detecting "code injection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `CodeInjection::Configuration` is needed, otherwise
 * `CodeInjectionCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/**
 * Provides a taint-tracking configuration for detecting "code injection" vulnerabilities.
 */
module CodeInjection {
  import CodeInjectionQuery // ignore-query-import
}

/**
 * DEPRECATED: Don't extend this class for customization, since this will lead to bad
 * performance, instead use the new `CodeInjectionCustomizations.qll` file, and extend
 * its' classes.
 */
deprecated class CodeInjectionConfiguration = CodeInjection::Configuration;
