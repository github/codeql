/**
 * @name Nodes With Type At Length Limit
 * @description Counts the number of AST nodes with a type at the type path length limit.
 * @kind metric
 * @id rust/summary/nodes-at-type-path-length-limit
 * @tags summary
 */

import rust
import codeql.rust.internal.TypeInference

from int atLimit
where
  atLimit =
    count(AstNode n, TypePath path |
      exists(inferType(n, path)) and path.length() = getTypePathLimit()
    |
      n
    )
select atLimit
