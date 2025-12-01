private import binary

// TODO
class CilVariable instanceof @method {
  string toString() { none() }
}

class CilMethod extends @method {
  string getName() { methods(this, result, _, _) }

  string toString() { result = this.getName() }

  private string getSignature() { methods(this, _, result, _) }

  predicate isVoid() {
    this.getSignature().matches("Void%") // TODO: Don't use string parsing here
  }

  CilInstruction getAnInstruction() { il_instruction_method(result, this) }

  CilInstruction getInstruction(int i) { il_instruction_parent(result, i, this) }

  CilVariable getVariable(int i) { none() } // TODO
}

pragma[nomagic]
private predicate hasMethodAndOffset(CilMethod m, int offset, CilInstruction instr) {
  instr.getEnclosingMethod() = m and
  instr.getOffset() = offset
}

pragma[nomagic]
private predicate hasMethodAndIndex(CilMethod m, int index, CilInstruction instr) {
  m.getInstruction(index) = instr
}

private predicate isBackEdge(CilInstruction instr1, CilInstruction instr2) {
  exists(CilMethod m, int index1, int index2 |
    m.getInstruction(index1) = instr1 and
    m.getInstruction(index2) = instr2 and
    instr1.getASuccessor() = instr2 and
    index2 < index1
  )
}

class CilInstruction extends @il_instruction {
  string toString() {
    exists(string s |
      instruction_string(this, s) and
      result = s + " (" + this.getEnclosingMethod() + ": " + this.getOffset() + ")"
    )
  }

  Location getLocation() { instruction_location(this, result) }

  CilMethod getEnclosingMethod() { result.getAnInstruction() = this }

  int getOffset() { il_instruction(this, result, _) }

  CilInstruction getAPredecessor() { result.getASuccessor() = this }

  CilInstruction getABackwardPredecessor() { result.getAForwardSuccessor() = this }

  CilInstruction getASuccessor() {
    exists(int offset, CilMethod m |
      hasMethodAndIndex(m, offset, this) and
      hasMethodAndIndex(m, offset + 1, result)
    )
  }

  final CilInstruction getAForwardSuccessor() {
    result = this.getASuccessor() and not isBackEdge(this, result)
  }
}

class CilNop extends @il_nop, CilInstruction { }

class CilBreak extends @il_break, CilInstruction { }

class CilLdarg_0 extends @il_ldarg_0, CilInstruction { }

class CilLdarg_1 extends @il_ldarg_1, CilInstruction { }

class CilLdarg_2 extends @il_ldarg_2, CilInstruction { }

class CilLdarg_3 extends @il_ldarg_3, CilInstruction { }

class CilLdloc_0 extends @il_ldloc_0, CilLoadLocal {
  override int getLocalVariableIndex() { result = 0 }
}

class CilLdloc_1 extends @il_ldloc_1, CilLoadLocal {
  override int getLocalVariableIndex() { result = 1 }
}

class CilLdloc_2 extends @il_ldloc_2, CilLoadLocal {
  override int getLocalVariableIndex() { result = 2 }
}

class CilLdloc_3 extends @il_ldloc_3, CilLoadLocal {
  override int getLocalVariableIndex() { result = 3 }
}

class CilStloc_0 extends @il_stloc_0, CilStoreLocal {
  override int getLocalVariableIndex() { result = 0 }
}

class CilStloc_1 extends @il_stloc_1, CilStoreLocal {
  override int getLocalVariableIndex() { result = 1 }
}

class CilStloc_2 extends @il_stloc_2, CilStoreLocal {
  override int getLocalVariableIndex() { result = 2 }
}

class CilStloc_3 extends @il_stloc_3, CilStoreLocal {
  override int getLocalVariableIndex() { result = 3 }
}

abstract class CilLoadArgument extends CilInstruction { }

class CilLdarg_S extends @il_ldarg_S, CilLoadArgument { }

class CilLdarga_S extends @il_ldarga_S, CilLoadArgument { }

abstract class CilStoreArgument extends CilInstruction { }

class CilStarg_S extends @il_starg_S, CilStoreArgument { }

class CilLdloc_S extends @il_ldloc_S, CilLoadLocal {
  override int getLocalVariableIndex() {
    none() // TODO: Extract
  }
}

abstract class CilLoadLocal extends CilInstruction {
  abstract int getLocalVariableIndex();
}

abstract class CilLoadAddressOfLocal extends CilInstruction { }

class CilLdloca_S extends @il_ldloca_S, CilLoadAddressOfLocal { }

class CilStloc_S extends @il_stloc_S, CilStoreLocal {
  override int getLocalVariableIndex() {
    none() // TODO: Extract
  }
}

class CilLdnull extends @il_ldnull, CilInstruction { }

/** An instruction that loads a constant onto the evaluation stack. */
abstract class CilLoadConstant extends CilInstruction {
  abstract string getValue();

  abstract int getSize();
}

class CilLdc_I4_M1 extends @il_ldc_I4_M1, CilLoadConstant {
  final override string getValue() { result = "-1" }

  final override int getSize() { result = 4 } // int32
}

class CilLdc_I4_0 extends @il_ldc_I4_0, CilLoadConstant {
  final override string getValue() { result = "0" }

  final override int getSize() { result = 4 } // int32
}

class CilLdc_I4_1 extends @il_ldc_I4_1, CilLoadConstant {
  final override string getValue() { result = "1" }

  final override int getSize() { result = 4 } // int32
}

class CilLdc_I4_2 extends @il_ldc_I4_2, CilLoadConstant {
  final override string getValue() { result = "2" }

  final override int getSize() { result = 4 } // int32
}

class CilLdc_I4_3 extends @il_ldc_I4_3, CilLoadConstant {
  final override string getValue() { result = "3" }

  final override int getSize() { result = 4 } // int32
}

class CilLdc_I4_4 extends @il_ldc_I4_4, CilLoadConstant {
  final override string getValue() { result = "4" }

  final override int getSize() { result = 4 } // int32
}

class CilLdc_I4_5 extends @il_ldc_I4_5, CilLoadConstant {
  final override string getValue() { result = "5" }

  final override int getSize() { result = 4 } // int32
}

class CilLdc_I4_6 extends @il_ldc_I4_6, CilLoadConstant {
  final override string getValue() { result = "6" }

  final override int getSize() { result = 4 } // int32
}

class CilLdc_I4_7 extends @il_ldc_I4_7, CilLoadConstant {
  final override string getValue() { result = "7" }

  final override int getSize() { result = 4 } // int32
}

class CilLdc_I4_8 extends @il_ldc_I4_8, CilLoadConstant {
  final override string getValue() { result = "8" }

  final override int getSize() { result = 4 } // int32
}

class CilLdc_I4_S extends @il_ldc_I4_S, CilLoadConstant {
  final override string getValue() {
    exists(int k |
      il_operand_sbyte(this, k) and
      result = k.toString()
    )
  }

  final override int getSize() { result = 1 } // int8
}

class CilLdc_I4 extends @il_ldc_I4, CilLoadConstant {
  final override string getValue() {
    exists(int k |
      il_operand_int(this, k) and
      result = k.toString()
    )
  }

  final override int getSize() { result = 4 } // int32
}

class CilLdc_I8 extends @il_ldc_I8, CilLoadConstant {
  final override string getValue() {
    exists(int k |
      // NOTE: QL does not have 64-bit integers. This should be a big-int
      il_operand_int(this, k) and
      result = k.toString()
    )
  }

  final override int getSize() { result = 8 } // int64
}

class CilLdc_R4 extends @il_ldc_R4, CilLoadConstant {
  final override string getValue() {
    none() // TODO
  }

  final override int getSize() { result = 4 } // float32
}

class CilLdc_R8 extends @il_ldc_R8, CilLoadConstant {
  final override string getValue() {
    none() // TODO
  }

  final override int getSize() { result = 8 } // float64
}

class CilDup extends @il_dup, CilInstruction { }

class CilIl_pop extends @il_il_pop, CilInstruction { }

abstract class CilCall extends CilInstruction {
  final int getNumberOfArguments() { il_number_of_arguments(this, result) }

  final predicate hasReturnValue() { il_call_has_return_value(this) }

  string getExternalName() {
    il_call_target_unresolved(this, result)
  }
}

class CilIl_jmp extends @il_il_jmp, CilCall { }

class CilIl_call extends @il_il_call, CilCall { }

class CilCalli extends @il_calli, CilCall { }

class CilIl_ret extends @il_il_ret, CilInstruction { }

abstract class CilBranchInstruction extends CilInstruction {
  abstract predicate isUnconditionalJump();

  final override CilInstruction getASuccessor() {
    not this.isUnconditionalJump() and
    result = super.getASuccessor()
    or
    result = this.getABranchTarget()
  }

  CilInstruction getABranchTarget() {
    exists(CilMethod m, int delta |
      il_branch_target(this, delta) and
      hasMethodAndOffset(m, delta, result)
    )
  }

  CilInstruction getFallThrough() {
    not this.isUnconditionalJump() and
    result = super.getASuccessor() and
    result != this.getABranchTarget()
  }
}

abstract class CilUnconditionalBranchInstruction extends CilBranchInstruction {
  final override predicate isUnconditionalJump() { any() }
}

class CilBr_S extends @il_br_S, CilUnconditionalBranchInstruction { }

abstract class CilBooleanBranchInstruction extends CilBranchInstruction {
  final override predicate isUnconditionalJump() { none() }
}

abstract class CilBooleanBranchFalse extends CilBooleanBranchInstruction { }

class CilBrfalse_S extends @il_brfalse_S, CilBooleanBranchFalse { }

abstract class CilBooleanBranchTrue extends CilBooleanBranchInstruction { }

class CilBrtrue_S extends @il_brtrue_S, CilBooleanBranchTrue { }

abstract class CilRelationalBranchInstruction extends CilBranchInstruction {
  final override predicate isUnconditionalJump() { none() }
}

class CilBeq_S extends @il_beq_S, CilRelationalBranchInstruction { }

class CilBge_S extends @il_bge_S, CilRelationalBranchInstruction { }

class CilBgt_S extends @il_bgt_S, CilRelationalBranchInstruction { }

class CilBle_S extends @il_ble_S, CilRelationalBranchInstruction { }

class CilBlt_S extends @il_blt_S, CilRelationalBranchInstruction { }

class CilBne_un_S extends @il_bne_un_S, CilRelationalBranchInstruction { }

class CilBge_un_S extends @il_bge_un_S, CilRelationalBranchInstruction { }

class CilBgt_un_S extends @il_bgt_un_S, CilRelationalBranchInstruction { }

class CilBle_un_S extends @il_ble_un_S, CilRelationalBranchInstruction { }

class CilBlt_un_S extends @il_blt_un_S, CilRelationalBranchInstruction { }

class CilBr extends @il_br, CilUnconditionalBranchInstruction { }

class CilBrfalse extends @il_brfalse, CilBooleanBranchFalse { }

class CilBrtrue extends @il_brtrue, CilBooleanBranchTrue { }

class CilBeq extends @il_beq, CilRelationalBranchInstruction { }

class CilBge extends @il_bge, CilRelationalBranchInstruction { }

class CilBgt extends @il_bgt, CilRelationalBranchInstruction { }

class CilBle extends @il_ble, CilRelationalBranchInstruction { }

class CilBlt extends @il_blt, CilRelationalBranchInstruction { }

class CilBne_un extends @il_bne_un, CilRelationalBranchInstruction { }

class CilBge_un extends @il_bge_un, CilRelationalBranchInstruction { }

class CilBgt_un extends @il_bgt_un, CilRelationalBranchInstruction { }

class CilBle_un extends @il_ble_un, CilRelationalBranchInstruction { }

class CilBlt_un extends @il_blt_un, CilRelationalBranchInstruction { }

class CilSwitch extends @il_switch, CilInstruction { }

class CilLdind_I1 extends @il_ldind_I1, CilInstruction { }

class CilLdind_U1 extends @il_ldind_U1, CilInstruction { }

class CilLdind_I2 extends @il_ldind_I2, CilInstruction { }

class CilLdind_U2 extends @il_ldind_U2, CilInstruction { }

class CilLdind_I4 extends @il_ldind_I4, CilInstruction { }

class CilLdind_U4 extends @il_ldind_U4, CilInstruction { }

class CilLdind_I8 extends @il_ldind_I8, CilInstruction { }

class CilLdind_I extends @il_ldind_I, CilInstruction { }

class CilLdind_R4 extends @il_ldind_R4, CilInstruction { }

class CilLdind_R8 extends @il_ldind_R8, CilInstruction { }

class CilLdind_Ref extends @il_ldind_Ref, CilInstruction { }

class CilStind_Ref extends @il_stind_Ref, CilInstruction { }

class CilStind_I1 extends @il_stind_I1, CilInstruction { }

class CilStind_I2 extends @il_stind_I2, CilInstruction { }

class CilStind_I4 extends @il_stind_I4, CilInstruction { }

class CilStind_I8 extends @il_stind_I8, CilInstruction { }

class CilStind_R4 extends @il_stind_R4, CilInstruction { }

class CilStind_R8 extends @il_stind_R8, CilInstruction { }

abstract class CilBinaryInstruction extends CilInstruction { }

abstract class CilArithmeticInstruction extends CilBinaryInstruction { }

abstract class CilAddInstruction extends CilArithmeticInstruction { }

class CilAdd extends @il_add, CilAddInstruction { }

abstract class CilSubInstruction extends CilArithmeticInstruction { }

class CilSub extends @il_sub, CilSubInstruction { }

abstract class CilMulInstruction extends CilArithmeticInstruction { }

class CilMul extends @il_mul, CilMulInstruction { }

abstract class CilDivInstruction extends CilArithmeticInstruction { }

class CilDiv extends @il_div, CilDivInstruction { }

class CilDiv_un extends @il_div_un, CilDivInstruction { }

// TODO: Support rem in the IR
class CilRem extends @il_rem, CilArithmeticInstruction { }

class CilRem_un extends @il_rem_un, CilArithmeticInstruction { }

abstract class CilBitwiseInstruction extends CilBinaryInstruction { }

class CilAnd extends @il_and, CilBitwiseInstruction { }

class CilOr extends @il_or, CilBitwiseInstruction { }

class CilXor extends @il_xor, CilBitwiseInstruction { }

class CilShl extends @il_shl, CilBitwiseInstruction { }

class CilShr extends @il_shr, CilBitwiseInstruction { }

class CilShr_un extends @il_shr_un, CilBitwiseInstruction { }

abstract class CilUnaryInstruction extends CilInstruction { }

class CilNeg extends @il_neg, CilUnaryInstruction { }

class CilNot extends @il_not, CilUnaryInstruction { }

class CilConv_I1 extends @il_conv_I1, CilUnaryInstruction { }

class CilConv_I2 extends @il_conv_I2, CilUnaryInstruction { }

class CilConv_I4 extends @il_conv_I4, CilUnaryInstruction { }

class CilConv_I8 extends @il_conv_I8, CilUnaryInstruction { }

class CilConv_R4 extends @il_conv_R4, CilUnaryInstruction { }

class CilConv_R8 extends @il_conv_R8, CilUnaryInstruction { }

class CilConv_U4 extends @il_conv_U4, CilUnaryInstruction { }

class CilConv_U8 extends @il_conv_U8, CilUnaryInstruction { }

class CilCallvirt extends @il_callvirt, CilCall { }

class CilCpobj extends @il_cpobj, CilInstruction { }

class CilLdobj extends @il_ldobj, CilInstruction { }

class CilLdstr extends @il_ldstr, CilInstruction { }

class CilNewobj extends @il_newobj, CilInstruction { }

class CilCastclass extends @il_castclass, CilInstruction { }

class CilIsinst extends @il_isinst, CilInstruction { }

class CilConv_R_Un extends @il_conv_R_Un, CilInstruction { }

class CilUnbox extends @il_unbox, CilInstruction { }

class CilThrow extends @il_throw, CilInstruction { }

class CilLdfld extends @il_ldfld, CilInstruction { }

class CilLdflda extends @il_ldflda, CilInstruction { }

class CilStfld extends @il_stfld, CilInstruction { }

class CilLdsfld extends @il_ldsfld, CilInstruction { }

class CilLdsflda extends @il_ldsflda, CilInstruction { }

class CilStsfld extends @il_stsfld, CilInstruction { }

class CilStobj extends @il_stobj, CilInstruction { }

class CilConv_ovf_I1_Un extends @il_conv_ovf_I1_Un, CilInstruction { }

class CilConv_ovf_I2_Un extends @il_conv_ovf_I2_Un, CilInstruction { }

class CilConv_ovf_I4_Un extends @il_conv_ovf_I4_Un, CilInstruction { }

class CilConv_ovf_I8_Un extends @il_conv_ovf_I8_Un, CilInstruction { }

class CilConv_ovf_U1_Un extends @il_conv_ovf_U1_Un, CilInstruction { }

class CilConv_ovf_U2_Un extends @il_conv_ovf_U2_Un, CilInstruction { }

class CilConv_ovf_U4_Un extends @il_conv_ovf_U4_Un, CilInstruction { }

class CilConv_ovf_U8_Un extends @il_conv_ovf_U8_Un, CilInstruction { }

class CilConv_ovf_I_Un extends @il_conv_ovf_I_Un, CilInstruction { }

class CilConv_ovf_U_Un extends @il_conv_ovf_U_Un, CilInstruction { }

class CilBox extends @il_box, CilInstruction { }

class CilNewarr extends @il_newarr, CilInstruction { }

class CilLdlen extends @il_ldlen, CilInstruction { }

class CilLdelema extends @il_ldelema, CilInstruction { }

class CilLdelem_I1 extends @il_ldelem_I1, CilInstruction { }

class CilLdelem_U1 extends @il_ldelem_U1, CilInstruction { }

class CilLdelem_I2 extends @il_ldelem_I2, CilInstruction { }

class CilLdelem_U2 extends @il_ldelem_U2, CilInstruction { }

class CilLdelem_I4 extends @il_ldelem_I4, CilInstruction { }

class CilLdelem_U4 extends @il_ldelem_U4, CilInstruction { }

class CilLdelem_I8 extends @il_ldelem_I8, CilInstruction { }

class CilLdelem_I extends @il_ldelem_I, CilInstruction { }

class CilLdelem_R4 extends @il_ldelem_R4, CilInstruction { }

class CilLdelem_R8 extends @il_ldelem_R8, CilInstruction { }

class CilLdelem_Ref extends @il_ldelem_Ref, CilInstruction { }

class CilStelem_I extends @il_stelem_I, CilInstruction { }

class CilStelem_I1 extends @il_stelem_I1, CilInstruction { }

class CilStelem_I2 extends @il_stelem_I2, CilInstruction { }

class CilStelem_I4 extends @il_stelem_I4, CilInstruction { }

class CilStelem_I8 extends @il_stelem_I8, CilInstruction { }

class CilStelem_R4 extends @il_stelem_R4, CilInstruction { }

class CilStelem_R8 extends @il_stelem_R8, CilInstruction { }

class CilStelem_Ref extends @il_stelem_Ref, CilInstruction { }

class CilLdelem extends @il_ldelem, CilInstruction { }

class CilStelem extends @il_stelem, CilInstruction { }

class CilUnbox_any extends @il_unbox_any, CilInstruction { }

class CilConv_ovf_I1 extends @il_conv_ovf_I1, CilInstruction { }

class CilConv_ovf_U1 extends @il_conv_ovf_U1, CilInstruction { }

class CilConv_ovf_I2 extends @il_conv_ovf_I2, CilInstruction { }

class CilConv_ovf_U2 extends @il_conv_ovf_U2, CilInstruction { }

class CilConv_ovf_I4 extends @il_conv_ovf_I4, CilInstruction { }

class CilConv_ovf_U4 extends @il_conv_ovf_U4, CilInstruction { }

class CilConv_ovf_I8 extends @il_conv_ovf_I8, CilInstruction { }

class CilConv_ovf_U8 extends @il_conv_ovf_U8, CilInstruction { }

class CilRefanyval extends @il_refanyval, CilInstruction { }

class CilCkfinite extends @il_ckfinite, CilInstruction { }

class CilMkrefany extends @il_mkrefany, CilInstruction { }

class CilLdtoken extends @il_ldtoken, CilInstruction { }

class CilConv_U2 extends @il_conv_U2, CilInstruction { }

class CilConv_U1 extends @il_conv_U1, CilInstruction { }

class CilConv_I extends @il_conv_I, CilInstruction { }

class CilConv_ovf_I extends @il_conv_ovf_I, CilInstruction { }

class CilConv_ovf_U extends @il_conv_ovf_U, CilInstruction { }

class CilAdd_ovf extends @il_add_ovf, CilAddInstruction { }

class CilAdd_ovf_un extends @il_add_ovf_un, CilAddInstruction { }

class CilMul_ovf extends @il_mul_ovf, CilMulInstruction { }

class CilMul_ovf_un extends @il_mul_ovf_un, CilMulInstruction { }

class CilSub_ovf extends @il_sub_ovf, CilSubInstruction { }

class CilSub_ovf_un extends @il_sub_ovf_un, CilSubInstruction { }

class CilEndfinally extends @il_endfinally, CilInstruction { }

class CilLeave extends @il_leave, CilInstruction { }

class CilLeave_s extends @il_leave_s, CilInstruction { }

class CilStind_i extends @il_stind_i, CilInstruction { }

class CilConv_U extends @il_conv_U, CilInstruction { }

class CilPrefix7 extends @il_prefix7, CilInstruction { }

class CilPrefix6 extends @il_prefix6, CilInstruction { }

class CilPrefix5 extends @il_prefix5, CilInstruction { }

class CilPrefix4 extends @il_prefix4, CilInstruction { }

class CilPrefix3 extends @il_prefix3, CilInstruction { }

class CilPrefix2 extends @il_prefix2, CilInstruction { }

class CilPrefix1 extends @il_prefix1, CilInstruction { }

class CilPrefixref extends @il_prefixref, CilInstruction { }

class CilArglist extends @il_arglist, CilInstruction { }

abstract class CilRelationalInstruction extends CilBinaryInstruction { }

class CilCeq extends @il_ceq, CilRelationalInstruction { }

class CilCgt extends @il_cgt, CilRelationalInstruction { }

class CilCgt_un extends @il_cgt_un, CilRelationalInstruction { }

class CilClt extends @il_clt, CilRelationalInstruction { }

class CilClt_un extends @il_clt_un, CilRelationalInstruction { }

class CilLdftn extends @il_ldftn, CilInstruction { }

class CilLdvirtftn extends @il_ldvirtftn, CilInstruction { }

class CilLdarg extends @il_ldarg, CilInstruction { }

class CilLdarga extends @il_ldarga, CilInstruction { }

class CilStarg extends @il_starg, CilInstruction { }

class CilLdloc extends @il_ldloc, CilLoadLocal {
  override int getLocalVariableIndex() {
    none() // TODO: Extract
  }
}

class CilLdloca extends @il_ldloca, CilInstruction { }

abstract class CilStoreLocal extends CilInstruction {
  abstract int getLocalVariableIndex();

  CilVariable getLocalVariable() {
    result = this.getEnclosingMethod().getVariable(this.getLocalVariableIndex())
  }
}

class CilStloc extends @il_stloc, CilStoreLocal {
  override int getLocalVariableIndex() {
    none() // TODO: Extract
  }
}

class CilLocalloc extends @il_localloc, CilInstruction { }

class CilEndfilter extends @il_endfilter, CilInstruction { }

class CilUnaligned extends @il_unaligned, CilInstruction { }

class CilVolatile extends @il_volatile, CilInstruction { }

class CilTail extends @il_tail, CilInstruction { }

class CilInitobj extends @il_initobj, CilInstruction { }

class CilConstrained extends @il_constrained, CilInstruction { }

class CilCpblk extends @il_cpblk, CilInstruction { }

class CilInitblk extends @il_initblk, CilInstruction { }

class CilRethrow extends @il_rethrow, CilInstruction { }

class CilSizeof extends @il_sizeof, CilInstruction { }

class CilRefanytype extends @il_refanytype, CilInstruction { }

class CilReadonly extends @il_readonly, CilInstruction { }
