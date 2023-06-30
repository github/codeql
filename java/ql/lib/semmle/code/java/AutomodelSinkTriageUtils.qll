private import java
private import semmle.code.java.dataflow.ExternalFlow as ExternalFlow
private import semmle.code.java.dataflow.TaintTracking::TaintTracking

/** Gets the models-as-data description for the method argument with the index `index`. */
bindingset[index]
private string getArgumentForIndex(int index) {
  index = -1 and result = "Argument[this]"
  or
  index >= 0 and result = "Argument[" + index + "]"
}

private boolean considerSubtypes(Callable callable) {
  if
    callable.isStatic() or
    callable.getDeclaringType().isStatic() or
    callable.isFinal() or
    callable.getDeclaringType().isFinal()
  then result = false
  else result = true
}

private class SinkModelExpr extends Expr {
  predicate hasSignature(
    string package, string type, boolean subtypes, string name, string signature, string input
  ) {
    exists(Call call, Callable callable, int argIdx |
      call.getCallee() = callable and
      (
        this = call.getArgument(argIdx)
        or
        this = call.getQualifier() and argIdx = -1
      ) and
      input = getArgumentForIndex(argIdx) and
      package = callable.getDeclaringType().getPackage().getName() and
      type = callable.getDeclaringType().getErasure().(RefType).nestedName() and
      subtypes = considerSubtypes(callable) and
      name = callable.getName() and
      signature = ExternalFlow::paramsString(callable)
    )
  }
}

private string pyBool(boolean b) {
  b = true and result = "True"
  or
  b = false and result = "False"
}

/**
 * Gets a string representation of the existing sink model at the expression `e`, in the format in
 * which it would appear in a Models-as-Data file.
 */
string getSinkModelRepr(SinkModelExpr e) {
  exists(
    string package, string type, boolean subtypes, string name, string signature, string input,
    string ext, string kind, string provenance
  |
    e.hasSignature(package, type, subtypes, name, signature, input) and
    ExternalFlow::sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance) and
    provenance = "ai-generated" and
    result =
      "\"" + package + "\", \"" + type + "\", " + pyBool(subtypes) + ", \"" + name + "\", \"" +
        signature + "\", \"" + ext + "\", \"" + input + "\", \"" + kind + "\", \"" + provenance +
        "\""
  )
}

/**
 * Gets the string representation of a sink model in a format suitable for appending to an alert
 * message.
 */
string getSinkModelQueryRepr(SinkModelExpr e) { result = "\nsinkModel: " + getSinkModelRepr(e) }
// TODO: make this logic more generic
// private predicate relevantSinkModel(int c, string s) {
//   exists(RequestForgeryFlow::PathNode source, RequestForgeryFlow::PathNode sink |
//     RequestForgeryFlow::flowPath(source, sink) and
//     s = getSinkModelRepr(sink.getNode().asExpr())
//   ) and
//   c =
//     count(RequestForgeryFlow::PathNode sink |
//       exists(RequestForgeryFlow::PathNode source |
//         RequestForgeryFlow::flowPath(source, sink) and
//         s = getSinkModelRepr(sink.getNode().asExpr())
//       )
//     )
// }
