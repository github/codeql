/**
 * Provides classes representing individual opcodes.
 *
 * See ECMA-335 (https://www.ecma-international.org/publications/files/ECMA-ST/ECMA-335.pdf)
 * pages 32-101 for a detailed explanation of these instructions.
 */

private import CIL
private import semmle.code.dotnet.Variable as DotNet

module Opcodes {
  /** An `ldc.i4.m1` instruction. */
  class Ldc_i4_m1 extends IntLiteral, @cil_ldc_i4_m1 {
    override string getOpcodeName() { result = "ldc.i4.m1" }

    override string getValue() { result = "-1" }
  }

  /** An `ldc.i4.0` instruction. */
  class Ldc_i4_0 extends IntLiteral, @cil_ldc_i4_0 {
    override string getOpcodeName() { result = "ldc.i4.0" }

    override string getValue() { result = "0" }
  }

  /** An `ldc.i4.1` instruction. */
  class Ldc_i4_1 extends IntLiteral, @cil_ldc_i4_1 {
    override string getOpcodeName() { result = "ldc.i4.1" }

    override string getValue() { result = "1" }
  }

  /** An `ldc.i4.2` instruction. */
  class Ldc_i4_2 extends IntLiteral, @cil_ldc_i4_2 {
    override string getOpcodeName() { result = "ldc.i4.2" }

    override string getValue() { result = "2" }
  }

  /** An `ldc.i4.3` instruction. */
  class Ldc_i4_3 extends IntLiteral, @cil_ldc_i4_3 {
    override string getOpcodeName() { result = "ldc.i4.3" }

    override string getValue() { result = "3" }
  }

  /** An `ldc.i4.4` instruction. */
  class Ldc_i4_4 extends IntLiteral, @cil_ldc_i4_4 {
    override string getOpcodeName() { result = "ldc.i4.4" }

    override string getValue() { result = "4" }
  }

  /** An `ldc.i4.5` instruction. */
  class Ldc_i4_5 extends IntLiteral, @cil_ldc_i4_5 {
    override string getOpcodeName() { result = "ldc.i4.5" }

    override string getValue() { result = "5" }
  }

  /** An `ldc.i4.6` instruction. */
  class Ldc_i4_6 extends IntLiteral, @cil_ldc_i4_6 {
    override string getOpcodeName() { result = "ldc.i4.6" }

    override string getValue() { result = "6" }
  }

  /** An `ldc.i4.7` instruction. */
  class Ldc_i4_7 extends IntLiteral, @cil_ldc_i4_7 {
    override string getOpcodeName() { result = "ldc.i4.7" }

    override string getValue() { result = "7" }
  }

  /** An `ldc.i4.8` instruction. */
  class Ldc_i4_8 extends IntLiteral, @cil_ldc_i4_8 {
    override string getOpcodeName() { result = "ldc.i4.8" }

    override string getValue() { result = "8" }
  }

  /** An `ldc.i4` instruction. */
  class Ldc_i4 extends IntLiteral, @cil_ldc_i4 {
    override string getOpcodeName() { result = "ldc.i4" }

    override string getExtra() { result = this.getValue() }
  }

  /** An `ldc.i8` instruction. */
  class Ldc_i8 extends IntLiteral, @cil_ldc_i8 {
    override string getOpcodeName() { result = "ldc.i8" }

    override string getExtra() { result = this.getValue() }
  }

  /** An `ldc.i4.s` instruction. */
  class Ldc_i4_s extends IntLiteral, @cil_ldc_i4_s {
    override string getOpcodeName() { result = "ldc.i4.s" }

    override string getExtra() { result = this.getValue() }
  }

  /** An `ldnull` instruction. */
  class Ldnull extends Literal, @cil_ldnull {
    override string getOpcodeName() { result = "ldnull" }

    override string getValue() { result = "null" }

    override string getExtra() { none() }

    override Type getType() { result instanceof ObjectType }
  }

  /** An `ldc.r4` instruction. */
  class Ldc_r4 extends FloatLiteral, @cil_ldc_r4 {
    override string getOpcodeName() { result = "ldc.r4" }

    override string getExtra() { result = this.getValue() }

    override Type getType() { result instanceof FloatType }
  }

  /** An `ldc.r8` instruction. */
  class Ldc_r8 extends FloatLiteral, @cil_ldc_r8 {
    override string getOpcodeName() { result = "ldc.r8" }

    override string getExtra() { result = this.getValue() }

    override Type getType() { result instanceof DoubleType }
  }

  /** An `add` instruction. */
  class Add extends BinaryArithmeticExpr, @cil_add {
    override string getOpcodeName() { result = "add" }
  }

  /** An `add.ovf` instruction. */
  class Add_ovf extends BinaryArithmeticExpr, @cil_add_ovf {
    override string getOpcodeName() { result = "add.ovf" }
  }

  /** An `add.ovf.un` instruction. */
  class Add_ovf_un extends BinaryArithmeticExpr, @cil_add_ovf_un {
    override string getOpcodeName() { result = "add.ovf.un" }
  }

  /** A `sub` instruction. */
  class Sub extends BinaryArithmeticExpr, @cil_sub {
    override string getOpcodeName() { result = "sub" }
  }

  /** A `sub.ovf` instruction. */
  class Sub_ovf extends BinaryArithmeticExpr, @cil_sub_ovf {
    override string getOpcodeName() { result = "sub.ovf" }
  }

  /** A `sub.ovf.un` instruction. */
  class Sub_ovf_un extends BinaryArithmeticExpr, @cil_sub_ovf_un {
    override string getOpcodeName() { result = "sub.ovf.un" }
  }

  /** A `mul` instruction. */
  class Mul extends BinaryArithmeticExpr, @cil_mul {
    override string getOpcodeName() { result = "mul" }
  }

  /** A `mul.ovf` instruction. */
  class Mul_ovf extends BinaryArithmeticExpr, @cil_mul_ovf {
    override string getOpcodeName() { result = "mul.ovf" }
  }

  /** A `mul.ovf.un` instruction. */
  class Mul_ovf_un extends BinaryArithmeticExpr, @cil_mul_ovf_un {
    override string getOpcodeName() { result = "mul.ovf.un" }
  }

  /** A `div` instruction. */
  class Div extends BinaryArithmeticExpr, @cil_div {
    override string getOpcodeName() { result = "div" }
  }

  /** A `div.un` instruction. */
  class Div_un extends BinaryArithmeticExpr, @cil_div_un {
    override string getOpcodeName() { result = "div.un" }
  }

  /** A `rem` instruction. */
  class Rem extends BinaryArithmeticExpr, @cil_rem {
    override string getOpcodeName() { result = "rem" }
  }

  /** A `rem.un` instruction. */
  class Rem_un extends BinaryArithmeticExpr, @cil_rem_un {
    override string getOpcodeName() { result = "rem.un" }
  }

  /** A `neg` instruction. */
  class Neg extends UnaryExpr, @cil_neg {
    override string getOpcodeName() { result = "neg" }

    override NumericType getType() {
      result = this.getOperandType(0)
      or
      this.getOperandType(0) instanceof Enum and result instanceof IntType
    }
  }

  /** An `and` instruction. */
  class And extends BinaryBitwiseOperation, @cil_and {
    override string getOpcodeName() { result = "and" }
  }

  /** An `or` instruction. */
  class Or extends BinaryBitwiseOperation, @cil_or {
    override string getOpcodeName() { result = "or" }
  }

  /** An `xor` instruction. */
  class Xor extends BinaryBitwiseOperation, @cil_xor {
    override string getOpcodeName() { result = "xor" }
  }

  /** A `not` instruction. */
  class Not extends UnaryBitwiseOperation, @cil_not {
    override string getOpcodeName() { result = "not" }
  }

  /** A `shl` instruction. */
  class Shl extends BinaryBitwiseOperation, @cil_shl {
    override string getOpcodeName() { result = "shl" }
  }

  /** A `shr` instruction. */
  class Shr extends BinaryBitwiseOperation, @cil_shr {
    override string getOpcodeName() { result = "shr" }
  }

  /** A `shr.un` instruction. */
  class Shr_un extends BinaryBitwiseOperation, @cil_shr_un {
    override string getOpcodeName() { result = "shr.un" }
  }

  /** A `ceq` instruction. */
  class Ceq extends ComparisonOperation, @cil_ceq {
    override string getOpcodeName() { result = "ceq" }
  }

  /** A `pop` instruction. */
  class Pop extends Instruction, @cil_pop {
    override string getOpcodeName() { result = "pop" }

    override int getPopCount() { result = 1 }
  }

  /** A `dup` instruction. */
  class Dup extends Expr, @cil_dup {
    override string getOpcodeName() { result = "dup" }

    override int getPopCount() { result = 1 }

    override int getPushCount() { result = 2 } // This is the only instruction that pushes 2 items

    override Type getType() { result = this.getOperandType(0) }
  }

  /** A `ret` instruction. */
  class Ret extends Return, @cil_ret {
    override string getOpcodeName() { result = "ret" }

    override predicate canFlowNext() { none() }

    override int getPopCount() {
      if this.getImplementation().getMethod().returnsVoid() then result = 0 else result = 1
    }
  }

  /** A `nop` instruction. */
  class Nop extends Instruction, @cil_nop {
    override string getOpcodeName() { result = "nop" }
  }

  /** An `ldstr` instruction. */
  class Ldstr extends StringLiteral, @cil_ldstr {
    override string getOpcodeName() { result = "ldstr" }

    override string getExtra() { result = "\"" + this.getValue() + "\"" }

    override Type getType() { result instanceof StringType }
  }

  /** A `br` instruction. */
  class Br extends UnconditionalBranch, @cil_br {
    override string getOpcodeName() { result = "br" }
  }

  /** A `br.s` instruction. */
  class Br_s extends UnconditionalBranch, @cil_br_s {
    override string getOpcodeName() { result = "br.s" }
  }

  /** A `brfalse.s` instruction. */
  class Brfalse_s extends UnaryBranch, @cil_brfalse_s {
    override string getOpcodeName() { result = "brfalse.s" }
  }

  /** A `brfalse` instruction. */
  class Brfalse extends UnaryBranch, @cil_brfalse {
    override string getOpcodeName() { result = "brfalse" }
  }

  /** A `brtrue.s` instruction. */
  class Brtrue_s extends UnaryBranch, @cil_brtrue_s {
    override string getOpcodeName() { result = "brtrue.s" }
  }

  /** A `brtrue` instruction. */
  class Brtrue extends UnaryBranch, @cil_brtrue {
    override string getOpcodeName() { result = "brtrue" }
  }

  /** A `blt.s` instruction. */
  class Blt_s extends BinaryBranch, @cil_blt_s {
    override string getOpcodeName() { result = "blt.s" }
  }

  /** A `blt` instruction. */
  class Blt extends BinaryBranch, @cil_blt {
    override string getOpcodeName() { result = "blt" }
  }

  /** A `blt.un.s` instruction. */
  class Blt_un_s extends BinaryBranch, @cil_blt_un_s {
    override string getOpcodeName() { result = "blt.un.s" }
  }

  /** A `blt.un` instruction. */
  class Blt_un extends BinaryBranch, @cil_blt_un {
    override string getOpcodeName() { result = "blt.un" }
  }

  /** A `bgt.un` instruction. */
  class Bgt_un extends BinaryBranch, @cil_bgt_un {
    override string getOpcodeName() { result = "bgt.un" }
  }

  /** A `ble.un.s` instruction. */
  class Ble_un_s extends BinaryBranch, @cil_ble_un_s {
    override string getOpcodeName() { result = "ble.un.s" }
  }

  /** A `ble.un` instruction. */
  class Ble_un extends BinaryBranch, @cil_ble_un {
    override string getOpcodeName() { result = "ble.un" }
  }

  /** A `bge.s` instruction. */
  class Bge_s extends BinaryBranch, @cil_bge_s {
    override string getOpcodeName() { result = "bge.s" }
  }

  /** A `ble.un` instruction. */
  class Bge_un extends BinaryBranch, @cil_bge_un {
    override string getOpcodeName() { result = "bge.un" }
  }

  /** A `bge` instruction. */
  class Bge extends BinaryBranch, @cil_bge {
    override string getOpcodeName() { result = "bge" }
  }

  /** A `bne.un.s` instruction. */
  class Bne_un_s extends BinaryBranch, @cil_bne_un_s {
    override string getOpcodeName() { result = "bne.un.s" }
  }

  /** A `bne.un` instruction. */
  class Bne_un extends BinaryBranch, @cil_bne_un {
    override string getOpcodeName() { result = "bne.un" }
  }

  /** A `beq` instruction. */
  class Beq extends BinaryBranch, @cil_beq {
    override string getOpcodeName() { result = "beq" }
  }

  /** A `beq.s` instruction. */
  class Beq_s extends BinaryBranch, @cil_beq_s {
    override string getOpcodeName() { result = "beq.s" }
  }

  /** A `ble.s` instruction. */
  class Ble_s extends BinaryBranch, @cil_ble_s {
    override string getOpcodeName() { result = "ble.s" }
  }

  /** A `ble` instruction. */
  class Ble extends BinaryBranch, @cil_ble {
    override string getOpcodeName() { result = "ble" }
  }

  /** A `bgt.s` instruction. */
  class Bgt_s extends BinaryBranch, @cil_bgt_s {
    override string getOpcodeName() { result = "bgt.s" }
  }

  /** A `bgt` instruction. */
  class Bgt extends BinaryBranch, @cil_bgt {
    override string getOpcodeName() { result = "bgt" }
  }

  /** A `bgt.in.s` instruction. */
  class Bgt_in_s extends BinaryBranch, @cil_bgt_un_s {
    override string getOpcodeName() { result = "bgt.in.s" }
  }

  /** A `bge.in.s` instruction. */
  class Bge_in_s extends BinaryBranch, @cil_bge_un_s {
    override string getOpcodeName() { result = "bge.un.s" }
  }

  /** A `switch` instruction. */
  class Switch extends ConditionalBranch, @cil_switch {
    override string getOpcodeName() { result = "switch" }

    /** Gets the `n`th jump target of this switch. */
    Instruction getTarget(int n) { cil_switch(this, n, result) }

    override Instruction getASuccessorType(FlowType t) {
      t instanceof NormalFlow and
      (
        result = this.getTarget(_) or
        result = this.getImplementation().getInstruction(this.getIndex() + 1)
      )
    }

    override string getExtra() {
      result = concat(int n | exists(this.getTarget(n)) | this.getTarget(n).getIndex() + ":", " ")
    }
  }

  /** A `leave` instruction. */
  class Leave_ extends Leave, @cil_leave {
    override string getOpcodeName() { result = "leave" }
  }

  /** A `leave.s` instruction. */
  class Leave_s extends Leave, @cil_leave_s {
    override string getOpcodeName() { result = "leave.s" }
  }

  /** An `endfilter` instruction. */
  class Endfilter extends Instruction, @cil_endfilter {
    override string getOpcodeName() { result = "endfilter" }
  }

  /** An `endfinally` instruction. */
  class Endfinally extends Instruction, @cil_endfinally {
    override string getOpcodeName() { result = "endfinally" }

    override predicate canFlowNext() { none() }
  }

  /** A `cgt.un` instruction. */
  class Cgt_un extends ComparisonOperation, @cil_cgt_un {
    override string getOpcodeName() { result = "cgt.un" }
  }

  /** A `cgt` instruction. */
  class Cgt extends ComparisonOperation, @cil_cgt {
    override string getOpcodeName() { result = "cgt" }
  }

  /** A `clt.un` instruction. */
  class Clt_un extends ComparisonOperation, @cil_clt_un {
    override string getOpcodeName() { result = "clt.un" }
  }

  /** A `clt` instruction. */
  class Clt extends ComparisonOperation, @cil_clt {
    override string getOpcodeName() { result = "clt" }
  }

  /** A `call` instruction. */
  class Call_ extends Call, @cil_call {
    override string getOpcodeName() { result = "call" }
  }

  /** A `calli` instruction. */
  class Calli extends Call, @cil_calli {
    override string getOpcodeName() { result = "calli" }

    override Callable getTarget() { none() }

    /** Gets the function pointer type targetted by this instruction. */
    FunctionPointerType getTargetType() { cil_access(this, result) }

    // The number of items popped/pushed from the stack depends on the target of
    // the call. Also, we need to pop the function pointer itself too.
    override int getPopCount() { result = this.getTargetType().getCallPopCount() + 1 }

    override int getPushCount() { result = this.getTargetType().getCallPushCount() }
  }

  /** A `callvirt` instruction. */
  class Callvirt extends Call, @cil_callvirt {
    override string getOpcodeName() { result = "callvirt" }

    override predicate isVirtual() { any() }
  }

  /** A `tail.` instruction. */
  class Tail extends Instruction, @cil_tail {
    override string getOpcodeName() { result = "tail." }
  }

  /** A `jmp` instruction. */
  class Jmp extends Call, @cil_jmp {
    override string getOpcodeName() { result = "jmp" }

    override predicate isTailCall() { any() }
  }

  /** An `isinst` instruction. */
  class Isinst extends UnaryExpr, @cil_isinst {
    override string getOpcodeName() { result = "isinst" }

    override BoolType getType() { exists(result) }

    /** Gets the type that is being tested against. */
    Type getTestedType() { result = this.getAccess() }

    override string getExtra() { result = this.getTestedType().getQualifiedName() }
  }

  /** A `castclass` instruction. */
  class Castclass extends UnaryExpr, @cil_castclass {
    override string getOpcodeName() { result = "castclass" }

    override Type getType() { result = this.getAccess() }

    /** Gets the type that is being cast to. */
    Type getTestedType() { result = this.getAccess() }

    override string getExtra() { result = this.getTestedType().getQualifiedName() }
  }

  /** An `stloc.0` instruction. */
  class Stloc_0 extends LocalVariableWriteAccess, @cil_stloc_0 {
    override string getOpcodeName() { result = "stloc.0" }

    override LocalVariable getTarget() { result = this.getImplementation().getLocalVariable(0) }
  }

  /** An `stloc.1` instruction. */
  class Stloc_1 extends LocalVariableWriteAccess, @cil_stloc_1 {
    override string getOpcodeName() { result = "stloc.1" }

    override LocalVariable getTarget() { result = this.getImplementation().getLocalVariable(1) }
  }

  /** An `stloc.2` instruction. */
  class Stloc_2 extends LocalVariableWriteAccess, @cil_stloc_2 {
    override string getOpcodeName() { result = "stloc.2" }

    override LocalVariable getTarget() { result = this.getImplementation().getLocalVariable(2) }
  }

  /** An `stloc.3` instruction. */
  class Stloc_3 extends LocalVariableWriteAccess, @cil_stloc_3 {
    override string getOpcodeName() { result = "stloc.3" }

    override LocalVariable getTarget() { result = this.getImplementation().getLocalVariable(3) }
  }

  /** An `stloc.s` instruction. */
  class Stloc_s extends LocalVariableWriteAccess, @cil_stloc_s {
    override string getOpcodeName() { result = "stloc.s" }

    override LocalVariable getTarget() { cil_access(this, result) }
  }

  /** An `stloc` instruction. */
  class Stloc extends LocalVariableWriteAccess, @cil_stloc {
    override string getOpcodeName() { result = "stloc" }

    override LocalVariable getTarget() { cil_access(this, result) }
  }

  /** An `ldloc.0` instruction. */
  class Ldloc_0 extends LocalVariableReadAccess, @cil_ldloc_0 {
    override string getOpcodeName() { result = "ldloc.0" }

    override LocalVariable getTarget() { result = this.getImplementation().getLocalVariable(0) }
  }

  /** An `ldloc.1` instruction. */
  class Ldloc_1 extends LocalVariableReadAccess, @cil_ldloc_1 {
    override string getOpcodeName() { result = "ldloc.1" }

    override LocalVariable getTarget() { result = this.getImplementation().getLocalVariable(1) }
  }

  /** An `ldloc.2` instruction. */
  class Ldloc_2 extends LocalVariableReadAccess, @cil_ldloc_2 {
    override string getOpcodeName() { result = "ldloc.2" }

    override LocalVariable getTarget() { result = this.getImplementation().getLocalVariable(2) }
  }

  /** An `ldloc.3` instruction. */
  class Ldloc_3 extends LocalVariableReadAccess, @cil_ldloc_3 {
    override string getOpcodeName() { result = "ldloc.3" }

    override LocalVariable getTarget() { result = this.getImplementation().getLocalVariable(3) }
  }

  /** An `ldloc.s` instruction. */
  class Ldloc_s extends LocalVariableReadAccess, @cil_ldloc_s {
    override string getOpcodeName() { result = "ldloc.s" }

    override LocalVariable getTarget() { cil_access(this, result) }

    override string getExtra() { result = "L" + this.getTarget().getIndex() }
  }

  /** An `ldloca.s` instruction. */
  class Ldloca_s extends LocalVariableReadAccess, ReadRefAccess, @cil_ldloca_s {
    override string getOpcodeName() { result = "ldloca.s" }

    override LocalVariable getTarget() { cil_access(this, result) }

    override string getExtra() { result = "L" + this.getTarget().getIndex() }
  }

  /** An `ldloc` instruction. */
  class Ldloc extends LocalVariableReadAccess, @cil_ldloc {
    override string getOpcodeName() { result = "ldloc" }

    override LocalVariable getTarget() { cil_access(this, result) }

    override string getExtra() { result = "L" + this.getTarget().getIndex() }
  }

  /** An `ldarg.0` instruction. */
  class Ldarg_0 extends ParameterReadAccess, @cil_ldarg_0 {
    override string getOpcodeName() { result = "ldarg.0" }

    override MethodParameter getTarget() {
      result = this.getImplementation().getMethod().getRawParameter(0)
    }
  }

  /** An `ldarg.1` instruction. */
  class Ldarg_1 extends ParameterReadAccess, @cil_ldarg_1 {
    override string getOpcodeName() { result = "ldarg.1" }

    override MethodParameter getTarget() {
      result = this.getImplementation().getMethod().getRawParameter(1)
    }
  }

  /** An `ldarg.2` instruction. */
  class Ldarg_2 extends ParameterReadAccess, @cil_ldarg_2 {
    override string getOpcodeName() { result = "ldarg.2" }

    override MethodParameter getTarget() {
      result = this.getImplementation().getMethod().getRawParameter(2)
    }
  }

  /** An `ldarg.3` instruction. */
  class Ldarg_3 extends ParameterReadAccess, @cil_ldarg_3 {
    override string getOpcodeName() { result = "ldarg.3" }

    override MethodParameter getTarget() {
      result = this.getImplementation().getMethod().getRawParameter(3)
    }
  }

  /** An `ldarg.s` instruction. */
  class Ldarg_s extends ParameterReadAccess, @cil_ldarg_s {
    override string getOpcodeName() { result = "ldarg.s" }

    override MethodParameter getTarget() { cil_access(this, result) }

    override string getExtra() { result = this.getTarget().getIndex().toString() }
  }

  /** An `ldarg` instruction. */
  class Ldarg extends ParameterReadAccess, @cil_ldarg {
    override string getOpcodeName() { result = "ldarg" }

    override MethodParameter getTarget() { cil_access(this, result) }
  }

  /** An `ldarga.s` instruction. */
  class Ldarga_s extends ParameterReadAccess, ReadRefAccess, @cil_ldarga_s {
    override string getOpcodeName() { result = "ldarga.s" }

    override MethodParameter getTarget() { cil_access(this, result) }
  }

  /** An `starg.s` instruction. */
  class Starg_s extends ParameterWriteAccess, @cil_starg_s {
    override string getOpcodeName() { result = "starg.s" }

    override MethodParameter getTarget() { cil_access(this, result) }
  }

  /** An `ldfld` instruction. */
  class Ldfld extends FieldReadAccess, @cil_ldfld {
    override string getOpcodeName() { result = "ldfld" }

    override int getPopCount() { result = 1 }

    override Expr getQualifier() { result = this.getOperand(0) }
  }

  /** An `ldflda` instruction. */
  class Ldflda extends FieldReadAccess, ReadRefAccess, @cil_ldflda {
    override string getOpcodeName() { result = "ldflda" }

    override int getPopCount() { result = 1 }

    override Expr getQualifier() { result = this.getOperand(0) }
  }

  /** An `ldsfld` instruction. */
  class Ldsfld extends FieldReadAccess, @cil_ldsfld {
    override string getOpcodeName() { result = "ldsfld" }

    override int getPopCount() { result = 0 }

    override Expr getQualifier() { none() }
  }

  /** An `ldsflda` instruction. */
  class Ldsflda extends FieldReadAccess, ReadRefAccess, @cil_ldsflda {
    override string getOpcodeName() { result = "ldsflda" }

    override int getPopCount() { result = 0 }

    override Expr getQualifier() { none() }
  }

  /** An `stfld` instruction. */
  class Stfld extends FieldWriteAccess, @cil_stfld {
    override string getOpcodeName() { result = "stfld" }

    override int getPopCount() { result = 2 }

    override Expr getQualifier() { result = this.getOperand(1) }

    override Expr getExpr() { result = this.getOperand(0) }
  }

  /** An `stsfld` instruction. */
  class Stsfld extends FieldWriteAccess, @cil_stsfld {
    override string getOpcodeName() { result = "stsfld" }

    override int getPopCount() { result = 1 }

    override Expr getQualifier() { none() }

    override Expr getExpr() { result = this.getOperand(0) }
  }

  /** A `newobj` instruction. */
  class Newobj extends Call, @cil_newobj {
    override string getOpcodeName() { result = "newobj" }

    override int getPushCount() { result = 1 }

    override int getPopCount() { result = count(this.getARawTargetParameter()) - 1 }

    override Type getType() { result = this.getTarget().getDeclaringType() }

    override Expr getArgument(int i) { result = this.getRawArgument(i) }

    pragma[noinline]
    private Parameter getARawTargetParameter() { result = this.getTarget().getARawParameter() }

    override Expr getArgumentForParameter(DotNet::Parameter param) {
      exists(int index |
        result = this.getArgument(index) and
        param = this.getTarget().getParameter(index)
      )
    }
  }

  /** An `initobj` instruction. */
  class Initobj extends Instruction, @cil_initobj {
    override string getOpcodeName() { result = "initobj" }

    override int getPopCount() { result = 1 } // ??
  }

  /** A `box` instruction. */
  class Box extends UnaryExpr, @cil_box {
    override string getOpcodeName() { result = "box" }

    override Type getType() { result = this.getAccess() }
  }

  /** An `unbox.any` instruction. */
  class Unbox_any extends UnaryExpr, @cil_unbox_any {
    override string getOpcodeName() { result = "unbox.any" }

    override Type getType() { result = this.getAccess() }
  }

  /** An `unbox` instruction. */
  class Unbox extends UnaryExpr, @cil_unbox {
    override string getOpcodeName() { result = "unbox" }

    override Type getType() { result = this.getAccess() }
  }

  /** An `ldobj` instruction. */
  class Ldobj extends UnaryExpr, @cil_ldobj {
    override string getOpcodeName() { result = "ldobj" }

    /** Gets the type of the object. */
    Type getTarget() { cil_access(this, result) }

    override Type getType() { result = this.getAccess() }
  }

  /** An `ldtoken` instruction. */
  class Ldtoken extends Expr, @cil_ldtoken {
    override string getOpcodeName() { result = "ldtoken" }

    // Not really sure what a type of a token is so use `object`.
    override ObjectType getType() { exists(result) }
  }

  /** A `constrained.` instruction. */
  class Constrained extends Instruction, @cil_constrained {
    override string getOpcodeName() { result = "constrained." }
  }

  /** A `throw` instruction. */
  class Throw_ extends Throw, @cil_throw {
    override string getOpcodeName() { result = "throw" }

    override int getPopCount() { result = 1 }
  }

  /** A `rethrow` instruction. */
  class Rethrow extends Throw, @cil_rethrow {
    override string getOpcodeName() { result = "rethrow" }
  }

  /** A `ldlen` instruction. */
  class Ldlen extends UnaryExpr, @cil_ldlen {
    override string getOpcodeName() { result = "ldlen" }

    override IntType getType() { exists(result) }
  }

  /** A `newarr` instruction. */
  class Newarr extends Expr, @cil_newarr {
    override string getOpcodeName() { result = "newarr" }

    override int getPushCount() { result = 1 }

    override int getPopCount() { result = 1 }

    override Type getType() {
      // Note that this is technically wrong - it should be
      // result.(ArrayType).getElementType() = getAccess()
      // However the (ArrayType) may not be in the database.
      result = this.getAccess()
    }

    override string getExtra() { result = this.getType().getQualifiedName() }
  }

  /** An `ldelem` instruction. */
  class Ldelem extends ReadArrayElement, @cil_ldelem {
    override string getOpcodeName() { result = "ldelem" }

    override Type getType() { result = this.getAccess() }
  }

  /** An `ldelem.ref` instruction. */
  class Ldelem_ref extends ReadArrayElement, @cil_ldelem_ref {
    override string getOpcodeName() { result = "ldelem.ref" }

    override Type getType() { result = this.getOperandType(1) }
  }

  /** An `ldelema` instruction. */
  class Ldelema extends ReadArrayElement, ReadRef, @cil_ldelema {
    override string getOpcodeName() { result = "ldelema" }

    override Type getType() { result = this.getAccess() }
  }

  /** An `stelem.ref` instruction. */
  class Stelem_ref extends WriteArrayElement, @cil_stelem_ref {
    override string getOpcodeName() { result = "stelem.ref" }
  }

  /** An `stelem` instruction. */
  class Stelem extends WriteArrayElement, @cil_stelem {
    override string getOpcodeName() { result = "stelem" }
  }

  /** An `stelem.i` instruction. */
  class Stelem_i extends WriteArrayElement, @cil_stelem_i {
    override string getOpcodeName() { result = "stelem.i" }
  }

  /** An `stelem.i1` instruction. */
  class Stelem_i1 extends WriteArrayElement, @cil_stelem_i1 {
    override string getOpcodeName() { result = "stelem.i1" }
  }

  /** An `stelem.i2` instruction. */
  class Stelem_i2 extends WriteArrayElement, @cil_stelem_i2 {
    override string getOpcodeName() { result = "stelem.i2" }
  }

  /** An `stelem.i4` instruction. */
  class Stelem_i4 extends WriteArrayElement, @cil_stelem_i4 {
    override string getOpcodeName() { result = "stelem.i4" }
  }

  /** An `stelem.i8` instruction. */
  class Stelem_i8 extends WriteArrayElement, @cil_stelem_i8 {
    override string getOpcodeName() { result = "stelem.i8" }
  }

  /** An `stelem.r4` instruction. */
  class Stelem_r4 extends WriteArrayElement, @cil_stelem_r4 {
    override string getOpcodeName() { result = "stelem.r4" }
  }

  /** An `stelem.r8` instruction. */
  class Stelem_r8 extends WriteArrayElement, @cil_stelem_r8 {
    override string getOpcodeName() { result = "stelem.r8" }
  }

  /** An `ldelem.i` instruction. */
  class Ldelem_i extends ReadArrayElement, @cil_ldelem_i {
    override string getOpcodeName() { result = "ldelem.i" }

    override IntType getType() { exists(result) }
  }

  /** An `ldelem.i1` instruction. */
  class Ldelem_i1 extends ReadArrayElement, @cil_ldelem_i1 {
    override string getOpcodeName() { result = "ldelem.i1" }

    override SByteType getType() { exists(result) }
  }

  /** An `ldelem.i2` instruction. */
  class Ldelem_i2 extends ReadArrayElement, @cil_ldelem_i2 {
    override string getOpcodeName() { result = "ldelem.i2" }

    override ShortType getType() { exists(result) }
  }

  /** An `ldelem.i4` instruction. */
  class Ldelem_i4 extends ReadArrayElement, @cil_ldelem_i4 {
    override string getOpcodeName() { result = "ldelem.i4" }

    override IntType getType() { exists(result) }
  }

  /** An `ldelem.i8` instruction. */
  class Ldelem_i8 extends ReadArrayElement, @cil_ldelem_i8 {
    override string getOpcodeName() { result = "ldelem.i8" }

    override LongType getType() { exists(result) }
  }

  /** An `ldelem.r4` instruction. */
  class Ldelem_r4 extends ReadArrayElement, @cil_ldelem_r4 {
    override string getOpcodeName() { result = "ldelem.r4" }

    override FloatType getType() { exists(result) }
  }

  /** An `ldelem.r8` instruction. */
  class Ldelem_r8 extends ReadArrayElement, @cil_ldelem_r8 {
    override string getOpcodeName() { result = "ldelem.r8" }

    override DoubleType getType() { exists(result) }
  }

  /** An `ldelem.u1` instruction. */
  class Ldelem_u1 extends ReadArrayElement, @cil_ldelem_u1 {
    override string getOpcodeName() { result = "ldelem.u1" }

    override ByteType getType() { exists(result) }
  }

  /** An `ldelem.u2` instruction. */
  class Ldelem_u2 extends ReadArrayElement, @cil_ldelem_u2 {
    override string getOpcodeName() { result = "ldelem.u2" }

    override UShortType getType() { exists(result) }
  }

  /** An `ldelem.u4` instruction. */
  class Ldelem_u4 extends ReadArrayElement, @cil_ldelem_u4 {
    override string getOpcodeName() { result = "ldelem.u4" }

    override UIntType getType() { exists(result) }
  }

  /** A `conv.i` instruction. */
  class Conv_i extends Conversion, @cil_conv_i {
    override string getOpcodeName() { result = "conv.i" }

    override IntType getType() { exists(result) }
  }

  /** A `conv.ovf.i` instruction. */
  class Conv_ovf_i extends Conversion, @cil_conv_ovf_i {
    override string getOpcodeName() { result = "conv.ovf.i" }

    override IntType getType() { exists(result) }
  }

  /** A `conv.ovf.i.un` instruction. */
  class Conv_ovf_i_un extends Conversion, @cil_conv_ovf_i_un {
    override string getOpcodeName() { result = "conv.ovf.i.un" }

    override UIntType getType() { exists(result) }
  }

  /** A `conv.i1` instruction. */
  class Conv_i1 extends Conversion, @cil_conv_i1 {
    override string getOpcodeName() { result = "conv.i1" }

    override SByteType getType() { exists(result) }
  }

  /** A `conv.ovf.i1` instruction. */
  class Conv_ovf_i1 extends Conversion, @cil_conv_ovf_i1 {
    override string getOpcodeName() { result = "conv.ovf.i1" }

    override SByteType getType() { exists(result) }
  }

  /** A `conv.ovf.i1.un` instruction. */
  class Conv_ovf_i1_un extends Conversion, @cil_conv_ovf_i1_un {
    override string getOpcodeName() { result = "conv.ovf.i1.un" }

    override SByteType getType() { exists(result) }
  }

  /** A `conv.i2` instruction. */
  class Conv_i2 extends Conversion, @cil_conv_i2 {
    override string getOpcodeName() { result = "conv.i2" }

    override ShortType getType() { exists(result) }
  }

  /** A `conv.ovf.i2` instruction. */
  class Conv_ovf_i2 extends Conversion, @cil_conv_ovf_i2 {
    override string getOpcodeName() { result = "conv.ovf.i2" }

    override ShortType getType() { exists(result) }
  }

  /** A `conv.ovf.i2.un` instruction. */
  class Conv_ovf_i2_un extends Conversion, @cil_conv_ovf_i2_un {
    override string getOpcodeName() { result = "conv.ovf.i2.un" }

    override ShortType getType() { exists(result) }
  }

  /** A `conv.i4` instruction. */
  class Conv_i4 extends Conversion, @cil_conv_i4 {
    override string getOpcodeName() { result = "conv.i4" }

    override IntType getType() { exists(result) }
  }

  /** A `conv.ovf.i4` instruction. */
  class Conv_ovf_i4 extends Conversion, @cil_conv_ovf_i4 {
    override string getOpcodeName() { result = "conv.ovf.i4" }

    override IntType getType() { exists(result) }
  }

  /** A `conv.ovf.i4.un` instruction. */
  class Conv_ovf_i4_un extends Conversion, @cil_conv_ovf_i4_un {
    override string getOpcodeName() { result = "conv.ovf.i4.un" }

    override IntType getType() { exists(result) }
  }

  /** A `conv.i8` instruction. */
  class Conv_i8 extends Conversion, @cil_conv_i8 {
    override string getOpcodeName() { result = "conv.i8" }

    override LongType getType() { exists(result) }
  }

  /** A `conv.ovf.i8` instruction. */
  class Conv_ovf_i8 extends Conversion, @cil_conv_ovf_i8 {
    override string getOpcodeName() { result = "conv.ovf.i8" }

    override LongType getType() { exists(result) }
  }

  /** A `conv.ovf.i8.un` instruction. */
  class Conv_ovf_i8_un extends Conversion, @cil_conv_ovf_i8_un {
    override string getOpcodeName() { result = "conv.ovf.i8.un" }

    override LongType getType() { exists(result) }
  }

  /** A `conv.u` instruction. */
  class Conv_u extends Conversion, @cil_conv_u {
    override string getOpcodeName() { result = "conv.u" }

    override UIntType getType() { exists(result) }
  }

  /** A `conv.ovf.u` instruction. */
  class Conv_ovf_u extends Conversion, @cil_conv_ovf_u {
    override string getOpcodeName() { result = "conv.ovf.u" }

    override UIntType getType() { exists(result) }
  }

  /** A `conv.ovf.u.un` instruction. */
  class Conv_ovf_u_un extends Conversion, @cil_conv_ovf_u_un {
    override string getOpcodeName() { result = "conv.ovf.u.un" }

    override UIntType getType() { exists(result) }
  }

  /** A `conv.u1` instruction. */
  class Conv_u1 extends Conversion, @cil_conv_u1 {
    override string getOpcodeName() { result = "conv.u1" }

    override ByteType getType() { exists(result) }
  }

  /** A `conv.ovf.u1` instruction. */
  class Conv_ovf_u1 extends Conversion, @cil_conv_ovf_u1 {
    override string getOpcodeName() { result = "conv.ovf.u1" }

    override ByteType getType() { exists(result) }
  }

  /** A `conv.ovf.u1.un` instruction. */
  class Conv_ovf_u1_un extends Conversion, @cil_conv_ovf_u1_un {
    override string getOpcodeName() { result = "conv.ovf.u1.un" }

    override ByteType getType() { exists(result) }
  }

  /** A `conv.u2` instruction. */
  class Conv_u2 extends Conversion, @cil_conv_u2 {
    override string getOpcodeName() { result = "conv.u2" }

    override UShortType getType() { exists(result) }
  }

  /** A `conv.ovf.u2` instruction. */
  class Conv_ovf_u2 extends Conversion, @cil_conv_ovf_u2 {
    override string getOpcodeName() { result = "conv.ovf.u2" }

    override UShortType getType() { exists(result) }
  }

  /** A `conv.ovf.u2.un` instruction. */
  class Conv_ovf_u2_un extends Conversion, @cil_conv_ovf_u2_un {
    override string getOpcodeName() { result = "conv.ovf.u2.un" }

    override UShortType getType() { exists(result) }
  }

  /** A `conv.u4` instruction. */
  class Conv_u4 extends Conversion, @cil_conv_u4 {
    override string getOpcodeName() { result = "conv.u4" }

    override UIntType getType() { exists(result) }
  }

  /** A `conv.ovf.u4` instruction. */
  class Conv_ovf_u4 extends Conversion, @cil_conv_ovf_u4 {
    override string getOpcodeName() { result = "conv.ovf.u4" }

    override UIntType getType() { exists(result) }
  }

  /** A `conv.ovf.u4.un` instruction. */
  class Conv_ovf_u4_un extends Conversion, @cil_conv_ovf_u4_un {
    override string getOpcodeName() { result = "conv.ovf.u4.un" }

    override UIntType getType() { exists(result) }
  }

  /** A `conv.u8` instruction. */
  class Conv_u8 extends Conversion, @cil_conv_u8 {
    override string getOpcodeName() { result = "conv.u8" }

    override ULongType getType() { exists(result) }
  }

  /** A `conv.ovf.u8` instruction. */
  class Conv_ovf_u8 extends Conversion, @cil_conv_ovf_u8 {
    override string getOpcodeName() { result = "conv.ovf.u8" }

    override ULongType getType() { exists(result) }
  }

  /** A `conv.ovf.u8.un` instruction. */
  class Conv_ovf_u8_un extends Conversion, @cil_conv_ovf_u8_un {
    override string getOpcodeName() { result = "conv.ovf.u8.un" }

    override ULongType getType() { exists(result) }
  }

  /** A `conv.r4` instruction. */
  class Conv_r4 extends Conversion, @cil_conv_r4 {
    override string getOpcodeName() { result = "conv.r4" }

    override FloatType getType() { exists(result) }
  }

  /** A `conv.r8` instruction. */
  class Conv_r8 extends Conversion, @cil_conv_r8 {
    override string getOpcodeName() { result = "conv.r8" }

    override DoubleType getType() { exists(result) }
  }

  /** A `conv.r.un` instruction. */
  class Conv_r_un extends Conversion, @cil_conv_r_un {
    override string getOpcodeName() { result = "conv.r.un" }

    override DoubleType getType() { exists(result) } // ??
  }

  /** A `volatile.` instruction. */
  class Volatile extends Instruction, @cil_volatile {
    override string getOpcodeName() { result = "volatile." }
  }

  /** An `ldind.i` instruction. */
  class Ldind_i extends LoadIndirect, @cil_ldind_i {
    override string getOpcodeName() { result = "ldind.i" }

    override IntType getType() { exists(result) }
  }

  /** An `ldind.i1` instruction. */
  class Ldind_i1 extends LoadIndirect, @cil_ldind_i1 {
    override string getOpcodeName() { result = "ldind.i1" }

    override SByteType getType() { exists(result) }
  }

  /** An `ldind.i2` instruction. */
  class Ldind_i2 extends LoadIndirect, @cil_ldind_i2 {
    override string getOpcodeName() { result = "ldind.i2" }

    override ShortType getType() { exists(result) }
  }

  /** An `ldind.i4` instruction. */
  class Ldind_i4 extends LoadIndirect, @cil_ldind_i4 {
    override string getOpcodeName() { result = "ldind.i4" }

    override IntType getType() { exists(result) }
  }

  /** An `ldind.i8` instruction. */
  class Ldind_i8 extends LoadIndirect, @cil_ldind_i8 {
    override string getOpcodeName() { result = "ldind.i8" }

    override LongType getType() { exists(result) }
  }

  /** An `ldind.r4` instruction. */
  class Ldind_r4 extends LoadIndirect, @cil_ldind_r4 {
    override string getOpcodeName() { result = "ldind.r4" }

    override FloatType getType() { exists(result) }
  }

  /** An `ldind.r8` instruction. */
  class Ldind_r8 extends LoadIndirect, @cil_ldind_r8 {
    override string getOpcodeName() { result = "ldind.r8" }

    override DoubleType getType() { exists(result) }
  }

  /** An `ldind.ref` instruction. */
  class Ldind_ref extends LoadIndirect, @cil_ldind_ref {
    override string getOpcodeName() { result = "ldind.ref" }

    override ObjectType getType() { exists(result) }
  }

  /** An `ldind.u1` instruction. */
  class Ldind_u1 extends LoadIndirect, @cil_ldind_u1 {
    override string getOpcodeName() { result = "ldind.u1" }

    override ByteType getType() { exists(result) }
  }

  /** An `ldind.u2` instruction. */
  class Ldind_u2 extends LoadIndirect, @cil_ldind_u2 {
    override string getOpcodeName() { result = "ldind.u2" }

    override UShortType getType() { exists(result) }
  }

  /** An `ldind.u4` instruction. */
  class Ldind_u4 extends LoadIndirect, @cil_ldind_u4 {
    override string getOpcodeName() { result = "ldind.u4" }

    override UIntType getType() { exists(result) }
  }

  /** An `stind.i` instruction. */
  class Stind_i extends StoreIndirect, @cil_stind_i {
    override string getOpcodeName() { result = "stind.i" }
  }

  /** An `stind.i1` instruction. */
  class Stind_i1 extends StoreIndirect, @cil_stind_i1 {
    override string getOpcodeName() { result = "stind.i1" }
  }

  /** An `stind.i2` instruction. */
  class Stind_i2 extends StoreIndirect, @cil_stind_i2 {
    override string getOpcodeName() { result = "stind.i2" }
  }

  /** An `stind.i4` instruction. */
  class Stind_i4 extends StoreIndirect, @cil_stind_i4 {
    override string getOpcodeName() { result = "stind.i4" }
  }

  /** An `stind.i8` instruction. */
  class Stind_i8 extends StoreIndirect, @cil_stind_i8 {
    override string getOpcodeName() { result = "stind.i8" }
  }

  /** An `stind.r4` instruction. */
  class Stind_r4 extends StoreIndirect, @cil_stind_r4 {
    override string getOpcodeName() { result = "stind.r4" }
  }

  /** An `stind.r8` instruction. */
  class Stind_r8 extends StoreIndirect, @cil_stind_r8 {
    override string getOpcodeName() { result = "stind.r8" }
  }

  /** An `stind.ref` instruction. */
  class Stind_ref extends StoreIndirect, @cil_stind_ref {
    override string getOpcodeName() { result = "stind.ref" }
  }

  /** An `stobj` instruction. */
  class Stobj extends Instruction, @cil_stobj {
    override string getOpcodeName() { result = "stobj" }

    override int getPopCount() { result = 2 }
  }

  /** An `ldftn` instruction. */
  class Ldftn extends Expr, @cil_ldftn {
    override string getOpcodeName() { result = "ldftn" }

    override int getPopCount() { result = 0 }
  }

  /** An `ldvirtftn` instruction. */
  class Ldvirtftn extends Expr, @cil_ldvirtftn {
    override string getOpcodeName() { result = "ldvirtftn" }

    override int getPopCount() { result = 1 }
  }

  /** A `sizeof` instruction. */
  class Sizeof extends Expr, @cil_sizeof {
    override string getOpcodeName() { result = "sizeof" }

    override IntType getType() { exists(result) }
  }

  /** A `localloc` instruction. */
  class Localloc extends Expr, @cil_localloc {
    override string getOpcodeName() { result = "localloc" }

    override int getPopCount() { result = 1 }

    override PointerType getType() { result.getReferentType() instanceof ByteType }
  }

  /** A `readonly.` instruction. */
  class Readonly extends Instruction, @cil_readonly {
    override string getOpcodeName() { result = "readonly." }
  }

  /** A `mkrefany` instruction. */
  class Mkrefany extends Expr, @cil_mkrefany {
    override string getOpcodeName() { result = "mkrefany" }

    override int getPopCount() { result = 1 }

    override Type getType() { result = this.getAccess() }
  }

  /** A `refanytype` instruction. */
  class Refanytype extends Expr, @cil_refanytype {
    override string getOpcodeName() { result = "refanytype" }

    override int getPopCount() { result = 1 }

    override SystemType getType() { exists(result) }
  }

  /** An `arglist` instruction. */
  class Arglist extends Expr, @cil_arglist {
    override string getOpcodeName() { result = "arglist" }
  }
}
