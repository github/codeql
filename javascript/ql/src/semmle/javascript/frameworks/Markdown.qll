/**
 * Provides classes for modelling common markdown parsers and generators.
 */

import javascript

/**
 * A taint step for the `marked` library, that converts markdown to HTML.
 */
private class MarkedStep extends TaintTracking::AdditionalTaintStep, DataFlow::CallNode {
  MarkedStep() {
    this = DataFlow::globalVarRef("marked").getACall()
    or
    this = DataFlow::moduleImport("marked").getACall()
  }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    succ = this and
    pred = this.getArgument(0)
  }
}

/**
 * A taint step for the `markdown-table` library.
 */
private class MarkdownTableStep extends TaintTracking::AdditionalTaintStep, DataFlow::CallNode {
  MarkdownTableStep() { this = DataFlow::moduleImport("markdown-table").getACall() }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    succ = this and
    pred = this.getArgument(0)
  }
}

/**
 * A taint step for the `showdown` library.
 */
private class ShowDownStep extends TaintTracking::AdditionalTaintStep, DataFlow::CallNode {
  ShowDownStep() {
    this =
      [DataFlow::globalVarRef("showdown"), DataFlow::moduleImport("showdown")]
          .getAConstructorInvocation("Converter")
          .getAMemberCall(["makeHtml", "makeMd"])
  }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    succ = this and
    pred = this.getArgument(0)
  }
}

/**
 * Classes and predicates for modelling taint steps in `unified` and `remark`.
 */
private module Unified {
  /**
   * The creation of a parser from `unified`.
   * The `remark` module is a shorthand that initializes `unified` with a markdown parser.
   */
  DataFlow::CallNode unified() { result = DataFlow::moduleImport(["unified", "remark"]).getACall() }

  /**
   * A chain of method calls that process an input with `unified`.
   */
  class UnifiedChain extends DataFlow::CallNode {
    DataFlow::CallNode root;

    UnifiedChain() {
      root = unified() and
      this = root.getAChainedMethodCall(["process", "processSync"])
    }

    /**
     * Gets a plugin that is used in this chain.
     */
    DataFlow::Node getAUsedPlugin() { result = root.getAChainedMethodCall("use").getArgument(0) }

    /**
     * Gets the input that is processed.
     */
    DataFlow::Node getInput() { result = getArgument(0) }

    /**
     * Gets the processed output.
     */
    DataFlow::Node getOutput() {
      this.getCalleeName() = "process" and result = getABoundCallbackParameter(1, 1)
      or
      this.getCalleeName() = "processSync" and result = this
    }
  }

  /**
   * A taint step for the `unified` library.
   */
  class UnifiedStep extends TaintTracking::AdditionalTaintStep, UnifiedChain {
    UnifiedStep() {
      // sanitizer. Mostly looking for `rehype-sanitize`, but also other plugins with `sanitize` in their name.
      not this.getAUsedPlugin().getALocalSource() =
        DataFlow::moduleImport(any(string s | s.matches("%sanitize%")))
    }

    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      pred = getInput() and
      succ = getOutput()
    }
  }
}

/**
 * A taint step for the `snarkdown` library.
 */
private class SnarkdownStep extends TaintTracking::AdditionalTaintStep, DataFlow::CallNode {
  SnarkdownStep() { this = DataFlow::moduleImport("snarkdown").getACall() }

  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    this = succ and
    pred = this.getArgument(0)
  }
}
