/**
 * Provides default sources, sinks and sanitizers for detecting
 * "polynomial regular expression denial of service (ReDoS)"
 * vulnerabilities, as well as extension points for adding your own.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.DataFlow2
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.Concepts
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.dataflow.new.BarrierGuards
private import semmle.python.RegexTreeView
private import semmle.python.ApiGraphs

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "polynomial regular expression denial of service (ReDoS)"
 * vulnerabilities, as well as extension points for adding your own.
 */
module PolynomialReDoS {
  /**
   * A data flow source for "polynomial regular expression denial of service (ReDoS)" vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for "polynomial regular expression denial of service (ReDoS)" vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /** Gets the regex that is being executed by this node. */
    abstract RegExpTerm getRegExp();

    /**
     * Gets the node to highlight in the alert message.
     */
    DataFlow::Node getHighlight() { result = this }
  }

  /**
   * A sanitizer for "polynomial regular expression denial of service (ReDoS)" vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A sanitizer guard for "polynomial regular expression denial of service (ReDoS)" vulnerabilities.
   */
  abstract class SanitizerGuard extends DataFlow::BarrierGuard { }

  /**
   * A source of remote user input, considered as a flow source.
   */
  class RemoteFlowSourceAsSource extends Source, RemoteFlowSource { }

  /**
   * A regex execution, considered as a flow sink.
   */
  class RegexExecutionAsSink extends Sink {
    RegExpTerm t;

    RegexExecutionAsSink() {
      exists(CompiledRegexes::RegexExecution re |
        re.getRegexNode().asExpr() = t.getRegex() and
        this = re.getString()
      ) and
      t.isRootTerm()
    }

    /** Gets the regex that is being executed by this node. */
    override RegExpTerm getRegExp() { result = t }
  }

  /**
   * A comparison with a constant string, considered as a sanitizer-guard.
   */
  class StringConstCompareAsSanitizerGuard extends SanitizerGuard, StringConstCompare { }
}

/** Helper module for tracking compiled regexes. */
private module CompiledRegexes {
  // TODO: This module should be refactored and merged with the experimental work done on detecting
  // regex injections, such that this can be expressed from just using a concept.
  /** A configuration for finding uses of compiled regexes. */
  class RegexDefinitionConfiguration extends DataFlow2::Configuration {
    RegexDefinitionConfiguration() { this = "RegexDefinitionConfiguration" }

    override predicate isSource(DataFlow::Node source) { source instanceof RegexDefinitonSource }

    override predicate isSink(DataFlow::Node sink) { sink instanceof RegexDefinitionSink }
  }

  /** A regex compilation. */
  class RegexDefinitonSource extends DataFlow::CallCfgNode {
    DataFlow::Node regexNode;

    RegexDefinitonSource() {
      this = API::moduleImport("re").getMember("compile").getACall() and
      regexNode in [this.getArg(0), this.getArgByName("pattern")]
    }

    /** Gets the regex that is being compiled by this node. */
    RegExpTerm getRegExp() { result.getRegex() = regexNode.asExpr() and result.isRootTerm() }

    /** Gets the data flow node for the regex being compiled by this node. */
    DataFlow::Node getRegexNode() { result = regexNode }
  }

  /** A use of a compiled regex. */
  class RegexDefinitionSink extends DataFlow::Node {
    RegexExecutionMethod method;
    DataFlow::CallCfgNode executingCall;

    RegexDefinitionSink() {
      exists(DataFlow::AttrRead reMethod |
        executingCall.getFunction() = reMethod and
        reMethod.getAttributeName() = method and
        this = reMethod.getObject()
      )
    }

    /** Gets the method used to execute the regex. */
    RegexExecutionMethod getMethod() { result = method }

    /** Gets the data flow node for the executing call. */
    DataFlow::CallCfgNode getExecutingCall() { result = executingCall }
  }

  /** A data flow node executing a regex. */
  abstract class RegexExecution extends DataFlow::Node {
    /** Gets the data flow node for the regex being compiled by this node. */
    abstract DataFlow::Node getRegexNode();

    /** Gets a dataflow node for the string to be searched or matched against. */
    abstract DataFlow::Node getString();
  }

  private class RegexExecutionMethod extends string {
    RegexExecutionMethod() {
      this in ["match", "fullmatch", "search", "split", "findall", "finditer", "sub", "subn"]
    }
  }

  /** Gets the index of the argument representing the string to be searched by a regex. */
  int stringArg(RegexExecutionMethod method) {
    method in ["match", "fullmatch", "search", "split", "findall", "finditer"] and
    result = 1
    or
    method in ["sub", "subn"] and
    result = 2
  }

  /**
   * A class to find `re` methods immediately executing an expression.
   *
   * See `RegexExecutionMethods`
   */
  class DirectRegex extends DataFlow::CallCfgNode, RegexExecution {
    RegexExecutionMethod method;

    DirectRegex() { this = API::moduleImport("re").getMember(method).getACall() }

    override DataFlow::Node getRegexNode() {
      result in [this.getArg(0), this.getArgByName("pattern")]
    }

    override DataFlow::Node getString() {
      result in [this.getArg(stringArg(method)), this.getArgByName("string")]
    }
  }

  /**
   * A class to find `re` methods immediately executing a compiled expression by `re.compile`.
   *
   * Given the following example:
   *
   * ```py
   * pattern = re.compile(input)
   * pattern.match(s)
   * ```
   *
   * This class will identify that `re.compile` compiles `input` and afterwards
   * executes `re`'s `match`. As a result, `this` will refer to `pattern.match(s)`
   * and `this.getRegexNode()` will return the node for `input` (`re.compile`'s first argument)
   *
   *
   * See `RegexExecutionMethods`
   *
   * See https://docs.python.org/3/library/re.html#regular-expression-objects
   */
  private class CompiledRegex extends DataFlow::CallCfgNode, RegexExecution {
    DataFlow::Node regexNode;
    RegexExecutionMethod method;

    CompiledRegex() {
      exists(
        RegexDefinitionConfiguration conf, RegexDefinitonSource source, RegexDefinitionSink sink
      |
        conf.hasFlow(source, sink) and
        regexNode = source.getRegexNode() and
        method = sink.getMethod() and
        this = sink.getExecutingCall()
      )
    }

    override DataFlow::Node getRegexNode() { result = regexNode }

    override DataFlow::Node getString() {
      result in [this.getArg(stringArg(method) - 1), this.getArgByName("string")]
    }
  }
}
