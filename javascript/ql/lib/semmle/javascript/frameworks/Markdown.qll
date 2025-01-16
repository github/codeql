/**
 * Provides classes for modeling common markdown parsers and generators.
 */

import semmle.javascript.Unit
import javascript

/**
 * A module providing taint-steps for common markdown parsers and generators.
 */
module Markdown {
  /**
   * A taint-step that parses a markdown document, but preserves taint.
   */
  class MarkdownStep extends Unit {
    /**
     * Holds if there is a taint-step from `pred` to `succ` for a taint-preserving markdown parser.
     */
    abstract predicate step(DataFlow::Node pred, DataFlow::Node succ);

    /**
     * Holds if the taint-step preserves HTML.
     */
    predicate preservesHtml() { any() }
  }

  private class MarkdownStepAsTaintStep extends TaintTracking::SharedTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      any(MarkdownStep step).step(pred, succ)
    }
  }

  /**
   * A taint step for the `marked` library, that converts markdown to HTML.
   */
  private class MarkedStep extends MarkdownStep {
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
  private class MarkdownTableStep extends MarkdownStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call | call = DataFlow::moduleImport("markdown-table").getACall() |
        // TODO: needs a flow summary to ensure ArrayElement content is unfolded
        succ = call and
        pred = call.getArgument(0)
      )
    }
  }

  /**
   * A taint step for the `showdown` library.
   */
  private class ShowDownStep extends MarkdownStep {
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

  /** A taint step for the `mermaid` library. */
  private class MermaidStep extends MarkdownStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(API::CallNode call |
        call =
          [API::moduleImport("mermaid"), API::moduleImport("mermaid").getMember("mermaidAPI")]
              .getMember("render")
              .getACall()
      |
        succ = [call, call.getParameter(2).getParameter(0).asSource()] and
        pred = call.getArgument(1)
      )
      or
      exists(DataFlow::CallNode call |
        call =
          [
            DataFlow::globalVarRef("mermaid"),
            DataFlow::globalVarRef("mermaid").getAPropertyRead("mermaidAPI")
          ].getAMemberCall("render")
      |
        succ = [call.(DataFlow::Node), call.getABoundCallbackParameter(2, 0)] and
        pred = call.getArgument(1)
      )
    }
  }

  /**
   * Classes and predicates for modeling taint steps in `unified` and `remark`.
   */
  private module Unified {
    /**
     * Gets a parser from `unified`.
     * The `remark` module is a shorthand that initializes `unified` with a markdown parser.
     */
    DataFlow::CallNode unified() {
      result = DataFlow::moduleImport(["unified", "remark"]).getACall()
    }

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
      DataFlow::Node getInput() { result = this.getArgument(0) }

      /**
       * Gets the processed output.
       */
      DataFlow::Node getOutput() {
        this.getCalleeName() = "process" and result = this.getABoundCallbackParameter(1, 1)
        or
        this.getCalleeName() = "processSync" and result = this
      }
    }

    /**
     * A taint step for the `unified` library.
     */
    class UnifiedStep extends MarkdownStep {
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
  private class SnarkdownStep extends MarkdownStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode call | call = DataFlow::moduleImport("snarkdown").getACall() |
        call = succ and
        pred = call.getArgument(0)
      )
    }
  }

  /**
   * Classes and predicates for modeling taint steps the `markdown-it` library.
   */
  private module MarkdownIt {
    /**
     * Gets a creation of a parser from `markdown-it`.
     */
    private API::Node markdownIt() {
      exists(API::InvokeNode call |
        call = API::moduleImport("markdown-it").getAnInvocation()
        or
        call = API::moduleImport("markdown-it").getMember("Markdown").getAnInvocation()
      |
        call.getParameter(0).getMember("html").asSink().mayHaveBooleanValue(true) and
        result = call.getReturn()
      )
      or
      exists(API::CallNode call |
        call = markdownIt().getMember(["use", "set", "configure", "enable", "disable"]).getACall() and
        result = call.getReturn() and
        not call.getParameter(0).getAValueReachingSink() =
          DataFlow::moduleImport("markdown-it-sanitizer")
      )
    }

    /**
     * A taint step for the `markdown-it` library.
     */
    private class MarkdownItStep extends MarkdownStep {
      override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
        exists(API::CallNode call |
          call = markdownIt().getMember(["render", "renderInline"]).getACall()
        |
          succ = call and
          pred = call.getArgument(0)
        )
      }
    }
  }
}
