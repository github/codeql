/**
 * @name Unchecked return value
 * @description If most of the calls to a method use the return value
 *              of that method, the calls that do not check the return value may be mistakes.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id cs/unchecked-return-value
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-252
 *       statistical
 *       non-attributable
 */

import csharp
import semmle.code.csharp.frameworks.system.IO
import semmle.code.csharp.Chaining

/** Holds if `m` is a method whose return value should always be checked. */
predicate important(Method m) {
  exists(Method read | read = any(SystemIOStreamClass c).getReadMethod() |
    m = read.getAnOverrider*()
  )
  or
  exists(Method readByte | readByte = any(SystemIOStreamClass c).getReadByteMethod() |
    m = readByte.getAnOverrider*()
  )
  // add more ...
}

/** Holds if the return type of `m` is an instantiated type parameter from `m`. */
predicate methodHasGenericReturnType(ConstructedMethod cm) {
  exists(UnboundGenericMethod ugm |
    ugm = cm.getSourceDeclaration() and
    ugm.getReturnType() = ugm.getATypeParameter()
  )
}

/** Holds if `m` is a method whose return value should be checked because most calls to `m` do. */
// statistically dubious:
predicate dubious(Method m, int percentage) {
  not important(m) and
  // Suppress on Void methods
  not m.getReturnType() instanceof VoidType and
  // Suppress on methods designed for chaining
  not designedForChaining(m) and
  exists(int used, int total, Method target |
    target = m.getSourceDeclaration() and
    used =
      count(MethodCall mc |
        mc.getTarget().getSourceDeclaration() = target and
        not mc instanceof DiscardedMethodCall and
        (methodHasGenericReturnType(m) implies m.getReturnType() = mc.getTarget().getReturnType())
      ) and
    total =
      count(MethodCall mc |
        mc.getTarget().getSourceDeclaration() = target and
        (methodHasGenericReturnType(m) implies m.getReturnType() = mc.getTarget().getReturnType())
      ) and
    used != total and
    percentage = used * 100 / total and
    percentage >= 90 and
    chainedUses(m) * 100 / total <= 45 // no more than 45% of calls to this method are chained
  )
}

int chainedUses(Method m) {
  result =
    count(MethodCall mc, MethodCall qual |
      m = mc.getTarget() and
      hasQualifierAndTarget(mc, qual, qual.getTarget())
    )
}

predicate hasQualifierAndTarget(MethodCall mc, Expr qualifier, Method m) {
  qualifier = mc.getQualifier() and
  m = mc.getTarget()
}

/** Holds if `m` is a white-listed method where checking the return value is not required. */
predicate whitelist(Method m) {
  m.hasName("TryGetValue")
  or
  m.hasName("TryParse")
  or
  exists(Namespace n | n = m.getDeclaringType().getNamespace().getParentNamespace*() |
    n.getName().regexpMatch("(Fluent)?NHibernate") or
    n.getName() = "Moq"
  )
  // add more ...
}

class DiscardedMethodCall extends MethodCall {
  DiscardedMethodCall() {
    this.getParent() instanceof ExprStmt
    or
    exists(Callable c |
      this = c.getExpressionBody() and
      not c.canReturn(this)
    )
  }

  string query() {
    exists(Method m |
      m = getTarget() and
      not whitelist(m) and
      // Do not alert on "void wrapper methods", i.e., methods that are inserted
      // to deliberately ignore the returned value
      not getEnclosingCallable().getStatementBody().getNumberOfStmts() = 1
    |
      important(m) and result = "should always be checked"
      or
      exists(int percentage | dubious(m, percentage) |
        result = percentage.toString() + "% of calls to this method have their result used"
      )
    )
  }
}

from DiscardedMethodCall dmc, string message
where message = dmc.query()
select dmc, "Result of call to '" + dmc.getTarget().getName() + "' is ignored, but " + message + "."
