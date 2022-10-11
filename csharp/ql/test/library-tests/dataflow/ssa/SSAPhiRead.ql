import csharp
import semmle.code.csharp.dataflow.internal.SsaImpl

from Ssa::SourceVariable v, ControlFlow::BasicBlock bb
where phiReadExposedForTesting(bb, v)
select v, bb
