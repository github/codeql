import semmle.code.cpp.ir.implementation.raw.IR as OldIR
import semmle.code.cpp.ir.implementation.raw.internal.reachability.ReachableBlock as Reachability
import semmle.code.cpp.ir.implementation.raw.internal.reachability.Dominance as Dominance
import semmle.code.cpp.ir.implementation.unaliased_ssa.IR as NewIR
import SimpleSSA as Alias
