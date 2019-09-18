/**
 * Provides classes for reasoning syntactically about a program.
 *
 * INTERNAL: Do not use outside of the `semmle.javascript.heuristics` module.
 */

import javascript

/**
 * Holds if the "name" of `read` matches `regexp`.
 *
 * The "name" is one of:
 * - the name of the read variable, if `read` is a variable read
 * - the name of the read property, if `read` is property read
 * - the suffix of the getter-method name, if `read` is an invocation, for example "Number" in "getNumber"
 */
bindingset[regexp]
predicate isReadFrom(DataFlow::Node read, string regexp) {
  exists(DataFlow::Node actualRead |
    actualRead = read.asExpr().getUnderlyingValue().(LogOrExpr).getAnOperand().flow() or // unfold `x || y` once
    actualRead = read
  |
    exists(string name | name.regexpMatch(regexp) |
      actualRead.asExpr().getUnderlyingValue().(VarAccess).getName() = name or
      actualRead.(DataFlow::PropRead).getPropertyName() = name or
      actualRead.(DataFlow::InvokeNode).getCalleeName() = "get" + name
    )
  )
}

/**
 * Holds if `rhs` is assigned to a "name" that matches `regexp`.
 *
 * The "name" is one of:
 * - the name of the written variable, if `rhs` is the right hand side of a variable write
 * - the name of the written property, if `rhs` is the right hand side of a property write
 */
bindingset[regexp]
predicate isAssignedTo(DataFlow::Node rhs, string regexp) {
  exists(string name |
    name.regexpMatch(regexp) and
    // avoid assignments that preserve the name
    not isReadFrom(rhs, "(?i).*\\Q" + name + "\\E")
  |
    exists(Variable var |
      rhs.asExpr() = var.getAnAssignedExpr() and
      name = var.getName()
    )
    or
    exists(DataFlow::PropWrite prop |
      rhs = prop.getRhs() and
      prop.getPropertyName() = name
    )
  )
}

/**
 * Holds if `arg` is an argument to a callee with a name that matches `regexp`.
 */
bindingset[regexp]
predicate isArgTo(DataFlow::Node arg, string regexp) {
  exists(DataFlow::InvokeNode invk |
    invk.getCalleeName().regexpMatch(regexp) and
    arg = invk.getAnArgument()
  )
}

/**
 * Holds if `n` is a concatenation containing something with a name that matches `regexp`.
 */
bindingset[regexp]
predicate isConcatenatedWith(StringOps::Concatenation n, string regexp) {
  isReadFrom(n.getAnOperand(), regexp)
}

/**
 * Holds if `n` is a concatenation containing something with a name that matches `regexp`.
 */
bindingset[regexp]
predicate isConcatenatedWithString(StringOps::Concatenation n, string regexp) {
  n.getAnOperand().getStringValue().regexpMatch(regexp)
}

/**
 * Holds if `n` is concatenated between two string constants that match `lRegexp` and `rRegexp` respectively.
 */
bindingset[lRegexp, rRegexp]
predicate isConcatenatedWithStrings(string lRegexp, StringOps::ConcatenationLeaf n, string rRegexp) {
  n.getPreviousLeaf().getStringValue().regexpMatch(lRegexp) and
  n.getNextLeaf().getStringValue().regexpMatch(rRegexp)
}

/**
 * Holds if `n` is assigned to, or concatenated with something with a name that matches `regexp`.
 */
bindingset[regexp]
predicate isAssignedToOrConcatenatedWith(DataFlow::Node n, string regexp) {
  isAssignedTo(n, regexp) or
  isConcatenatedWith(n, regexp)
}
