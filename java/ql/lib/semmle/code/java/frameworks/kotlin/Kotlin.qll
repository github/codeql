/** Provides classes and predicates related to `kotlin`. */

import java

/** A call to Kotlin's `apply` method. */
class KotlinApply extends MethodCall {
  ExtensionMethod m;

  KotlinApply() {
    this.getMethod() = m and
    m.hasQualifiedName("kotlin", "StandardKt", "apply")
  }

  /** Gets the function block argument of this call. */
  LambdaExpr getLambdaArg() {
    result = this.getArgument(m.getExtensionReceiverParameterIndex() + 1)
  }

  /** Gets the receiver argument of this call. */
  Argument getReceiver() { result = this.getArgument(m.getExtensionReceiverParameterIndex()) }
}
