/**
 * @name Warmup type inference cache
 * @description Exercises the type inference implementation to make sure that it is in the cache.
 * @kind problem
 * @problem.severity recommendation
 * @id rust/diagnostics/type-inference-warmup
 * @tags type-inference-warmup
 */

import rust
import codeql.rust.internal.Type
import codeql.rust.internal.TypeInference

from UnitType t
where t = inferType(_)
select t, "Dummy result"
