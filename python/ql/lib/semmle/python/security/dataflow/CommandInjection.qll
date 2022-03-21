/**
 * Provides a taint-tracking configuration for detecting "command injection" vulnerabilities.
 *
 * Note, for performance reasons: only import this file if
 * `CommandInjection::Configuration` is needed, otherwise
 * `CommandInjectionCustomizations` should be imported instead.
 */

private import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking

/**
 * Provides a taint-tracking configuration for detecting "command injection" vulnerabilities.
 */
module CommandInjection {
  import CommandInjectionQuery // ignore-query-import
}

/**
 * DEPRECATED: Don't extend this class for customization, since this will lead to bad
 * performance, instead use the new `CommandInjectionCustomizations.qll` file, and extend
 * its' classes.
 */
deprecated class CommandInjectionConfiguration = CommandInjection::Configuration;
