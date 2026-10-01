/** Definitions related to `java.lang.String`. */
overlay[local?]
module;

private import java
private import semmle.code.java.dataflow.FlowSummary

/**
 * A call to `String.valueOf(Object)` where the argument is a `CharSequence`,
 * for example a `String` or a `StringBuilder`.
 *
 * Such a call is equivalent to calling `toString()` on the argument, which for
 * a `CharSequence` is guaranteed to yield a string containing the characters of
 * the argument, so taint is propagated. This is in contrast to `valueOf(Object)`
 * calls in general, where `toString()` may not expose the state of the argument.
 */
private class StringValueOfCharSequence extends SyntheticCallable {
  StringValueOfCharSequence() { this = "java.lang.String.valueOf(Object)+CharSequence" }

  override MethodCall getACall() {
    exists(Method m | m = result.getMethod().getSourceDeclaration() |
      m.hasQualifiedName("java.lang", "String", "valueOf") and
      m.getParameterType(0) instanceof TypeObject
    ) and
    result
        .getArgument(0)
        .getType()
        .(RefType)
        .getAnAncestor()
        .hasQualifiedName("java.lang", "CharSequence")
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[0]" and
    output = "ReturnValue" and
    preservesValue = false
  }

  override Type getReturnType() { result instanceof TypeString }
}
