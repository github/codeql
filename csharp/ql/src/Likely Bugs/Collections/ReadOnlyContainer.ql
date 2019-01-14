/**
 * @name Container contents are never initialized
 * @description Querying the contents of a collection or map that is never initialized is not normally useful.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id cs/empty-collection
 * @tags reliability
 *       maintainability
 *       useless-code
 *       external/cwe/cwe-561
 */

import csharp
import semmle.code.csharp.commons.Collections

from Variable v
where
  v.fromSource() and
  v.getType() instanceof CollectionType and
  // Publics might get assigned elsewhere
  (v instanceof LocalVariable or v.(Field).isPrivate()) and
  // All initializers (if any) are empty collections.
  forall(AssignableDefinition d | v = d.getTarget() |
    d.getSource() instanceof EmptyCollectionCreation
  ) and
  // All accesses do not add data.
  forex(Access a | v.getAnAccess() = a |
    a instanceof NoAddAccess or a instanceof EmptyInitializationAccess
  ) and
  // Attributes indicate some kind of reflection
  not exists(Attribute a | v = a.getTarget()) and
  // There is at least one non-assignment access
  v.getAnAccess() instanceof NoAddAccess
select v, "The contents of this container are never initialized."
