/**
 * @name Warmup type inference cache
 * @description Exercises the type inference implementation to make sure that it is in the cache.
 * @kind diagnostic
 * @id rust/diagnostics/type-inference-warmup
 * @tags type-inference-warmup
 */

import rust
import codeql.rust.internal.TypeInference

from Type t
where t = inferType(_) and 1 = 2
select ""
