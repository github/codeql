/**
 * Provides classes for modelling common markdown parsers and generators.
 */

import javascript

/**
 * A taint step for the `marked` library, that converts markdown to HTML.
 */
private class MarkedStep extends TaintTracking::SharedTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::CallNode call |
      call = DataFlow::globalVarRef("marked").getACall()
      or
      call = DataFlow::moduleImport("marked").getACall()
    |
      succ = call and
      pred = call.getArgument(0)
    )
  }
}

/**
 * A taint step for the `markdown-table` library.
 */
private class MarkdownTableStep extends TaintTracking::SharedTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::CallNode call | call = DataFlow::moduleImport("markdown-table").getACall() |
      succ = call and
      pred = call.getArgument(0)
    )
  }
}

/**
 * A taint step for the `showdown` library.
 */
private class ShowDownStep extends TaintTracking::SharedTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::CallNode call |
      call =
        [DataFlow::globalVarRef("showdown"), DataFlow::moduleImport("showdown")]
            .getAConstructorInvocation("Converter")
            .getAMemberCall(["makeHtml", "makeMd"])
    |
      succ = call and
      pred = call.getArgument(0)
    )
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
  class UnifiedStep extends TaintTracking::SharedTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(UnifiedChain chain |
        // sanitizer. Mostly looking for `rehype-sanitize`, but also other plugins with `sanitize` in their name.
        not chain.getAUsedPlugin().getALocalSource() =
          DataFlow::moduleImport(any(string s | s.matches("%sanitize%")))
      |
        pred = chain.getInput() and
        succ = chain.getOutput()
      )
    }
  }
}

/**
 * A taint step for the `snarkdown` library.
 */
private class SnarkdownStep extends TaintTracking::SharedTaintStep {
  override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::CallNode call | call = DataFlow::moduleImport("snarkdown").getACall() |
      call = succ and
      pred = call.getArgument(0)
    )
  }
}
