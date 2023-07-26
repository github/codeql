/**
 * @name Arbitrary Configuration Injection
 * @description Not properly sanitizing user input before using it to set configuration
 * values into the user's configuration file can lead to arbitrary configuration injection.
 * Under some circomstances, this may results into arbitrary code execution.
 * @kind path-problem
 * @id py/arbitrary-configuration-injection
 * @problem.severity error
 * @tags security
 *       experimental
 *       external/cwe/cwe-74
 */

import python
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.internal.DataFlowPublic

/**
 * Gets a reference to the `configparser.RawConfigParser` or `configparser.ConfigParser`
 * class or any of its subclass.
 *
 * @see https://docs.python.org/3/library/configparser.html#configparser.RawConfigParser
 */
class ConfigParser extends API::Node {
  ConfigParser() {
    this =
      API::moduleImport("configparser")
          .getMember(["RawConfigParser", "ConfigParser"])
          .getASubclass*()
  }

  override string toString() { result = this.toString() }
}

/**
 * Gets a reference to user input from the command line.
 * This includes the list of arguments passed to a Python script `sys.argv`, the `input`
 * built-in function, or the modules `argparse` and `optparse` for command-line options,
 * arguments and sub-commands parsing.
 */
class UserInputFromCLI extends DataFlow::Node {
  UserInputFromCLI() {
    (
      /* @see https://docs.python.org/3/library/argparse */
      this =
        API::moduleImport("argparse")
            .getMember("ArgumentParser")
            .getASubclass*()
            .getReturn()
            .getMember("parse_args")
            .getACall()
      or
      /* @see https://docs.python.org/3/library/optparse.html */
      this =
        API::moduleImport("optparse")
            .getMember("OptionParser")
            .getASubclass*()
            .getReturn()
            .getMember("parse_args")
            .getACall()
      or
      /* @see https://docs.python.org/3/library/sys.html */
      this = API::moduleImport("sys").getMember(["argv", "orig_argv"]).asSource()
      or
      /* @see https://docs.python.org/3/library/functions.html#input */
      this = API::builtin("input").getACall()
    )
  }

  override string toString() { result = this.toString() }
}

class ConfigInjection extends TaintTracking::Configuration {
  ConfigInjection() { this = "Arbitrary Configuration Injection" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource
    or
    source instanceof UserInputFromCLI
  }

  /*
   * A call to the `str.replace()` method or the `re.sub()` function is considered
   * a sanitizer if the first argument is the carriage return character `\r`.
   */

  override predicate isSanitizer(DataFlow::Node sanitizer) {
    exists(MethodCallNode replace, StrConst s |
      replace.calls(sanitizer, "replace") and s = replace.getArg(0).asExpr() and s.getText() = "\r"
    )
    or
    exists(MethodCallNode sub, StrConst s |
      sub = API::moduleImport("re").getMember("sub").getACall() and
      s = sub.getArg(0).asExpr() and
      s.getText() = "\r" and
      sanitizer = sub.getArg(2)
    )
  }

  /**
   * An argument to a call to the methods `set()` or `add_section()` on a configuration
   * parser object is considered a Sink if it is not a an immutable literal like a boolean
   * or a string.
   */
  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCallNode set, Node obj, ConfigParser configparser |
      obj = configparser.getReturn().getAValueReachableFromSource() and
      set.calls(obj, ["set", "add_section"]) and
      sink = set.getArg(_)
    ) and
    not sink.asExpr() instanceof ImmutableLiteral
  }
}

from ConfigInjection config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, " user-controlled data $@ ", source.getNode(),
  " reaches the configuration parser $@", sink.getNode()
