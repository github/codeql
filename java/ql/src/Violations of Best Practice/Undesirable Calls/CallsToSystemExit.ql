/**
 * @name Forcible JVM termination
 * @description Calling 'System.exit', 'Runtime.halt', or 'Runtime.exit' may make code harder to
 *              reuse and prevent important cleanup steps from running.
 * @kind problem
 * @problem.severity warning
 * @precision medium
 * @id java/jvm-exit
 * @previous-id java/jvm-exit-prevents-cleanup-and-reuse
 * @tags quality
 *       reliability
 *       correctness
 *       external/cwe/cwe-382
 */

import java

/**
 * A `Method` which, when called, causes the JVM to exit or halt.
 *
 * Explicitly includes these methods from the java standard library:
 *   - `java.lang.System.exit`
 *   - `java.lang.Runtime.halt`
 *   - `java.lang.Runtime.exit`
 */
class ExitOrHaltMethod extends Method {
  ExitOrHaltMethod() {
    exists(Class system | this.getDeclaringType() = system |
      this.hasName("exit") and
      system.hasQualifiedName("java.lang", ["System", "Runtime"])
      or
      this.hasName("halt") and
      system.hasQualifiedName("java.lang", "Runtime")
    )
  }
}

/** A `MethodCall` to an `ExitOrHaltMethod`, which causes the JVM to exit abruptly. */
class ExitOrHaltMethodCall extends MethodCall {
  ExitOrHaltMethodCall() {
    exists(ExitOrHaltMethod exitMethod | this.getMethod() = exitMethod |
      exists(SourceMethodNotMainOrTest srcMethod | this = srcMethod.getACallSite(exitMethod))
    )
  }
}

/**
 * An intentional `MethodCall` to a system or runtime "exit" method, such as for
 * functions which exist for the purpose of exiting the program. Assumes that an exit method
 * call within a method is intentional if the exit code is passed from a parameter of the
 * enclosing method.
 */
class IntentionalExitMethodCall extends ExitOrHaltMethodCall {
  IntentionalExitMethodCall() {
    this.getMethod().hasName("exit") and
    this.getAnArgument() = this.getEnclosingCallable().getAParameter().getAnAccess()
  }
}

/**
 * A `Method` that is defined in source code and is not a `MainMethod` or a `LikelyTestMethod`.
 */
class SourceMethodNotMainOrTest extends Method {
  SourceMethodNotMainOrTest() {
    this.fromSource() and
    not this instanceof MainMethod and
    not (
      this.getEnclosingCallable*() instanceof LikelyTestMethod
      or
      this.getDeclaringType()
          .getEnclosingType*()
          .(LocalClassOrInterface)
          .getLocalTypeDeclStmt()
          .getEnclosingCallable() instanceof LikelyTestMethod
    )
  }
}

from ExitOrHaltMethodCall mc
where not mc instanceof IntentionalExitMethodCall
select mc,
  "Avoid calls to " + mc.getMethod().getDeclaringType().getName() + "." + mc.getMethod().getName() +
    "() as this prevents runtime cleanup and makes code harder to reuse."
