/**
 * Provides a tracking configuration for reasoning about type confusion for HTTP request inputs.
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
   * A taint tracking configuration for type confusion for HTTP request inputs.
   */
  class Configuration extends DataFlow::Configuration {
    Configuration() {
      this = "TypeConfusionThroughParameterTampering"
    }

    override predicate isSource(DataFlow::Node source) {
      source instanceof Source
    }

    override predicate isSink(DataFlow::Node sink) {
      sink instanceof Sink and
      sink.analyze().getAType() = TTString() and
      sink.analyze().getAType() = TTObject()
    }

    override predicate isBarrier(DataFlow::Node node) {
      node instanceof Barrier
    }

  }

  /**
   * An HTTP request parameter that the user controls the type of.
   *
   * Node.js-based HTTP servers turn request parameters into arrays if their names are repeated.
   */
  private class TypeTamperableRequestParameter extends Source {

    TypeTamperableRequestParameter() {
      this.(HTTP::RequestInputAccess).getKind() = "parameter" and
      not exists (Express::RequestExpr request, DataFlow::PropRead base |
        // Express's `req.params.name` is always a string
        base.accesses(request.flow(), "params") and
        this = base.getAPropertyRead(_)
      )
    }

  }

  /**
   * Methods calls that behave slightly different for arrays and strings receivers.
   */
  private class StringArrayAmbiguousMethodCall extends Sink {

    StringArrayAmbiguousMethodCall() {
      exists (string name, DataFlow::MethodCallNode mc |
        name = "concat" or
        name = "includes" or
        name = "indexOf" or
        name = "lastIndexOf" or
        name = "slice" |
        mc.calls(this, name) and
        // ignore patterns that are innocent in practice
        not exists (EqualityTest cmp, Expr op |
          cmp.hasOperands(mc.asExpr(), op) |
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
      exists (DataFlow::PropRead read |
        read.accesses(this, "length") and
        // exclude truthiness checks on the length: an array/string confusion cannot control an emptiness check
        not (
          exists (ConditionGuardNode cond |
            read.asExpr() = cond.getTest()
          )
          or
          exists (Comparison cmp, Expr zero |
            zero.getIntValue() = 0 and
            cmp.hasOperands(read.asExpr(), zero)
          )
          or
          exists (LogNotExpr neg |
            neg.getOperand() = read.asExpr()
          )
        )
      )
    }

  }

}
