/**
 * @name Inefficient toArray on zero-length argument
 * @description Calling 'Collection.toArray' with a zero-length array argument is inefficient.
 * @kind problem
 * @problem.severity recommendation
 * @precision low
 * @id java/inefficient-to-array
 * @deprecated
 */

import java

/*
 * This method uses the toArray() method of a collection derived class, and passes in a
 * zero-length prototype array argument.
 *
 * It is more efficient to  use myCollection.toArray(new Foo[myCollection.size()]).
 * If the array passed in is big enough to store all of the elements of the collection,
 * then it is populated and returned directly. This avoids the need to create a
 * second array (by reflection) to return as the result.
 *
 * The new array has to be created as the argument value. Values in both branches of
 * a conditional has to be an empty array.
 */

predicate emptyArrayLiteral(Expr e) {
  // ArrayCreationExpr with zero-length init expr
  exists(ArrayCreationExpr arr | arr = e |
    exists(arr.getInit()) and
    not exists(arr.getInit().getAnInit())
  )
  or
  // ArrayCreationExpr where 0th dimension is zero literal
  e.(ArrayCreationExpr).getDimension(0).(IntegerLiteral).getIntValue() = 0
  or
  exists(ConditionalExpr cond | cond = e |
    emptyArrayLiteral(cond.getTrueExpr()) and
    emptyArrayLiteral(cond.getFalseExpr())
  )
}

class EmptyArrayLiteral extends Expr {
  EmptyArrayLiteral() { emptyArrayLiteral(this) }
}

from EmptyArrayLiteral l, MethodAccess ma, Method m, GenericInterface coll
where
  coll.hasQualifiedName("java.util", "Collection") and
  ma.getMethod() = m and
  m.hasName("toArray") and
  m.getDeclaringType().getASupertype*().getSourceDeclaration() = coll and
  ma.getArgument(0) = l
select ma, "Collection.toArray(...) called with zero-length array argument."
