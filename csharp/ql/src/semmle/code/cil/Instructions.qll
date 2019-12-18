/**
 * Provides classes representing individual opcodes.
 */

private import CIL
private import semmle.code.dotnet.Variable as DotNet

module Opcodes {
  // Literals
  class Ldc_i4_m1 extends IntLiteral, @cil_ldc_i4_m1 {
    override string getOpcodeName() { result = "ldc.i4.m1" }

    override string getValue() { result = "-1" }
  }

  class Ldc_i4_0 extends IntLiteral, @cil_ldc_i4_0 {
    override string getOpcodeName() { result = "ldc.i4.0" }

    override string getValue() { result = "0" }
  }

  class Ldc_i4_1 extends IntLiteral, @cil_ldc_i4_1 {
    override string getOpcodeName() { result = "ldc.i4.1" }

    override string getValue() { result = "1" }
  }

  class Ldc_i4_2 extends IntLiteral, @cil_ldc_i4_2 {
    override string getOpcodeName() { result = "ldc.i4.2" }

    override string getValue() { result = "2" }
  }

  class Ldc_i4_3 extends IntLiteral, @cil_ldc_i4_3 {
    override string getOpcodeName() { result = "ldc.i4.3" }

    override string getValue() { result = "3" }
  }

  class Ldc_i4_4 extends IntLiteral, @cil_ldc_i4_4 {
    override string getOpcodeName() { result = "ldc.i4.4" }

    override string getValue() { result = "4" }
  }

  class Ldc_i4_5 extends IntLiteral, @cil_ldc_i4_5 {
    override string getOpcodeName() { result = "ldc.i4.5" }

    override string getValue() { result = "5" }
  }

  class Ldc_i4_6 extends IntLiteral, @cil_ldc_i4_6 {
    override string getOpcodeName() { result = "ldc.i4.6" }

    override string getValue() { result = "6" }
  }

  class Ldc_i4_7 extends IntLiteral, @cil_ldc_i4_7 {
    override string getOpcodeName() { result = "ldc.i4.7" }

    override string getValue() { result = "7" }
  }

  class Ldc_i4_8 extends IntLiteral, @cil_ldc_i4_8 {
    override string getOpcodeName() { result = "ldc.i4.8" }

    override string getValue() { result = "8" }
  }

  class Ldc_i4 extends IntLiteral, @cil_ldc_i4 {
    override string getOpcodeName() { result = "ldc.i4" }

    override string getExtra() { result = getValue() }
  }

  class Ldc_i8 extends IntLiteral, @cil_ldc_i8 {
    override string getOpcodeName() { result = "ldc.i8" }

    override string getExtra() { result = getValue() }
  }

  class Ldc_i4_s extends IntLiteral, @cil_ldc_i4_s {
    override string getOpcodeName() { result = "ldc.i4.s" }

    override string getExtra() { result = getValue() }
  }

  class Ldnull extends Literal, @cil_ldnull {
    override string getOpcodeName() { result = "ldnull" }

    override string getValue() { result = "null" }

    override string getExtra() { none() }

    override Type getType() { result instanceof ObjectType }
  }

  class Ldc_r4 extends FloatLiteral, @cil_ldc_r4 {
    override string getOpcodeName() { result = "ldc.r4" }

    override string getExtra() { result = getValue() }

    override Type getType() { result instanceof FloatType }
  }

  class Ldc_r8 extends FloatLiteral, @cil_ldc_r8 {
    override string getOpcodeName() { result = "ldc.r8" }

    override string getExtra() { result = getValue() }

    override Type getType() { result instanceof DoubleType }
  }

  // Arithmetic operations
  class Add extends BinaryArithmeticExpr, @cil_add {
    override string getOpcodeName() { result = "add" }
  }

  class Add_ovf extends BinaryArithmeticExpr, @cil_add_ovf {
    override string getOpcodeName() { result = "add.ovf" }
  }

  class Add_ovf_un extends BinaryArithmeticExpr, @cil_add_ovf_un {
    override string getOpcodeName() { result = "add.ovf.un" }
  }

  class Sub extends BinaryArithmeticExpr, @cil_sub {
    override string getOpcodeName() { result = "sub" }
  }

  class Sub_ovf extends BinaryArithmeticExpr, @cil_sub_ovf {
    override string getOpcodeName() { result = "sub.ovf" }
  }

  class Sub_ovf_un extends BinaryArithmeticExpr, @cil_sub_ovf_un {
    override string getOpcodeName() { result = "sub.ovf.un" }
  }

  class Mul extends BinaryArithmeticExpr, @cil_mul {
    override string getOpcodeName() { result = "mul" }
  }

  class Mul_ovf extends BinaryArithmeticExpr, @cil_mul_ovf {
    override string getOpcodeName() { result = "mul.ovf" }
  }

  class Mul_ovf_un extends BinaryArithmeticExpr, @cil_mul_ovf_un {
    override string getOpcodeName() { result = "mul.ovf.un" }
  }

  class Div extends BinaryArithmeticExpr, @cil_div {
    override string getOpcodeName() { result = "div" }
  }

  class Div_un extends BinaryArithmeticExpr, @cil_div_un {
    override string getOpcodeName() { result = "div.un" }
  }

  class Rem extends BinaryArithmeticExpr, @cil_rem {
    override string getOpcodeName() { result = "rem" }
  }

  class Rem_un extends BinaryArithmeticExpr, @cil_rem_un {
    override string getOpcodeName() { result = "rem.un" }
  }

  class Neg extends UnaryExpr, @cil_neg {
    override string getOpcodeName() { result = "neg" }

    override NumericType getType() {
      result = getOperand().getType()
      or
      getOperand().getType() instanceof Enum and result instanceof IntType
    }
  }

  // Binary operations
  class And extends BinaryBitwiseOperation, @cil_and {
    override string getOpcodeName() { result = "and" }
  }

  class Or extends BinaryBitwiseOperation, @cil_or {
    override string getOpcodeName() { result = "or" }
  }

  class Xor extends BinaryBitwiseOperation, @cil_xor {
    override string getOpcodeName() { result = "xor" }
  }

  class Not extends UnaryBitwiseOperation, @cil_not {
    override string getOpcodeName() { result = "not" }
  }

  class Shl extends BinaryBitwiseOperation, @cil_shl {
    override string getOpcodeName() { result = "shl" }
  }

  class Shr extends BinaryBitwiseOperation, @cil_shr {
    override string getOpcodeName() { result = "shr" }
  }

  class Shr_un extends BinaryBitwiseOperation, @cil_shr_un {
    override string getOpcodeName() { result = "shr.un" }
  }

  // Binary comparison operations
  class Ceq extends ComparisonOperation, @cil_ceq {
    override string getOpcodeName() { result = "ceq" }
  }

  class Pop extends Instruction, @cil_pop {
    override string getOpcodeName() { result = "pop" }

    override int getPopCount() { result = 1 }
  }

  class Dup extends Expr, @cil_dup {
    override string getOpcodeName() { result = "dup" }

    override int getPopCount() { result = 1 }

    override int getPushCount() { result = 2 } // This is the only instruction that pushes 2 items

    override Type getType() { result = getOperand(0).getType() }
  }

  class Ret extends Return, @cil_ret {
    override string getOpcodeName() { result = "ret" }

    override predicate canFlowNext() { none() }

    override int getPopCount() {
      if getImplementation().getMethod().returnsVoid() then result = 0 else result = 1
    }
  }

  class Nop extends Instruction, @cil_nop {
    override string getOpcodeName() { result = "nop" }
  }

  class Ldstr extends StringLiteral, @cil_ldstr {
    override string getOpcodeName() { result = "ldstr" }

    override string getExtra() { result = "\"" + getValue() + "\"" }

    override Type getType() { result instanceof StringType }
  }

  // Control flow
  class Br extends UnconditionalBranch, @cil_br {
    override string getOpcodeName() { result = "br" }
  }

  class Br_s extends UnconditionalBranch, @cil_br_s {
    override string getOpcodeName() { result = "br.s" }
  }

  class Brfalse_s extends UnaryBranch, @cil_brfalse_s {
    override string getOpcodeName() { result = "brfalse.s" }
  }

  class Brfalse extends UnaryBranch, @cil_brfalse {
    override string getOpcodeName() { result = "brfalse" }
  }

  class Brtrue_s extends UnaryBranch, @cil_brtrue_s {
    override string getOpcodeName() { result = "brtrue.s" }
  }

  class Brtrue extends UnaryBranch, @cil_brtrue {
    override string getOpcodeName() { result = "brtrue" }
  }

  class Blt_s extends BinaryBranch, @cil_blt_s {
    override string getOpcodeName() { result = "blt.s" }
  }

  class Blt extends BinaryBranch, @cil_blt {
    override string getOpcodeName() { result = "blt" }
  }

  class Blt_un_s extends BinaryBranch, @cil_blt_un_s {
    override string getOpcodeName() { result = "blt.un.s" }
  }

  class Blt_un extends BinaryBranch, @cil_blt_un {
    override string getOpcodeName() { result = "blt.un" }
  }

  class Bgt_un extends BinaryBranch, @cil_bgt_un {
    override string getOpcodeName() { result = "bgt.un" }
  }

  class Ble_un_s extends BinaryBranch, @cil_ble_un_s {
    override string getOpcodeName() { result = "ble.un.s" }
  }

  class Ble_un extends BinaryBranch, @cil_ble_un {
    override string getOpcodeName() { result = "ble.un" }
  }

  class Bge_s extends BinaryBranch, @cil_bge_s {
    override string getOpcodeName() { result = "bge.s" }
  }

  class Bge_un extends BinaryBranch, @cil_bge_un {
    override string getOpcodeName() { result = "bge.un" }
  }

  class Bge extends BinaryBranch, @cil_bge {
    override string getOpcodeName() { result = "bge" }
  }

  class Bne_un_s extends BinaryBranch, @cil_bne_un_s {
    override string getOpcodeName() { result = "bne.un.s" }
  }

  class Bne_un extends BinaryBranch, @cil_bne_un {
    override string getOpcodeName() { result = "bne.un" }
  }

  class Beq extends BinaryBranch, @cil_beq {
    override string getOpcodeName() { result = "beq" }
  }

  class Beq_s extends BinaryBranch, @cil_beq_s {
    override string getOpcodeName() { result = "beq.s" }
  }

  class Ble_s extends BinaryBranch, @cil_ble_s {
    override string getOpcodeName() { result = "ble.s" }
  }

  class Ble extends BinaryBranch, @cil_ble {
    override string getOpcodeName() { result = "ble" }
  }

  class Bgt_s extends BinaryBranch, @cil_bgt_s {
    override string getOpcodeName() { result = "bgt.s" }
  }

  class Bgt extends BinaryBranch, @cil_bgt {
    override string getOpcodeName() { result = "bgt" }
  }

  class Bgt_in_s extends BinaryBranch, @cil_bgt_un_s {
    override string getOpcodeName() { result = "bgt.un.s" }
  }

  class Bge_in_s extends BinaryBranch, @cil_bge_un_s {
    override string getOpcodeName() { result = "bge.un.s" }
  }

  class Switch extends ConditionalBranch, @cil_switch {
    override string getOpcodeName() { result = "switch" }

    /** Gets the `n`th jump target of this switch. */
    Instruction getTarget(int n) { cil_switch(this, n, result) }

    override Instruction getASuccessorType(FlowType t) {
      t instanceof NormalFlow and
      (result = getTarget(_) or result = getImplementation().getInstruction(getIndex() + 1))
    }

    override string getExtra() {
      result = concat(int n | exists(getTarget(n)) | getTarget(n).getIndex() + ":", " ")
    }
  }

  class Leave_ extends Leave, @cil_leave {
    override string getOpcodeName() { result = "leave" }
  }

  class Leave_s extends Leave, @cil_leave_s {
    override string getOpcodeName() { result = "leave.s" }
  }

  class Endfilter extends Instruction, @cil_endfilter {
    override string getOpcodeName() { result = "endfilter" }
  }

  class Endfinally extends Instruction, @cil_endfinally {
    override string getOpcodeName() { result = "endfinally" }

    override predicate canFlowNext() { none() }
  }

  // Comparisons (not jumps)
  class Cgt_un extends ComparisonOperation, @cil_cgt_un {
    override string getOpcodeName() { result = "cgt.un" }
  }

  class Cgt extends ComparisonOperation, @cil_cgt {
    override string getOpcodeName() { result = "cgt" }
  }

  class Clt_un extends ComparisonOperation, @cil_clt_un {
    override string getOpcodeName() { result = "cgt.un" }
  }

  class Clt extends ComparisonOperation, @cil_clt {
    override string getOpcodeName() { result = "clt" }
  }

  // Calls
  class Call_ extends Call, @cil_call {
    override string getOpcodeName() { result = "call" }
  }

  class Callvirt extends Call, @cil_callvirt {
    override string getOpcodeName() { result = "callvirt" }

    override predicate isVirtual() { any() }
  }

  class Tail extends Instruction, @cil_tail {
    override string getOpcodeName() { result = "tail." }
  }

  class Jmp extends Call, @cil_jmp {
    override string getOpcodeName() { result = "jmp" }

    override predicate isTailCall() { any() }
  }

  class Isinst extends UnaryExpr, @cil_isinst {
    override string getOpcodeName() { result = "isinst" }

    override BoolType getType() { exists(result) }

    /** Gets the type that is being tested against. */
    Type getTestedType() { result = getAccess() }

    override string getExtra() { result = getTestedType().getQualifiedName() }
  }

  class Castclass extends UnaryExpr, @cil_castclass {
    override string getOpcodeName() { result = "castclass" }

    override Type getType() { result = getAccess() }

    /** Gets the type that is being cast to. */
    Type getTestedType() { result = getAccess() }

    override string getExtra() { result = getTestedType().getQualifiedName() }
  }

  // Locals
  class Stloc_0 extends LocalVariableWriteAccess, @cil_stloc_0 {
    override string getOpcodeName() { result = "stloc.0" }

    override LocalVariable getTarget() { result = getImplementation().getLocalVariable(0) }
  }

  class Stloc_1 extends LocalVariableWriteAccess, @cil_stloc_1 {
    override string getOpcodeName() { result = "stloc.1" }

    override LocalVariable getTarget() { result = getImplementation().getLocalVariable(1) }
  }

  class Stloc_2 extends LocalVariableWriteAccess, @cil_stloc_2 {
    override string getOpcodeName() { result = "stloc.2" }

    override LocalVariable getTarget() { result = getImplementation().getLocalVariable(2) }
  }

  class Stloc_3 extends LocalVariableWriteAccess, @cil_stloc_3 {
    override string getOpcodeName() { result = "stloc.3" }

    override LocalVariable getTarget() { result = getImplementation().getLocalVariable(3) }
  }

  class Stloc_s extends LocalVariableWriteAccess, @cil_stloc_s {
    override string getOpcodeName() { result = "stloc.s" }

    override LocalVariable getTarget() { cil_access(this, result) }
  }

  class Stloc extends LocalVariableWriteAccess, @cil_stloc {
    override string getOpcodeName() { result = "stloc" }

    override LocalVariable getTarget() { cil_access(this, result) }
  }

  class Ldloc_0 extends LocalVariableReadAccess, @cil_ldloc_0 {
    override string getOpcodeName() { result = "ldloc.0" }

    override LocalVariable getTarget() { result = getImplementation().getLocalVariable(0) }
  }

  class Ldloc_1 extends LocalVariableReadAccess, @cil_ldloc_1 {
    override string getOpcodeName() { result = "ldloc.1" }

    override LocalVariable getTarget() { result = getImplementation().getLocalVariable(1) }
  }

  class Ldloc_2 extends LocalVariableReadAccess, @cil_ldloc_2 {
    override string getOpcodeName() { result = "ldloc.2" }

    override LocalVariable getTarget() { result = getImplementation().getLocalVariable(2) }
  }

  class Ldloc_3 extends LocalVariableReadAccess, @cil_ldloc_3 {
    override string getOpcodeName() { result = "ldloc.3" }

    override LocalVariable getTarget() { result = getImplementation().getLocalVariable(3) }
  }

  class Ldloc_s extends LocalVariableReadAccess, @cil_ldloc_s {
    override string getOpcodeName() { result = "ldloc.s" }

    override LocalVariable getTarget() { cil_access(this, result) }

    override string getExtra() { result = "L" + getTarget().getIndex() }
  }

  class Ldloca_s extends LocalVariableReadAccess, ReadRefAccess, @cil_ldloca_s {
    override string getOpcodeName() { result = "ldloca.s" }

    override LocalVariable getTarget() { cil_access(this, result) }

    override string getExtra() { result = "L" + getTarget().getIndex() }
  }

  class Ldloc extends LocalVariableReadAccess, @cil_ldloc {
    override string getOpcodeName() { result = "ldloc" }

    override LocalVariable getTarget() { cil_access(this, result) }

    override string getExtra() { result = "L" + getTarget().getIndex() }
  }

  // Arguments
  class Ldarg_0 extends ParameterReadAccess, @cil_ldarg_0 {
    override string getOpcodeName() { result = "ldarg.0" }

    override Parameter getTarget() { result = getImplementation().getMethod().getRawParameter(0) }
  }

  class Ldarg_1 extends ParameterReadAccess, @cil_ldarg_1 {
    override string getOpcodeName() { result = "ldarg.1" }

    override Parameter getTarget() { result = getImplementation().getMethod().getRawParameter(1) }
  }

  class Ldarg_2 extends ParameterReadAccess, @cil_ldarg_2 {
    override string getOpcodeName() { result = "ldarg.2" }

    override Parameter getTarget() { result = getImplementation().getMethod().getRawParameter(2) }
  }

  class Ldarg_3 extends ParameterReadAccess, @cil_ldarg_3 {
    override string getOpcodeName() { result = "ldarg.3" }

    override Parameter getTarget() { result = getImplementation().getMethod().getRawParameter(3) }
  }

  class Ldarg_s extends ParameterReadAccess, @cil_ldarg_s {
    override string getOpcodeName() { result = "ldarg.s" }

    override Parameter getTarget() { cil_access(this, result) }

    override string getExtra() { result = this.getTarget().getIndex().toString() }
  }

  class Ldarg extends ParameterReadAccess, @cil_ldarg {
    override string getOpcodeName() { result = "ldarg" }

    override Parameter getTarget() { cil_access(this, result) }
  }

  class Ldarga_s extends ParameterReadAccess, ReadRefAccess, @cil_ldarga_s {
    override string getOpcodeName() { result = "ldarga.s" }

    override Parameter getTarget() { cil_access(this, result) }
  }

  class Starg_s extends ParameterWriteAccess, @cil_starg_s {
    override string getOpcodeName() { result = "starg.s" }

    override Parameter getTarget() { cil_access(this, result) }
  }

  // Fields
  class Ldfld extends FieldReadAccess, @cil_ldfld {
    override string getOpcodeName() { result = "ldfld" }

    override int getPopCount() { result = 1 }

    override Expr getQualifier() { result = getOperand(0) }
  }

  class Ldflda extends FieldReadAccess, ReadRefAccess, @cil_ldflda {
    override string getOpcodeName() { result = "ldflda" }

    override int getPopCount() { result = 1 }

    override Expr getQualifier() { result = getOperand(0) }
  }

  class Ldsfld extends FieldReadAccess, @cil_ldsfld {
    override string getOpcodeName() { result = "ldsfld" }

    override int getPopCount() { result = 0 }

    override Expr getQualifier() { none() }
  }

  class Ldsflda extends FieldReadAccess, ReadRefAccess, @cil_ldsflda {
    override string getOpcodeName() { result = "ldsflda" }

    override int getPopCount() { result = 0 }

    override Expr getQualifier() { none() }
  }

  class Stfld extends FieldWriteAccess, @cil_stfld {
    override string getOpcodeName() { result = "stfld" }

    override int getPopCount() { result = 2 }

    override Expr getQualifier() { result = getOperand(1) }

    override Expr getExpr() { result = getOperand(0) }
  }

  class Stsfld extends FieldWriteAccess, @cil_stsfld {
    override string getOpcodeName() { result = "stsfld" }

    override int getPopCount() { result = 1 }

    override Expr getQualifier() { none() }

    override Expr getExpr() { result = getOperand(0) }
  }

  class Newobj extends Call, @cil_newobj {
    override string getOpcodeName() { result = "newobj" }

    override int getPushCount() { result = 1 }

    override int getPopCount() { result = count(this.getARawTargetParameter()) - 1 }

    override Type getType() { result = this.getTarget().getDeclaringType() }

    override Expr getArgument(int i) { result = getRawArgument(i) }

    pragma[noinline]
    private Parameter getARawTargetParameter() { result = this.getTarget().getARawParameter() }

    override Expr getArgumentForParameter(DotNet::Parameter param) {
      exists(int index |
        result = this.getArgument(index) and
        param = this.getTarget().getParameter(index)
      )
    }
  }

  class Initobj extends Instruction, @cil_initobj {
    override string getOpcodeName() { result = "initobj" }

    override int getPopCount() { result = 1 } // ??
  }

  class Box extends UnaryExpr, @cil_box {
    override string getOpcodeName() { result = "box" }

    override Type getType() { result = getAccess() }
  }

  class Unbox_any extends UnaryExpr, @cil_unbox_any {
    override string getOpcodeName() { result = "unbox.any" }

    override Type getType() { result = getAccess() }
  }

  class Unbox extends UnaryExpr, @cil_unbox {
    override string getOpcodeName() { result = "unbox" }

    override Type getType() { result = getAccess() }
  }

  class Ldobj extends UnaryExpr, @cil_ldobj {
    override string getOpcodeName() { result = "ldobj" }

    /** Gets the type of the object. */
    Type getTarget() { cil_access(this, result) }

    override Type getType() { result = getAccess() }
  }

  class Ldtoken extends Expr, @cil_ldtoken {
    override string getOpcodeName() { result = "ldtoken" }

    // Not really sure what a type of a token is so use `object`.
    override ObjectType getType() { exists(result) }
  }

  class Constrained extends Instruction, @cil_constrained {
    override string getOpcodeName() { result = "constrained." }
  }

  class Throw_ extends Throw, @cil_throw {
    override string getOpcodeName() { result = "throw" }

    override int getPopCount() { result = 1 }
  }

  class Rethrow extends Throw, @cil_rethrow {
    override string getOpcodeName() { result = "rethrow" }
  }

  class Ldlen extends UnaryExpr, @cil_ldlen {
    override string getOpcodeName() { result = "ldlen" }

    override IntType getType() { exists(result) }
  }

  // Arrays
  class Newarr extends Expr, @cil_newarr {
    override string getOpcodeName() { result = "newarr" }

    override int getPushCount() { result = 1 }

    override int getPopCount() { result = 1 }

    override Type getType() {
      // Note that this is technically wrong - it should be
      // result.(ArrayType).getElementType() = getAccess()
      // However the (ArrayType) may not be in the database.
      result = getAccess()
    }

    override string getExtra() { result = getType().getQualifiedName() }
  }

  class Ldelem extends ReadArrayElement, @cil_ldelem {
    override string getOpcodeName() { result = "ldelem" }

    override Type getType() { result = getAccess() }
  }

  class Ldelem_ref extends ReadArrayElement, @cil_ldelem_ref {
    override string getOpcodeName() { result = "ldelem.ref" }

    override Type getType() { result = getArray().getType() }
  }

  class Ldelema extends ReadArrayElement, ReadRef, @cil_ldelema {
    override string getOpcodeName() { result = "ldelema" }

    override Type getType() { result = getAccess() }
  }

  class Stelem_ref extends WriteArrayElement, @cil_stelem_ref {
    override string getOpcodeName() { result = "stelem.ref" }
  }

  class Stelem extends WriteArrayElement, @cil_stelem {
    override string getOpcodeName() { result = "stelem" }
  }

  class Stelem_i extends WriteArrayElement, @cil_stelem_i {
    override string getOpcodeName() { result = "stelem.i" }
  }

  class Stelem_i1 extends WriteArrayElement, @cil_stelem_i1 {
    override string getOpcodeName() { result = "stelem.i1" }
  }

  class Stelem_i2 extends WriteArrayElement, @cil_stelem_i2 {
    override string getOpcodeName() { result = "stelem.i2" }
  }

  class Stelem_i4 extends WriteArrayElement, @cil_stelem_i4 {
    override string getOpcodeName() { result = "stelem.i4" }
  }

  class Stelem_i8 extends WriteArrayElement, @cil_stelem_i8 {
    override string getOpcodeName() { result = "stelem.i8" }
  }

  class Stelem_r4 extends WriteArrayElement, @cil_stelem_r4 {
    override string getOpcodeName() { result = "stelem.r4" }
  }

  class Stelem_r8 extends WriteArrayElement, @cil_stelem_r8 {
    override string getOpcodeName() { result = "stelem.r8" }
  }

  class Ldelem_i extends ReadArrayElement, @cil_ldelem_i {
    override string getOpcodeName() { result = "ldelem.i" }

    override IntType getType() { exists(result) }
  }

  class Ldelem_i1 extends ReadArrayElement, @cil_ldelem_i1 {
    override string getOpcodeName() { result = "ldelem.i1" }

    override SByteType getType() { exists(result) }
  }

  class Ldelem_i2 extends ReadArrayElement, @cil_ldelem_i2 {
    override string getOpcodeName() { result = "ldelem.i2" }

    override ShortType getType() { exists(result) }
  }

  class Ldelem_i4 extends ReadArrayElement, @cil_ldelem_i4 {
    override string getOpcodeName() { result = "ldelem.i4" }

    override IntType getType() { exists(result) }
  }

  class Ldelem_i8 extends ReadArrayElement, @cil_ldelem_i8 {
    override string getOpcodeName() { result = "ldelem.i8" }

    override LongType getType() { exists(result) }
  }

  class Ldelem_r4 extends ReadArrayElement, @cil_ldelem_r4 {
    override string getOpcodeName() { result = "ldelem.r4" }

    override FloatType getType() { exists(result) }
  }

  class Ldelem_r8 extends ReadArrayElement, @cil_ldelem_r8 {
    override string getOpcodeName() { result = "ldelem.r8" }

    override DoubleType getType() { exists(result) }
  }

  class Ldelem_u1 extends ReadArrayElement, @cil_ldelem_u1 {
    override string getOpcodeName() { result = "ldelem.u1" }

    override ByteType getType() { exists(result) }
  }

  class Ldelem_u2 extends ReadArrayElement, @cil_ldelem_u2 {
    override string getOpcodeName() { result = "ldelem.u2" }

    override UShortType getType() { exists(result) }
  }

  class Ldelem_u4 extends ReadArrayElement, @cil_ldelem_u4 {
    override string getOpcodeName() { result = "ldelem.u4" }

    override UIntType getType() { exists(result) }
  }

  // Conversions
  class Conv_i extends Conversion, @cil_conv_i {
    override string getOpcodeName() { result = "conv.i" }

    override IntType getType() { exists(result) }
  }

  class Conv_ovf_i extends Conversion, @cil_conv_ovf_i {
    override string getOpcodeName() { result = "conv.ovf.i" }

    override IntType getType() { exists(result) }
  }

  class Conv_ovf_i_un extends Conversion, @cil_conv_ovf_i_un {
    override string getOpcodeName() { result = "conv.ovf.i.un" }

    override UIntType getType() { exists(result) }
  }

  class Conv_i1 extends Conversion, @cil_conv_i1 {
    override string getOpcodeName() { result = "conv.i1" }

    override SByteType getType() { exists(result) }
  }

  class Conv_ovf_i1 extends Conversion, @cil_conv_ovf_i1 {
    override string getOpcodeName() { result = "conv.ovf.i1" }

    override SByteType getType() { exists(result) }
  }

  class Conv_ovf_i1_un extends Conversion, @cil_conv_ovf_i1_un {
    override string getOpcodeName() { result = "conv.ovf.i1.un" }

    override SByteType getType() { exists(result) }
  }

  class Conv_i2 extends Conversion, @cil_conv_i2 {
    override string getOpcodeName() { result = "conv.i2" }

    override ShortType getType() { exists(result) }
  }

  class Conv_ovf_i2 extends Conversion, @cil_conv_ovf_i2 {
    override string getOpcodeName() { result = "conv.ovf.i2" }

    override ShortType getType() { exists(result) }
  }

  class Conv_ovf_i2_un extends Conversion, @cil_conv_ovf_i2_un {
    override string getOpcodeName() { result = "conv.ovf.i2.un" }

    override ShortType getType() { exists(result) }
  }

  class Conv_i4 extends Conversion, @cil_conv_i4 {
    override string getOpcodeName() { result = "conv.i4" }

    override IntType getType() { exists(result) }
  }

  class Conv_ovf_i4 extends Conversion, @cil_conv_ovf_i4 {
    override string getOpcodeName() { result = "conv.ovf.i4" }

    override IntType getType() { exists(result) }
  }

  class Conv_ovf_i4_un extends Conversion, @cil_conv_ovf_i4_un {
    override string getOpcodeName() { result = "conv.ovf.i4.un" }

    override IntType getType() { exists(result) }
  }

  class Conv_i8 extends Conversion, @cil_conv_i8 {
    override string getOpcodeName() { result = "conv.i8" }

    override LongType getType() { exists(result) }
  }

  class Conv_ovf_i8 extends Conversion, @cil_conv_ovf_i8 {
    override string getOpcodeName() { result = "conv.ovf.i8" }

    override LongType getType() { exists(result) }
  }

  class Conv_ovf_i8_un extends Conversion, @cil_conv_ovf_i8_un {
    override string getOpcodeName() { result = "conv.ovf.i8.un" }

    override LongType getType() { exists(result) }
  }

  // Unsigned conversions
  class Conv_u extends Conversion, @cil_conv_u {
    override string getOpcodeName() { result = "conv.u" }

    override UIntType getType() { exists(result) }
  }

  class Conv_ovf_u extends Conversion, @cil_conv_ovf_u {
    override string getOpcodeName() { result = "conv.ovf.u" }

    override UIntType getType() { exists(result) }
  }

  class Conv_ovf_u_un extends Conversion, @cil_conv_ovf_u_un {
    override string getOpcodeName() { result = "conv.ovf.u.un" }

    override UIntType getType() { exists(result) }
  }

  class Conv_u1 extends Conversion, @cil_conv_u1 {
    override string getOpcodeName() { result = "conv.u1" }

    override ByteType getType() { exists(result) }
  }

  class Conv_ovf_u1 extends Conversion, @cil_conv_ovf_u1 {
    override string getOpcodeName() { result = "conv.ovf.u1" }

    override ByteType getType() { exists(result) }
  }

  class Conv_ovf_u1_un extends Conversion, @cil_conv_ovf_u1_un {
    override string getOpcodeName() { result = "conv.ovf.u1.un" }

    override ByteType getType() { exists(result) }
  }

  class Conv_u2 extends Conversion, @cil_conv_u2 {
    override string getOpcodeName() { result = "conv.u2" }

    override UShortType getType() { exists(result) }
  }

  class Conv_ovf_u2 extends Conversion, @cil_conv_ovf_u2 {
    override string getOpcodeName() { result = "conv.ovf.u2" }

    override UShortType getType() { exists(result) }
  }

  class Conv_ovf_u2_un extends Conversion, @cil_conv_ovf_u2_un {
    override string getOpcodeName() { result = "conv.ovf.u2.un" }

    override UShortType getType() { exists(result) }
  }

  class Conv_u4 extends Conversion, @cil_conv_u4 {
    override string getOpcodeName() { result = "conv.u4" }

    override UIntType getType() { exists(result) }
  }

  class Conv_ovf_u4 extends Conversion, @cil_conv_ovf_u4 {
    override string getOpcodeName() { result = "conv.ovf.u4" }

    override UIntType getType() { exists(result) }
  }

  class Conv_ovf_u4_un extends Conversion, @cil_conv_ovf_u4_un {
    override string getOpcodeName() { result = "conv.ovf.u4.un" }

    override UIntType getType() { exists(result) }
  }

  class Conv_u8 extends Conversion, @cil_conv_u8 {
    override string getOpcodeName() { result = "conv.u8" }

    override ULongType getType() { exists(result) }
  }

  class Conv_ovf_u8 extends Conversion, @cil_conv_ovf_u8 {
    override string getOpcodeName() { result = "conv.ovf.u8" }

    override ULongType getType() { exists(result) }
  }

  class Conv_ovf_u8_un extends Conversion, @cil_conv_ovf_u8_un {
    override string getOpcodeName() { result = "conv.ovf.u8.un" }

    override ULongType getType() { exists(result) }
  }

  // Floating point conversions
  class Conv_r4 extends Conversion, @cil_conv_r4 {
    override string getOpcodeName() { result = "conv.r4" }

    override FloatType getType() { exists(result) }
  }

  class Conv_r8 extends Conversion, @cil_conv_r8 {
    override string getOpcodeName() { result = "conv.r8" }

    override DoubleType getType() { exists(result) }
  }

  class Conv_r_un extends Conversion, @cil_conv_r_un {
    override string getOpcodeName() { result = "conv.r.un" }

    override DoubleType getType() { exists(result) } // ??
  }

  class Volatile extends Instruction, @cil_volatile {
    override string getOpcodeName() { result = "volatile." }
  }

  // Indirections
  class Ldind_i extends LoadIndirect, @cil_ldind_i {
    override string getOpcodeName() { result = "ldind.i" }

    override IntType getType() { exists(result) }
  }

  class Ldind_i1 extends LoadIndirect, @cil_ldind_i1 {
    override string getOpcodeName() { result = "ldind.i1" }

    override SByteType getType() { exists(result) }
  }

  class Ldind_i2 extends LoadIndirect, @cil_ldind_i2 {
    override string getOpcodeName() { result = "ldind.i2" }

    override ShortType getType() { exists(result) }
  }

  class Ldind_i4 extends LoadIndirect, @cil_ldind_i4 {
    override string getOpcodeName() { result = "ldind.i4" }

    override IntType getType() { exists(result) }
  }

  class Ldind_i8 extends LoadIndirect, @cil_ldind_i8 {
    override string getOpcodeName() { result = "ldind.i8" }

    override LongType getType() { exists(result) }
  }

  class Ldind_r4 extends LoadIndirect, @cil_ldind_r4 {
    override string getOpcodeName() { result = "ldind.r4" }

    override FloatType getType() { exists(result) }
  }

  class Ldind_r8 extends LoadIndirect, @cil_ldind_r8 {
    override string getOpcodeName() { result = "ldind.r8" }

    override DoubleType getType() { exists(result) }
  }

  class Ldind_ref extends LoadIndirect, @cil_ldind_ref {
    override string getOpcodeName() { result = "ldind.ref" }

    override ObjectType getType() { exists(result) }
  }

  class Ldind_u1 extends LoadIndirect, @cil_ldind_u1 {
    override string getOpcodeName() { result = "ldind.u1" }

    override ByteType getType() { exists(result) }
  }

  class Ldind_u2 extends LoadIndirect, @cil_ldind_u2 {
    override string getOpcodeName() { result = "ldind.u2" }

    override UShortType getType() { exists(result) }
  }

  class Ldind_u4 extends LoadIndirect, @cil_ldind_u4 {
    override string getOpcodeName() { result = "ldind.u4" }

    override UIntType getType() { exists(result) }
  }

  class Stind_i extends StoreIndirect, @cil_stind_i {
    override string getOpcodeName() { result = "stind.i" }
  }

  class Stind_i1 extends StoreIndirect, @cil_stind_i1 {
    override string getOpcodeName() { result = "stind.i1" }
  }

  class Stind_i2 extends StoreIndirect, @cil_stind_i2 {
    override string getOpcodeName() { result = "stind.i2" }
  }

  class Stind_i4 extends StoreIndirect, @cil_stind_i4 {
    override string getOpcodeName() { result = "stind.i4" }
  }

  class Stind_i8 extends StoreIndirect, @cil_stind_i8 {
    override string getOpcodeName() { result = "stind.i8" }
  }

  class Stind_r4 extends StoreIndirect, @cil_stind_r4 {
    override string getOpcodeName() { result = "stind.r4" }
  }

  class Stind_r8 extends StoreIndirect, @cil_stind_r8 {
    override string getOpcodeName() { result = "stind.r4" }
  }

  class Stind_ref extends StoreIndirect, @cil_stind_ref {
    override string getOpcodeName() { result = "stind.ref" }
  }

  // Miscellaneous
  class Stobj extends Instruction, @cil_stobj {
    override string getOpcodeName() { result = "stobj" }

    override int getPopCount() { result = 2 }
  }

  class Ldftn extends Expr, @cil_ldftn {
    override string getOpcodeName() { result = "ldftn" }

    override int getPopCount() { result = 0 }
  }

  class Ldvirtftn extends Expr, @cil_ldvirtftn {
    override string getOpcodeName() { result = "ldvirtftn" }

    override int getPopCount() { result = 1 }
  }

  class Sizeof extends Expr, @cil_sizeof {
    override string getOpcodeName() { result = "sizeof" }

    override IntType getType() { exists(result) }
  }

  class Localloc extends Expr, @cil_localloc {
    override string getOpcodeName() { result = "localloc" }

    override int getPopCount() { result = 1 }

    override PointerType getType() { result.getReferentType() instanceof ByteType }
  }

  class Readonly extends Instruction, @cil_readonly {
    override string getOpcodeName() { result = "readonly." }
  }

  class Mkrefany extends Expr, @cil_mkrefany {
    override string getOpcodeName() { result = "mkrefany" }

    override int getPopCount() { result = 1 }

    override Type getType() { result = getAccess() }
  }

  class Refanytype extends Expr, @cil_refanytype {
    override string getOpcodeName() { result = "refanytype" }

    override int getPopCount() { result = 1 }

    override SystemType getType() { exists(result) }
  }

  class Arglist extends Expr, @cil_arglist {
    override string getOpcodeName() { result = "arglist" }
  }
}
