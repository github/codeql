/** Provides classes and predicates for reasoning about `java.lang.NumberFormatException`. */

import java

/** A call to a string to number conversion. */
private class SpecialMethodCall extends MethodCall {
  predicate isValueOfMethod(string klass) {
    this.getMethod().getName() = "valueOf" and
    this.getQualifier().getType().(RefType).hasQualifiedName("java.lang", klass) and
    this.getAnArgument().getType().(RefType).hasQualifiedName("java.lang", "String")
  }

  predicate isParseMethod(string klass, string name) {
    this.getMethod().getName() = name and
    this.getQualifier().getType().(RefType).hasQualifiedName("java.lang", klass)
  }

  predicate throwsNfe() {
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

/** A `ClassInstanceExpr` that constructs a number from its string representation. */
private class SpecialClassInstanceExpr extends ClassInstanceExpr {
  predicate isStringConstructor(string klass) {
    this.getType().(RefType).hasQualifiedName("java.lang", klass) and
    this.getAnArgument().getType().(RefType).hasQualifiedName("java.lang", "String") and
    this.getNumArgument() = 1
  }

  predicate throwsNfe() {
    this.isStringConstructor("Byte") or
    this.isStringConstructor("Short") or
    this.isStringConstructor("Integer") or
    this.isStringConstructor("Long") or
    this.isStringConstructor("Float") or
    this.isStringConstructor("Double")
  }
}

/** The class `java.lang.NumberFormatException`. */
class NumberFormatException extends RefType {
  NumberFormatException() { this.hasQualifiedName("java.lang", "NumberFormatException") }
}

/** Holds if `java.lang.NumberFormatException` is caught. */
predicate catchesNfe(TryStmt t) {
  exists(CatchClause cc, LocalVariableDeclExpr v |
    t.getACatchClause() = cc and
    cc.getVariable() = v and
    v.getType().(RefType).getADescendant() instanceof NumberFormatException
  )
}

/** Holds if `java.lang.NumberFormatException` can be thrown. */
predicate throwsNfe(Expr e) {
  e.(SpecialClassInstanceExpr).throwsNfe() or e.(SpecialMethodCall).throwsNfe()
}
