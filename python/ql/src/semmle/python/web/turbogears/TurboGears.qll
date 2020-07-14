import python
import semmle.python.dataflow.TaintTracking

private ClassValue theTurboGearsControllerClass() { result = Value::named("tg.TGController") }

ClassValue aTurboGearsControllerClass() { result.getABaseType+() = theTurboGearsControllerClass() }

class TurboGearsControllerMethod extends Function {
  ControlFlowNode decorator;

  TurboGearsControllerMethod() {
    aTurboGearsControllerClass().getScope() = this.getScope() and
    decorator = this.getADecorator().getAFlowNode() and
    /* Is decorated with @expose() or @expose(path) */
    (
      decorator.(CallNode).getFunction().(NameNode).getId() = "expose"
      or
      decorator.pointsTo().getClass() = Value::named("tg.expose")
    )
  }

  private ControlFlowNode templateName() { result = decorator.(CallNode).getArg(0) }

  predicate isTemplated() { exists(templateName()) }

  Dict getValidationDict() {
    exists(Call call, Value dict |
      call = this.getADecorator() and
      call.getFunc().(Name).getId() = "validate" and
      call.getArg(0).pointsTo(dict, result)
    )
  }
}
