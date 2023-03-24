import semmle.code.cpp.ir.implementation.raw.IR as OldIR
import semmle.code.cpp.ir.implementation.raw.internal.reachability.ReachableBlock as Reachability
import semmle.code.cpp.ir.implementation.raw.internal.reachability.Dominance as Dominance
import semmle.code.cpp.ir.implementation.unaliased_ssa.IR as NewIR
import semmle.code.cpp.ir.implementation.raw.internal.IRConstruction as RawStage
import semmle.code.cpp.ir.implementation.internal.TInstruction::UnaliasedSsaInstructions as SsaInstructions

/** DEPRECATED: Alias for SsaInstructions */
deprecated module SSAInstructions = SsaInstructions;

import semmle.code.cpp.ir.internal.IRCppLanguage as Language
import SimpleSSA as Alias
import semmle.code.cpp.ir.implementation.internal.TOperand::UnaliasedSsaOperands as SsaOperands

/** DEPRECATED: Alias for SsaOperands */
deprecated module SSAOperands = SsaOperands;
