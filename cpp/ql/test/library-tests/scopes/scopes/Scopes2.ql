/**
 * @name Scopes2
 * @kind table
 */
import cpp

// This test finds places where Element.getParentScope() isn't tree-like.  There
// should be no results.
from Element e, int i
where
	i = count(e.getParentScope()) and
	(
		i > 1 or // multiple parents
		e.getParentScope+() = e or // cyclic parent relation
		(
			// not GlobalNamespace ancestor
			i > 0 and
			not e.getParentScope+() instanceof GlobalNamespace
		)
	)
select e, i
