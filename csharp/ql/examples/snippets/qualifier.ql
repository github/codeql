/**
 * @id cs/examples/qualifier
 * @name Expression qualifier
 * @description Finds qualified expressions (e.g. 'a.b()') and their qualifiers ('a').
 * @tags qualifier
 *       chain
 */

import csharp

from QualifiableExpr qualifiedExpr, Expr qualifier
where qualifier = qualifiedExpr.getQualifier()
select qualifiedExpr, qualifier
