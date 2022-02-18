private import java
private import semmle.code.java.semantic.SemanticExpr
private import ArrayLengthFlow

/**
 * Gets the constant integer value of the specified expression, if any.
 */
int getIntConstantValue(SemExpr expr) {
  exists(ArrayCreationExpr a |
    arrayLengthDef(getJavaExpr(expr), a) and
    a.getFirstDimensionSize() = result
  )
  or
  exists(Field a, FieldRead arrlen |
    a.isFinal() and
    a.getInitializer().(ArrayCreationExpr).getFirstDimensionSize() = result and
    arrlen.getField() instanceof ArrayLengthField and
    arrlen.getQualifier() = a.getAnAccess() and
    getJavaExpr(expr) = arrlen
  )
  or
  exists(CompileTimeConstantExpr const | const = getJavaExpr(expr) | result = const.getIntValue())
}
