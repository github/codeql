/**
 * @name Missing catch of NumberFormatException
 * @description Calling a string to number conversion method without handling
 *              'NumberFormatException' may cause unexpected runtime exceptions.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id java/uncaught-number-format-exception
 * @tags reliability
 *       external/cwe/cwe-248
 */

import java

private class SpecialMethodAccess extends MethodAccess {
  predicate isValueOfMethod(string klass) {
    this.getMethod().getName() = "valueOf" and
    this.getQualifier().getType().(RefType).hasQualifiedName("java.lang", klass) and
    this.getAnArgument().getType().(RefType).hasQualifiedName("java.lang", "String")
  }

  predicate isParseMethod(string klass, string name) {
    this.getMethod().getName() = name and
    this.getQualifier().getType().(RefType).hasQualifiedName("java.lang", klass)
  }

  predicate throwsNFE() {
    this.isParseMethod("Byte", "parseByte") or
    this.isParseMethod("Short", "parseShort") or
    this.isParseMethod("Integer", "parseInt") or
    this.isParseMethod("Long", "parseLong") or
    this.isParseMethod("Float", "parseFloat") or
    this.isParseMethod("Double", "parseDouble") or
    this.isParseMethod("Byte", "decode") or
    this.isParseMethod("Short", "decode") or
    this.isParseMethod("Integer", "decode") or
    this.isParseMethod("Long", "decode") or
    this.isValueOfMethod("Byte") or
    this.isValueOfMethod("Short") or
    this.isValueOfMethod("Integer") or
    this.isValueOfMethod("Long") or
    this.isValueOfMethod("Float") or
    this.isValueOfMethod("Double")
  }
}

private class SpecialClassInstanceExpr extends ClassInstanceExpr {
  predicate isStringConstructor(string klass) {
    this.getType().(RefType).hasQualifiedName("java.lang", klass) and
    this.getAnArgument().getType().(RefType).hasQualifiedName("java.lang", "String") and
    this.getNumArgument() = 1
  }

  predicate throwsNFE() {
    this.isStringConstructor("Byte") or
    this.isStringConstructor("Short") or
    this.isStringConstructor("Integer") or
    this.isStringConstructor("Long") or
    this.isStringConstructor("Float") or
    this.isStringConstructor("Double")
  }
}

class NumberFormatException extends RefType {
  NumberFormatException() { this.hasQualifiedName("java.lang", "NumberFormatException") }
}

private predicate catchesNFE(TryStmt t) {
  exists(CatchClause cc, LocalVariableDeclExpr v |
    t.getACatchClause() = cc and
    cc.getVariable() = v and
    v.getType().(RefType).getASubtype*() instanceof NumberFormatException
  )
}

private predicate throwsNFE(Expr e) {
  e.(SpecialClassInstanceExpr).throwsNFE() or e.(SpecialMethodAccess).throwsNFE()
}

from Expr e
where
  throwsNFE(e) and
  not exists(TryStmt t |
    t.getBlock() = e.getEnclosingStmt().getEnclosingStmt*() and
    catchesNFE(t)
  ) and
  not exists(Callable c |
    e.getEnclosingCallable() = c and
    c.getAThrownExceptionType().getASubtype*() instanceof NumberFormatException
  )
select e, "Potential uncaught 'java.lang.NumberFormatException'."
