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
import Collection

from Variable v
where
  v.fromSource()
  and isCollectionType(v.getType())

  // Publics might get assigned elsewhere
  and (v instanceof LocalVariable or v.(Field).isPrivate())

  // All initializers (if any) are empty collections.
  and forall( AssignableDefinition d | v = d.getTarget() | d.getSource() instanceof EmptyCollectionCreation )

  // All accesses do not add data.
  and forex( Access a | v.getAnAccess()=a | noAddAccess(a) or emptyCollectionAssignment(a) )

  // Attributes indicate some kind of reflection
  and (not exists( Attribute a | v=a.getTarget() ))

  // There is at least one non-assignment access
  and noAddAccess(v.getAnAccess())
select v, "The contents of this container are never initialized."

