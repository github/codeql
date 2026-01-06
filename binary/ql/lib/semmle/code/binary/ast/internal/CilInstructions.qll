private import binary

class CilField extends @field {
  string toString() { result = this.getName() }

  string getName() { fields(this, result, _) }

  CilType getDeclaringType() { fields(this, _, result) }

  Location getLocation() { none() } // TODO: Extract
}

/**
 * A CIL type (class, struct, interface, etc.).
 */
class CilType extends @type {
  string toString() { result = this.getName() }

  /** Gets the full name of this type (e.g., "System.Collections.Generic.List`1"). */
  string getFullName() { types(this, result, _, _) }

  /** Gets the namespace of this type (e.g., "System.Collections.Generic"). */
  string getNamespace() { types(this, _, result, _) }

  /** Gets the simple name of this type (e.g., "List`1"). */
  string getName() { types(this, _, _, result) }

  /** Gets a method declared in this type. */
  CilMethod getAMethod() { result.getDeclaringType() = this }

  /** Gets a field declared by this type. */
  CilField getAField() { result.getDeclaringType() = this }

  Location getLocation() { none() } // TODO: Extract
}

/** A local variable defined in a CIL method body. */
class CilVariable extends @il_local_variable {
  string toString() { result = "local_" + this.getIndex().toString() }

  /** Gets the method that defines this local variable. */
  CilMethod getMethod() { il_local_variable(this, result, _, _) }

  /** Gets the index of this local variable in the method's local variable list. */
  int getIndex() { il_local_variable(this, _, result, _) }

  /** Gets the type name of this local variable. */
  string getTypeName() { il_local_variable(this, _, _, result) }
}

class CilParameter instanceof @il_parameter {
  string toString() { result = this.getName() }

  CilMethod getMethod() { il_parameter(this, result, _, _) }

  int getIndex() { il_parameter(this, _, result, _) }

  string getName() { il_parameter(this, _, _, result) }

  Location getLocation() { none() } // TODO: Extract
}

class CilMethod extends @method {
  string getName() { methods(this, result, _, _) }

  string toString() { result = this.getName() }

  private string getSignature() { methods(this, _, result, _) }

  predicate isVoid() {
    this.getSignature().matches("Void%") // TODO: Don't use string parsing here
  }

  /** Gets the raw ECMA-335 MethodAttributes flags for this method. */
  int getAccessFlags() { cil_method_access_flags(this, result) }

  /** Holds if this method is public. */
  predicate isPublic() {
    // MemberAccessMask is 0x0007, Public is 0x0006
    this.getAccessFlags().bitAnd(7) = 6
  }

  /** Holds if this method is private. */
  predicate isPrivate() {
    // Private is 0x0001
    this.getAccessFlags().bitAnd(7) = 1
  }

  /** Holds if this method is protected (family). */
  predicate isProtected() {
    // Family is 0x0004
    this.getAccessFlags().bitAnd(7) = 4
  }

  /** Holds if this method is internal (assembly). */
  predicate isInternal() {
    // Assembly is 0x0003
    this.getAccessFlags().bitAnd(7) = 3
  }

  /** Holds if this method is static. */
  predicate isStatic() {
    // Static is 0x0010
    this.getAccessFlags().bitAnd(16) != 0
  }

  /** Holds if this method is final (sealed). */
  predicate isFinal() {
    // Final is 0x0020
    this.getAccessFlags().bitAnd(32) != 0
  }

  /** Holds if this method is virtual. */
  predicate isVirtual() {
    // Virtual is 0x0040
    this.getAccessFlags().bitAnd(64) != 0
  }

  /** Holds if this method is abstract. */
  predicate isAbstract() {
    // Abstract is 0x0400
    this.getAccessFlags().bitAnd(1024) != 0
  }

  CilInstruction getAnInstruction() { il_instruction_method(result, this) }

  CilInstruction getInstruction(int i) { il_instruction_parent(result, i, this) }

  /** Gets the local variable at the given index in this method. */
  CilVariable getVariable(int i) {
    result.getMethod() = this and
    result.getIndex() = i
  }

  string getFullyQualifiedName() {
    result = this.getDeclaringType().getFullName() + "." + this.getName()
  }

  CilParameter getParameter(int i) {
    result.getMethod() = this and
    result.getIndex() = i
  }

  CilType getDeclaringType() { methods(this, _, _, result) }

  Location getLocation() { none() } // TODO: Extract
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

class CilLdarg_0 extends @il_ldarg_0, CilLoadArgument {
  override int getArgumentIndex() { result = 0 }
}

class CilLdarg_1 extends @il_ldarg_1, CilLoadArgument {
  override int getArgumentIndex() { result = 1 }
}

class CilLdarg_2 extends @il_ldarg_2, CilLoadArgument {
  override int getArgumentIndex() { result = 2 }
}

class CilLdarg_3 extends @il_ldarg_3, CilLoadArgument {
  override int getArgumentIndex() { result = 3 }
}

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

abstract class CilLoadArgument extends CilInstruction {
  abstract int getArgumentIndex();
}

class CilLdarg_S extends @il_ldarg_S, CilLoadArgument {
  override int getArgumentIndex() { il_operand_byte(this, result) }
}

class CilLdarga_S extends @il_ldarga_S, CilInstruction { }

abstract class CilStoreArgument extends CilInstruction { }

class CilStarg_S extends @il_starg_S, CilStoreArgument { }

class CilLdloc_S extends @il_ldloc_S, CilLoadLocal {
  override int getLocalVariableIndex() { il_operand_local_index(this, result) }
}

abstract class CilLoadLocal extends CilInstruction {
  abstract int getLocalVariableIndex();

  /** Gets the local variable that this instruction loads. */
  CilVariable getLocalVariable() {
    result = this.getEnclosingMethod().getVariable(this.getLocalVariableIndex())
  }
}

abstract class CilLoadAddressOfLocal extends CilInstruction {
  /** Gets the local variable index. */
  int getLocalVariableIndex() { il_operand_local_index(this, result) }

  /** Gets the local variable whose address this instruction loads. */
  CilVariable getLocalVariable() {
    result = this.getEnclosingMethod().getVariable(this.getLocalVariableIndex())
  }
}

class CilLdloca_S extends @il_ldloca_S, CilLoadAddressOfLocal { }

class CilStloc_S extends @il_stloc_S, CilStoreLocal {
  override int getLocalVariableIndex() { il_operand_local_index(this, result) }
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
    exists(float f |
      il_operand_float(this, f) and
      result = f.toString()
    )
  }

  /** Gets the float value loaded by this instruction. */
  float getFloatValue() { il_operand_float(this, result) }

  final override int getSize() { result = 4 } // float32
}

class CilLdc_R8 extends @il_ldc_R8, CilLoadConstant {
  final override string getValue() {
    exists(float d |
      il_operand_double(this, d) and
      result = d.toString()
    )
  }

  /** Gets the double value loaded by this instruction. */
  float getDoubleValue() { il_operand_double(this, result) }

  final override int getSize() { result = 8 } // float64
}

class CilDup extends @il_dup, CilInstruction { }

class CilIl_pop extends @il_il_pop, CilInstruction { }

abstract class CilCallOrNewObject extends CilInstruction {
  final int getNumberOfArguments() { il_number_of_arguments(this, result) }

  final string getExternalName() { il_call_target_unresolved(this, result) }
}

abstract class CilCall extends CilCallOrNewObject {
  final predicate hasReturnValue() { il_call_has_return_value(this) }

  CilMethod getTarget() { result.getFullyQualifiedName() = this.getExternalName() }
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
      this.getEnclosingMethod() = m and
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

/** An instruction that loads a value indirectly through a pointer. */
abstract class CilLoadIndirectInstruction extends CilInstruction { }

class CilLdind_I1 extends @il_ldind_I1, CilLoadIndirectInstruction { }

class CilLdind_U1 extends @il_ldind_U1, CilLoadIndirectInstruction { }

class CilLdind_I2 extends @il_ldind_I2, CilLoadIndirectInstruction { }

class CilLdind_U2 extends @il_ldind_U2, CilLoadIndirectInstruction { }

class CilLdind_I4 extends @il_ldind_I4, CilLoadIndirectInstruction { }

class CilLdind_U4 extends @il_ldind_U4, CilLoadIndirectInstruction { }

class CilLdind_I8 extends @il_ldind_I8, CilLoadIndirectInstruction { }

class CilLdind_I extends @il_ldind_I, CilLoadIndirectInstruction { }

class CilLdind_R4 extends @il_ldind_R4, CilLoadIndirectInstruction { }

class CilLdind_R8 extends @il_ldind_R8, CilLoadIndirectInstruction { }

class CilLdind_Ref extends @il_ldind_Ref, CilLoadIndirectInstruction { }

/** An instruction that stores a value indirectly through a pointer. */
abstract class CilStoreIndirectInstruction extends CilInstruction { }

class CilStind_Ref extends @il_stind_Ref, CilStoreIndirectInstruction { }

class CilStind_I1 extends @il_stind_I1, CilStoreIndirectInstruction { }

class CilStind_I2 extends @il_stind_I2, CilStoreIndirectInstruction { }

class CilStind_I4 extends @il_stind_I4, CilStoreIndirectInstruction { }

class CilStind_I8 extends @il_stind_I8, CilStoreIndirectInstruction { }

class CilStind_R4 extends @il_stind_R4, CilStoreIndirectInstruction { }

class CilStind_R8 extends @il_stind_R8, CilStoreIndirectInstruction { }

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

/** An instruction that converts a value from one type to another. */
abstract class CilConversionInstruction extends CilUnaryInstruction { }

class CilConv_I1 extends @il_conv_I1, CilConversionInstruction { }

class CilConv_I2 extends @il_conv_I2, CilConversionInstruction { }

class CilConv_I4 extends @il_conv_I4, CilConversionInstruction { }

class CilConv_I8 extends @il_conv_I8, CilConversionInstruction { }

class CilConv_R4 extends @il_conv_R4, CilConversionInstruction { }

class CilConv_R8 extends @il_conv_R8, CilConversionInstruction { }

class CilConv_U4 extends @il_conv_U4, CilConversionInstruction { }

class CilConv_U8 extends @il_conv_U8, CilConversionInstruction { }

class CilCallvirt extends @il_callvirt, CilCall { }

class CilCpobj extends @il_cpobj, CilInstruction { }

class CilLdobj extends @il_ldobj, CilInstruction { }

class CilLdstr extends @il_ldstr, CilInstruction {
  string getValue() { il_operand_string(this, result) }
}

class CilNewobj extends @il_newobj, CilCallOrNewObject {
  /** ... If it exists. */
  CilMethod getConstructor() { result.getFullyQualifiedName() = this.getExternalName() }
}

class CilCastclass extends @il_castclass, CilInstruction { }

class CilIsinst extends @il_isinst, CilInstruction { }

class CilConv_R_Un extends @il_conv_R_Un, CilConversionInstruction { }

class CilUnbox extends @il_unbox, CilInstruction { }

class CilThrow extends @il_throw, CilInstruction { }

/** An instruction that loads a field value. */
abstract class CilLoadFieldInstruction extends CilInstruction {
  CilField getField() {
    exists(string declaringTypeName, string fieldName |
      il_field_operand(this, declaringTypeName, fieldName) and
      fieldHasDeclaringTypeNameAndName(declaringTypeName, fieldName, result)
    )
  }

  predicate isStatic() { none() }

  predicate onlyComputesAddress() { none() }
}

/** An instruction that loads an instance field value. */
class CilLdfld extends @il_ldfld, CilLoadFieldInstruction { }

/** An instruction that loads the address of an instance field. */
class CilLdflda extends @il_ldflda, CilLoadFieldInstruction {
  final override predicate onlyComputesAddress() { any() }
}

/** An instruction that loads a static field value. */
class CilLdsfld extends @il_ldsfld, CilLoadFieldInstruction {
  final override predicate isStatic() { any() }
}

/** An instruction that loads the address of a static field. */
class CilLdsflda extends @il_ldsflda, CilLoadFieldInstruction {
  final override predicate isStatic() { any() }

  final override predicate onlyComputesAddress() { any() }
}

pragma[nomagic]
private predicate fieldHasDeclaringTypeNameAndName(
  string declaringTypeName, string fieldName, CilField f
) {
  f.getDeclaringType().getFullName() = declaringTypeName and
  f.getName() = fieldName
}

/** An instruction that stores a value to a field. */
abstract class CilStoreFieldInstruction extends CilInstruction {
  CilField getField() {
    exists(string declaringTypeName, string fieldName |
      il_field_operand(this, declaringTypeName, fieldName) and
      fieldHasDeclaringTypeNameAndName(declaringTypeName, fieldName, result)
    )
  }

  predicate isStatic() { none() }
}

/** An instruction that stores a value to an instance field. */
class CilStfld extends @il_stfld, CilStoreFieldInstruction { }

/** An instruction that stores a value to a static field. */
class CilStsfld extends @il_stsfld, CilStoreFieldInstruction {
  final override predicate isStatic() { any() }
}

class CilStobj extends @il_stobj, CilInstruction { }

class CilConv_ovf_I1_Un extends @il_conv_ovf_I1_Un, CilConversionInstruction { }

class CilConv_ovf_I2_Un extends @il_conv_ovf_I2_Un, CilConversionInstruction { }

class CilConv_ovf_I4_Un extends @il_conv_ovf_I4_Un, CilConversionInstruction { }

class CilConv_ovf_I8_Un extends @il_conv_ovf_I8_Un, CilConversionInstruction { }

class CilConv_ovf_U1_Un extends @il_conv_ovf_U1_Un, CilConversionInstruction { }

class CilConv_ovf_U2_Un extends @il_conv_ovf_U2_Un, CilConversionInstruction { }

class CilConv_ovf_U4_Un extends @il_conv_ovf_U4_Un, CilConversionInstruction { }

class CilConv_ovf_U8_Un extends @il_conv_ovf_U8_Un, CilConversionInstruction { }

class CilConv_ovf_I_Un extends @il_conv_ovf_I_Un, CilConversionInstruction { }

class CilConv_ovf_U_Un extends @il_conv_ovf_U_Un, CilConversionInstruction { }

class CilBox extends @il_box, CilInstruction { }

class CilNewarr extends @il_newarr, CilInstruction { }

class CilLdlen extends @il_ldlen, CilInstruction { }

class CilLdelema extends @il_ldelema, CilInstruction { }

/** An instruction that loads an element from an array. */
abstract class CilLoadElementInstruction extends CilInstruction { }

class CilLdelem_I1 extends @il_ldelem_I1, CilLoadElementInstruction { }

class CilLdelem_U1 extends @il_ldelem_U1, CilLoadElementInstruction { }

class CilLdelem_I2 extends @il_ldelem_I2, CilLoadElementInstruction { }

class CilLdelem_U2 extends @il_ldelem_U2, CilLoadElementInstruction { }

class CilLdelem_I4 extends @il_ldelem_I4, CilLoadElementInstruction { }

class CilLdelem_U4 extends @il_ldelem_U4, CilLoadElementInstruction { }

class CilLdelem_I8 extends @il_ldelem_I8, CilLoadElementInstruction { }

class CilLdelem_I extends @il_ldelem_I, CilLoadElementInstruction { }

class CilLdelem_R4 extends @il_ldelem_R4, CilLoadElementInstruction { }

class CilLdelem_R8 extends @il_ldelem_R8, CilLoadElementInstruction { }

class CilLdelem_Ref extends @il_ldelem_Ref, CilLoadElementInstruction { }

/** An instruction that stores an element to an array. */
abstract class CilStoreElementInstruction extends CilInstruction { }

class CilStelem_I extends @il_stelem_I, CilStoreElementInstruction { }

class CilStelem_I1 extends @il_stelem_I1, CilStoreElementInstruction { }

class CilStelem_I2 extends @il_stelem_I2, CilStoreElementInstruction { }

class CilStelem_I4 extends @il_stelem_I4, CilStoreElementInstruction { }

class CilStelem_I8 extends @il_stelem_I8, CilStoreElementInstruction { }

class CilStelem_R4 extends @il_stelem_R4, CilStoreElementInstruction { }

class CilStelem_R8 extends @il_stelem_R8, CilStoreElementInstruction { }

class CilStelem_Ref extends @il_stelem_Ref, CilStoreElementInstruction { }

class CilLdelem extends @il_ldelem, CilLoadElementInstruction { }

class CilStelem extends @il_stelem, CilStoreElementInstruction { }

class CilUnbox_any extends @il_unbox_any, CilInstruction { }

class CilConv_ovf_I1 extends @il_conv_ovf_I1, CilConversionInstruction { }

class CilConv_ovf_U1 extends @il_conv_ovf_U1, CilConversionInstruction { }

class CilConv_ovf_I2 extends @il_conv_ovf_I2, CilConversionInstruction { }

class CilConv_ovf_U2 extends @il_conv_ovf_U2, CilConversionInstruction { }

class CilConv_ovf_I4 extends @il_conv_ovf_I4, CilConversionInstruction { }

class CilConv_ovf_U4 extends @il_conv_ovf_U4, CilConversionInstruction { }

class CilConv_ovf_I8 extends @il_conv_ovf_I8, CilConversionInstruction { }

class CilConv_ovf_U8 extends @il_conv_ovf_U8, CilConversionInstruction { }

class CilRefanyval extends @il_refanyval, CilInstruction { }

class CilCkfinite extends @il_ckfinite, CilInstruction { }

class CilMkrefany extends @il_mkrefany, CilInstruction { }

class CilLdtoken extends @il_ldtoken, CilInstruction { }

class CilConv_U2 extends @il_conv_U2, CilConversionInstruction { }

class CilConv_U1 extends @il_conv_U1, CilConversionInstruction { }

class CilConv_I extends @il_conv_I, CilConversionInstruction { }

class CilConv_ovf_I extends @il_conv_ovf_I, CilConversionInstruction { }

class CilConv_ovf_U extends @il_conv_ovf_U, CilConversionInstruction { }

class CilAdd_ovf extends @il_add_ovf, CilAddInstruction { }

class CilAdd_ovf_un extends @il_add_ovf_un, CilAddInstruction { }

class CilMul_ovf extends @il_mul_ovf, CilMulInstruction { }

class CilMul_ovf_un extends @il_mul_ovf_un, CilMulInstruction { }

class CilSub_ovf extends @il_sub_ovf, CilSubInstruction { }

class CilSub_ovf_un extends @il_sub_ovf_un, CilSubInstruction { }

class CilEndfinally extends @il_endfinally, CilInstruction { }

class CilLeave extends @il_leave, CilInstruction { }

class CilLeave_s extends @il_leave_s, CilInstruction { }

class CilStind_i extends @il_stind_i, CilStoreIndirectInstruction { }

class CilConv_U extends @il_conv_U, CilConversionInstruction { }

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

class CilLdarg extends @il_ldarg, CilLoadArgument {
  override int getArgumentIndex() { il_operand_int(this, result) }
}

class CilLdarga extends @il_ldarga, CilInstruction { }

class CilStarg extends @il_starg, CilInstruction { }

class CilLdloc extends @il_ldloc, CilLoadLocal {
  override int getLocalVariableIndex() { il_operand_local_index(this, result) }
}

class CilLdloca extends @il_ldloca, CilLoadAddressOfLocal { }

abstract class CilStoreLocal extends CilInstruction {
  abstract int getLocalVariableIndex();

  CilVariable getLocalVariable() {
    result = this.getEnclosingMethod().getVariable(this.getLocalVariableIndex())
  }
}

class CilStloc extends @il_stloc, CilStoreLocal {
  override int getLocalVariableIndex() { il_operand_local_index(this, result) }
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
