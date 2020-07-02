import semmle.code.cpp.ir.implementation.raw.IR as OldIR
import semmle.code.cpp.ir.implementation.raw.internal.reachability.ReachableBlock as Reachability
import semmle.code.cpp.ir.implementation.raw.internal.reachability.Dominance as Dominance
import semmle.code.cpp.ir.implementation.unaliased_ssa.IR as NewIR
import semmle.code.cpp.ir.implementation.raw.internal.IRConstruction as RawStage
import semmle.code.cpp.ir.implementation.internal.TInstruction::UnaliasedSSAInstructions as SSAInstructions
import semmle.code.cpp.ir.internal.IRCppLanguage as Language
import SimpleSSA as Alias
