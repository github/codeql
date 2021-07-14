/**
 * @name Iterator implementing Iterable
 * @description An 'Iterator' that also implements 'Iterable' by returning itself as its 'Iterator'
 *              does not support multiple traversals. This can lead to unexpected behavior when
 *              it is viewed as an 'Iterable'.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id java/iterator-implements-iterable
 * @tags correctness
 *       reliability
 */

import java
import IterableClass

/** An `Iterable` that is also its own `Iterator`. */
class IterableIterator extends Iterable {
  IterableIterator() { simpleIterator() instanceof ThisAccess }
}

/** An `IterableIterator` that never returns any elements. */
class EmptyIterableIterator extends IterableIterator {
  EmptyIterableIterator() {
    exists(Method m |
      m.getDeclaringType().getSourceDeclaration() = this and
      m.getName() = "hasNext" and
      m.getBody()
          .(SingletonBlock)
          .getStmt()
          .(ReturnStmt)
          .getResult()
          .(BooleanLiteral)
          .getBooleanValue() = false
    )
  }
}

from IterableIterator i
where
  // Exclude the empty iterator as that is safe to reuse.
  not i instanceof EmptyIterableIterator
select i, "This Iterable is its own Iterator, but does not guard against multiple iterations."
