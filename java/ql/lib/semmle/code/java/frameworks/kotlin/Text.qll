/** Provides classes and predicates related to `kotlin.text`. */

import java

/** The type `kotlin.text.StringsKt`, where `String` extension methods are declared. */
class StringsKt extends RefType {
  StringsKt() { this.hasQualifiedName("kotlin.text", "StringsKt") }
}

/** A call to the extension method `String.toRegex` from `kotlin.text`. */
class KtToRegex extends MethodCall {
  KtToRegex() {
    this.getMethod().getDeclaringType() instanceof StringsKt and
    this.getMethod().hasName("toRegex")
  }

  /** Gets the constant string value being converted to a regex by this call. */
  string getExpressionString() {
    result = this.getArgument(0).(CompileTimeConstantExpr).getStringValue()
  }
}
