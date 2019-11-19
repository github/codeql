/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * type confusion for HTTP request inputs, as well as extension points
 * for adding your own.
 */

import javascript
import semmle.javascript.security.dataflow.RemoteFlowSources
private import semmle.javascript.dataflow.InferredTypes

module TypeConfusionThroughParameterTampering {
  /**
   * A data flow source for type confusion for HTTP request inputs.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for type confusion for HTTP request inputs.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A barrier for type confusion for HTTP request inputs.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * An HTTP request parameter that the user controls the type of.
   *
   * Node.js-based HTTP servers turn request parameters into arrays if their names are repeated.
   */
  private class TypeTamperableRequestParameter extends Source {
    TypeTamperableRequestParameter() { this.(HTTP::RequestInputAccess).isUserControlledObject() }
  }

  /**
   * Methods calls that behave slightly different for arrays and strings receivers.
   */
  private class StringArrayAmbiguousMethodCall extends Sink {
    StringArrayAmbiguousMethodCall() {
      exists(string name, DataFlow::MethodCallNode mc |
        name = "concat" or
        name = "includes" or
        name = "indexOf" or
        name = "lastIndexOf" or
        name = "slice"
      |
        mc.calls(this, name) and
        // ignore patterns that are innocent in practice
        not exists(EqualityTest cmp, Expr op | cmp.hasOperands(mc.asExpr(), op) |
          // prefix checking: `x.indexOf(prefix) === 0`
          name = "indexOf" and
          op.getIntValue() = 0
          or
          // suffix checking: `x.slice(-1) === '/'`
          name = "slice" and
          mc.getArgument(0).asExpr().getIntValue() = -1 and
          op.getStringValue().length() = 1
        )
      )
    }
  }

  /**
   * An access to the `length` property of an object.
   */
  private class LengthAccess extends Sink {
    LengthAccess() {
      exists(DataFlow::PropRead read |
        read.accesses(this, "length") and
        // an array/string confusion cannot control an emptiness check
        not (
          // `if (x.length) {...}`
          exists(ConditionGuardNode cond | read.asExpr() = cond.getTest())
          or
          // `x.length == 0`, `x.length > 0`
          exists(Comparison cmp, Expr zero |
            zero.getIntValue() = 0 and
            cmp.hasOperands(read.asExpr(), zero)
          )
          or
          // `x.length < 1`
          exists(RelationalComparison cmp |
            cmp.getLesserOperand() = read.asExpr() and
            cmp.getGreaterOperand().getIntValue() = 1 and
            not cmp.isInclusive()
          )
          or
          // `!x.length`
          exists(LogNotExpr neg | neg.getOperand() = read.asExpr())
        )
      )
    }
  }
}
