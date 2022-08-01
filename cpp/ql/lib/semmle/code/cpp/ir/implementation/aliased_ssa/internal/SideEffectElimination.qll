import cpp as CPP
import semmle.code.cpp.ir.implementation.unaliased_ssa.IR as Unaliased
import AliasAnalysis as Alias
import AliasConfiguration as Conf
import semmle.code.cpp.models.interfaces.SideEffect as SideEffect

private predicate noLocalSideEffectWrite(CPP::Function func) {
  forall(Unaliased::AddressOperand addr | addr.getUse().getEnclosingFunction() = func |
    not (
      Alias::getAddressOperandAllocation(addr) instanceof Conf::VariableAllocation and
      Alias::getAddressOperandAllocation(addr).(Conf::VariableAllocation).alwaysEscapes()
    )
  )
}

language[monotonicAggregates]
private predicate noTransitiveSideEffectWrite(CPP::Function func) {
  exists(Unaliased::IRFunction irFunc | irFunc.getFunction() = func) and
  noLocalSideEffectWrite(func) and
  forall(Unaliased::CallInstruction call | call.getEnclosingFunction() = func |
    exists(call.getStaticCallTarget())
  ) and
  forall(Unaliased::CallInstruction call, CPP::Function callee |
    call.getStaticCallTarget() = callee and
    call.getEnclosingFunction() = func
  |
    noTransitiveSideEffectWrite(callee)
    or
    callee.(SideEffect::SideEffectFunction).hasOnlySpecificWriteSideEffects()
  )
}

predicate removeableSideEffect(Unaliased::SideEffectInstruction instr) {
  (
    instr instanceof Unaliased::CallSideEffectInstruction or
    instr instanceof Unaliased::CallReadSideEffectInstruction
  ) and
  noTransitiveSideEffectWrite(instr
        .getPrimaryInstruction()
        .(Unaliased::CallInstruction)
        .getStaticCallTarget())
}
