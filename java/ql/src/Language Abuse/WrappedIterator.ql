/**
 * @name Iterable wrapping an iterator
 * @description An 'Iterable' that reuses an 'Iterator' instance does not support multiple traversals
 *              and can lead to unexpected behavior.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id java/iterable-wraps-iterator
 * @tags correctness
 *       reliability
 */

import java
import IterableClass

/** An `Iterable` that is merely a thin wrapper around a contained `Iterator`. */
predicate iteratorWrapper(Iterable it, Field f, boolean wrap) {
  // A class that implements `java.lang.Iterable` and
  // declares a final or effectively final field ...
  f.getDeclaringType().getSourceDeclaration() = it and
  (
    f.isFinal()
    or
    strictcount(f.getAnAssignedValue()) = 1 and
    f.getAnAssignedValue().getEnclosingCallable() instanceof InitializerMethod
  ) and
  // ... whose type is a sub-type of `java.util.Iterator` and ...
  f.getType()
      .(RefType)
      .getAnAncestor()
      .getSourceDeclaration()
      .hasQualifiedName("java.util", "Iterator") and
  // ... whose value is returned by the `iterator()` method of this class ...
  exists(Expr iterator | iterator = it.simpleIterator() |
    // ... either directly ...
    iterator = f.getAnAccess() and wrap = false
    or
    // ... or wrapped in another Iterator.
    exists(ClassInstanceExpr cie | cie = iterator and wrap = true |
      cie.getAnArgument() = f.getAnAccess() or
      cie.getAnonymousClass().getAMethod() = f.getAnAccess().getEnclosingCallable()
    )
  )
}

from Iterable i, Field f, boolean wrap, string appearto, string iteratorbasedon
where
  iteratorWrapper(i, f, wrap) and
  (
    wrap = true and appearto = "appear to " and iteratorbasedon = "an iterator based on "
    or
    wrap = false and appearto = "" and iteratorbasedon = ""
  )
select i,
  "This class implements Iterable, but does not " + appearto + "support multiple iterations," +
    " since its iterator method always returns " + iteratorbasedon + "the same $@.", f, "iterator"
