/**
 * Provides predicates for identifying precondition and assertion checks like
 * `com.google.common.base.Preconditions` and
 * `org.apache.commons.lang3.Validate`.
 */
overlay[local?]
module;

import java

/**
 * Holds if `m` is a method that checks that its argument at position `arg` is
 * equal to true and throws otherwise.
 */
private predicate methodCheckTrue(Method m, int arg) {
  arg = 0 and
  (
    m.hasQualifiedName("com.google.common.base", "Preconditions", ["checkArgument", "checkState"]) or
    m.hasQualifiedName("com.google.common.base", "Verify", "verify") or
    m.hasQualifiedName("org.apache.commons.lang3", "Validate", ["isTrue", "validState"]) or
    m.hasQualifiedName("org.junit.jupiter.api", "Assertions", "assertTrue") or
    m.hasQualifiedName("org.junit.jupiter.api", "Assumptions", "assumeTrue") or
    m.hasQualifiedName("org.testng", "Assert", "assertTrue")
  )
  or
  m.getParameter(arg).getType() instanceof BooleanType and
  (
    m.hasQualifiedName("org.junit", "Assert", "assertTrue") or
    m.hasQualifiedName("org.junit", "Assume", "assumeTrue") or
    m.hasQualifiedName("junit.framework", _, "assertTrue")
  )
}

/**
 * Holds if `m` is a method that checks that its argument at position `arg` is
 * equal to false and throws otherwise.
 */
private predicate methodCheckFalse(Method m, int arg) {
  arg = 0 and
  (
    m.hasQualifiedName("org.junit.jupiter.api", "Assertions", "assertFalse") or
    m.hasQualifiedName("org.junit.jupiter.api", "Assumptions", "assumeFalse") or
    m.hasQualifiedName("org.testng", "Assert", "assertFalse")
  )
  or
  m.getParameter(arg).getType() instanceof BooleanType and
  (
    m.hasQualifiedName("org.junit", "Assert", "assertFalse") or
    m.hasQualifiedName("org.junit", "Assume", "assumeFalse") or
    m.hasQualifiedName("junit.framework", _, "assertFalse")
  )
}

/**
 * Holds if `m` is a method that checks that its argument at position `arg` is
 * not null and throws otherwise.
 */
private predicate methodCheckNotNull(Method m, int arg) {
  arg = 0 and
  (
    m.hasQualifiedName("com.google.common.base", "Preconditions", "checkNotNull") or
    m.hasQualifiedName("com.google.common.base", "Verify", "verifyNotNull") or
    m.hasQualifiedName("org.apache.commons.lang3", "Validate", "notNull") or
    m.hasQualifiedName("java.util", "Objects", "requireNonNull") or
    m.hasQualifiedName("org.junit.jupiter.api", "Assertions", "assertNotNull") or
    m.hasQualifiedName("org.junit", "Assume", "assumeNotNull") or // vararg
    m.hasQualifiedName("org.testng", "Assert", "assertNotNull")
  )
  or
  arg = m.getNumberOfParameters() - 1 and
  (
    m.hasQualifiedName("org.junit", "Assert", "assertNotNull") or
    m.hasQualifiedName("junit.framework", _, "assertNotNull")
  )
}

/**
 * Holds if `m` is a method that checks that its argument at position `arg`
 * satisfies a property specified by another argument and throws otherwise.
 */
private predicate methodCheckThat(Method m, int arg) {
  m.getParameter(arg).getType().getErasure() instanceof TypeObject and
  (
    m.hasQualifiedName("org.hamcrest", "MatcherAssert", "assertThat") or
    m.hasQualifiedName("org.junit", "Assert", "assertThat") or
    m.hasQualifiedName("org.junit", "Assume", "assumeThat")
  )
}

/** Holds if `m` is a method that unconditionally throws. */
private predicate methodUnconditionallyThrows(Method m) {
  m.hasQualifiedName("org.junit.jupiter.api", "Assertions", "fail") or
  m.hasQualifiedName("org.junit", "Assert", "fail") or
  m.hasQualifiedName("junit.framework", _, "fail") or
  m.hasQualifiedName("org.testng", "Assert", "fail")
}

/**
 * Holds if `mc` is a call to a method that checks that its argument `arg` is
 * equal to `checkTrue` and throws otherwise.
 */
predicate methodCallChecksBoolean(MethodCall mc, Expr arg, boolean checkTrue) {
  exists(int pos | mc.getArgument(pos) = arg |
    methodCheckTrue(mc.getMethod().getSourceDeclaration(), pos) and checkTrue = true
    or
    methodCheckFalse(mc.getMethod().getSourceDeclaration(), pos) and checkTrue = false
  )
}

/**
 * Holds if `mc` is a call to a method that checks that its argument `arg` is
 * not null and throws otherwise.
 */
predicate methodCallChecksNotNull(MethodCall mc, Expr arg) {
  exists(int pos | mc.getArgument(pos) = arg |
    methodCheckNotNull(mc.getMethod().getSourceDeclaration(), pos)
    or
    methodCheckThat(mc.getMethod().getSourceDeclaration(), pos) and
    mc.getAnArgument().(MethodCall).getMethod().getName() = "notNullValue"
  )
}

/**
 * Holds if `mc` is a call to a method that checks one of its arguments in some
 * way and possibly throws.
 */
predicate methodCallChecksArgument(MethodCall mc) {
  methodCallChecksBoolean(mc, _, _) or
  methodCallChecksNotNull(mc, _)
}

/** Holds if `mc` is a call to a method that unconditionally throws. */
predicate methodCallUnconditionallyThrows(MethodCall mc) {
  methodUnconditionallyThrows(mc.getMethod().getSourceDeclaration()) or
  exists(BooleanLiteral b | methodCallChecksBoolean(mc, b, b.getBooleanValue().booleanNot()))
}

/**
 * DEPRECATED: Use `methodCallChecksBoolean` instead.
 *
 * Holds if `m` is a non-overridable method that checks that its zero-indexed `argument`
 * is equal to `checkTrue` and throws otherwise.
 */
deprecated predicate conditionCheckMethodArgument(Method m, int argument, boolean checkTrue) {
  methodCheckTrue(m, argument) and checkTrue = true
  or
  methodCheckFalse(m, argument) and checkTrue = false
}

/**
 * DEPRECATED: Use `methodCallChecksBoolean` instead.
 *
 * Holds if `ma` is an access to a non-overridable method that checks that its
 * zero-indexed `argument` is equal to `checkTrue` and throws otherwise.
 */
deprecated predicate conditionCheckArgument(MethodCall ma, int argument, boolean checkTrue) {
  conditionCheckMethodArgument(ma.getMethod().getSourceDeclaration(), argument, checkTrue)
}
