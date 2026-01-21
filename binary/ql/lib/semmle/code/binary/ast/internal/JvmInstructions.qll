private import binary

/**
 * A JVM field.
 */
class JvmField extends @field {
  string toString() { result = this.getName() }

  string getName() { fields(this, result, _) }

  JvmType getDeclaringType() { fields(this, _, result) }

  Location getLocation() { none() }
}

/**
 * A JVM type (class, interface, enum, etc.).
 */
class JvmType extends @type {
  string toString() { result = this.getName() }

  /** Gets the full name of this type (e.g., "java.lang.String"). */
  string getFullName() { types(this, result, _, _) }

  /** Gets the package name of this type (e.g., "java.lang"). */
  string getPackage() { types(this, _, result, _) }

  /** Gets the simple name of this type (e.g., "String"). */
  string getName() { types(this, _, _, result) }

  /** Gets a method declared in this type. */
  JvmMethod getAMethod() { result.getDeclaringType() = this }

  /** Gets a field declared by this type. */
  JvmField getAField() { result.getDeclaringType() = this }

  Location getLocation() { none() }
}

/**
 * A JVM method parameter.
 */
class JvmParameter instanceof @jvm_parameter {
  string toString() { result = this.getName() }

  JvmMethod getMethod() { jvm_parameter(this, result, _, _, _) }

  int getSlotIndex() { jvm_parameter(this, _, result, _, _) }

  string getName() { jvm_parameter(this, _, _, result, _) }

  string getDescriptor() { jvm_parameter(this, _, _, _, result) }

  Location getLocation() { none() }
}

/**
 * A JVM method.
 */
class JvmMethod extends @method {
  string getName() { methods(this, result, _, _) }

  string toString() { result = this.getName() }

  private string getSignature() { methods(this, _, result, _) }

  predicate isVoid() { this.getSignature().matches("%)V") }

  JvmInstruction getAnInstruction() { jvm_instruction_method(result, this) }

  JvmInstruction getInstruction(int i) { jvm_instruction_parent(result, i, this) }

  string getFullyQualifiedName() {
    result = this.getDeclaringType().getFullName() + "." + this.getName()
  }

  JvmParameter getParameter(int i) {
    result.getMethod() = this and
    result.getSlotIndex() = i
  }

  JvmType getDeclaringType() { methods(this, _, _, result) }

  Location getLocation() { none() }

  /** Gets the raw JVM access flags bitmask for this method. */
  int getAccessFlags() { jvm_method_access_flags(this, result) }

  /** Holds if this method is public. */
  predicate isPublic() { this.getAccessFlags().bitAnd(1) != 0 }

  /** Holds if this method is private. */
  predicate isPrivate() { this.getAccessFlags().bitAnd(2) != 0 }

  /** Holds if this method is protected. */
  predicate isProtected() { this.getAccessFlags().bitAnd(4) != 0 }

  /** Holds if this method is static. */
  predicate isStatic() { this.getAccessFlags().bitAnd(8) != 0 }

  /** Holds if this method is final. */
  predicate isFinal() { this.getAccessFlags().bitAnd(16) != 0 }

  /** Holds if this method is synchronized. */
  predicate isSynchronized() { this.getAccessFlags().bitAnd(32) != 0 }

  /** Holds if this method is a bridge method. */
  predicate isBridge() { this.getAccessFlags().bitAnd(64) != 0 }

  /** Holds if this method accepts variable arguments. */
  predicate isVarArgs() { this.getAccessFlags().bitAnd(128) != 0 }

  /** Holds if this method is native. */
  predicate isNative() { this.getAccessFlags().bitAnd(256) != 0 }

  /** Holds if this method is abstract. */
  predicate isAbstract() { this.getAccessFlags().bitAnd(1024) != 0 }

  /** Holds if this method uses strict floating-point. */
  predicate isStrict() { this.getAccessFlags().bitAnd(2048) != 0 }

  /** Holds if this method is synthetic (compiler-generated). */
  predicate isSynthetic() { this.getAccessFlags().bitAnd(4096) != 0 }
}

pragma[nomagic]
private predicate hasMethodAndOffset(JvmMethod m, int offset, JvmInstruction instr) {
  instr.getEnclosingMethod() = m and
  instr.getOffset() = offset
}

pragma[nomagic]
private predicate hasMethodAndIndex(JvmMethod m, int index, JvmInstruction instr) {
  m.getInstruction(index) = instr
}

private predicate isBackEdge(JvmInstruction instr1, JvmInstruction instr2) {
  exists(JvmMethod m, int index1, int index2 |
    m.getInstruction(index1) = instr1 and
    m.getInstruction(index2) = instr2 and
    instr1.getASuccessor() = instr2 and
    index2 < index1
  )
}

/**
 * A JVM bytecode instruction.
 */
class JvmInstruction extends @jvm_instruction {
  string toString() { result = this.getMnemonic() + " (offset: " + this.getOffset() + ")" }

  Location getLocation() { none() }

  JvmMethod getEnclosingMethod() { result.getAnInstruction() = this }

  int getOffset() { jvm_instruction(this, result, _) }

  int getOpcode() { jvm_instruction(this, _, result) }

  string getMnemonic() { result = opcodeToMnemonic(this.getOpcode()) }

  JvmInstruction getAPredecessor() { result.getASuccessor() = this }

  JvmInstruction getABackwardPredecessor() { result.getAForwardSuccessor() = this }

  JvmInstruction getASuccessor() {
    exists(int offset, JvmMethod m |
      hasMethodAndIndex(m, offset, this) and
      hasMethodAndIndex(m, offset + 1, result)
    )
  }

  final JvmInstruction getAForwardSuccessor() {
    result = this.getASuccessor() and not isBackEdge(this, result)
  }
}

/**
 * Converts a JVM opcode number to its mnemonic name.
 */
private string opcodeToMnemonic0(int opcode) {
  opcode = 0 and result = "nop"
  or
  opcode = 1 and result = "aconst_null"
  or
  opcode = 2 and result = "iconst_m1"
  or
  opcode = 3 and result = "iconst_0"
  or
  opcode = 4 and result = "iconst_1"
  or
  opcode = 5 and result = "iconst_2"
  or
  opcode = 6 and result = "iconst_3"
  or
  opcode = 7 and result = "iconst_4"
  or
  opcode = 8 and result = "iconst_5"
  or
  opcode = 9 and result = "lconst_0"
  or
  opcode = 10 and result = "lconst_1"
  or
  opcode = 11 and result = "fconst_0"
  or
  opcode = 12 and result = "fconst_1"
  or
  opcode = 13 and result = "fconst_2"
  or
  opcode = 14 and result = "dconst_0"
  or
  opcode = 15 and result = "dconst_1"
  or
  opcode = 16 and result = "bipush"
  or
  opcode = 17 and result = "sipush"
  or
  opcode = 18 and result = "ldc"
  or
  opcode = 19 and result = "ldc_w"
  or
  opcode = 20 and result = "ldc2_w"
  or
  opcode = 21 and result = "iload"
  or
  opcode = 22 and result = "lload"
  or
  opcode = 23 and result = "fload"
  or
  opcode = 24 and result = "dload"
  or
  opcode = 25 and result = "aload"
  or
  opcode = 26 and result = "iload_0"
  or
  opcode = 27 and result = "iload_1"
  or
  opcode = 28 and result = "iload_2"
  or
  opcode = 29 and result = "iload_3"
  or
  opcode = 30 and result = "lload_0"
  or
  opcode = 31 and result = "lload_1"
  or
  opcode = 32 and result = "lload_2"
  or
  opcode = 33 and result = "lload_3"
  or
  opcode = 34 and result = "fload_0"
  or
  opcode = 35 and result = "fload_1"
  or
  opcode = 36 and result = "fload_2"
  or
  opcode = 37 and result = "fload_3"
  or
  opcode = 38 and result = "dload_0"
  or
  opcode = 39 and result = "dload_1"
  or
  opcode = 40 and result = "dload_2"
  or
  opcode = 41 and result = "dload_3"
  or
  opcode = 42 and result = "aload_0"
  or
  opcode = 43 and result = "aload_1"
  or
  opcode = 44 and result = "aload_2"
  or
  opcode = 45 and result = "aload_3"
  or
  opcode = 46 and result = "iaload"
  or
  opcode = 47 and result = "laload"
  or
  opcode = 48 and result = "faload"
  or
  opcode = 49 and result = "daload"
  or
  opcode = 50 and result = "aaload"
  or
  opcode = 51 and result = "baload"
  or
  opcode = 52 and result = "caload"
  or
  opcode = 53 and result = "saload"
  or
  opcode = 54 and result = "istore"
  or
  opcode = 55 and result = "lstore"
  or
  opcode = 56 and result = "fstore"
  or
  opcode = 57 and result = "dstore"
  or
  opcode = 58 and result = "astore"
  or
  opcode = 59 and result = "istore_0"
  or
  opcode = 60 and result = "istore_1"
  or
  opcode = 61 and result = "istore_2"
  or
  opcode = 62 and result = "istore_3"
  or
  opcode = 63 and result = "lstore_0"
  or
  opcode = 64 and result = "lstore_1"
  or
  opcode = 65 and result = "lstore_2"
  or
  opcode = 66 and result = "lstore_3"
  or
  opcode = 67 and result = "fstore_0"
  or
  opcode = 68 and result = "fstore_1"
  or
  opcode = 69 and result = "fstore_2"
  or
  opcode = 70 and result = "fstore_3"
  or
  opcode = 71 and result = "dstore_0"
  or
  opcode = 72 and result = "dstore_1"
  or
  opcode = 73 and result = "dstore_2"
  or
  opcode = 74 and result = "dstore_3"
  or
  opcode = 75 and result = "astore_0"
  or
  opcode = 76 and result = "astore_1"
  or
  opcode = 77 and result = "astore_2"
  or
  opcode = 78 and result = "astore_3"
  or
  opcode = 79 and result = "iastore"
  or
  opcode = 80 and result = "lastore"
  or
  opcode = 81 and result = "fastore"
  or
  opcode = 82 and result = "dastore"
  or
  opcode = 83 and result = "aastore"
  or
  opcode = 84 and result = "bastore"
  or
  opcode = 85 and result = "castore"
  or
  opcode = 86 and result = "sastore"
  or
  opcode = 87 and result = "pop"
  or
  opcode = 88 and result = "pop2"
  or
  opcode = 89 and result = "dup"
  or
  opcode = 90 and result = "dup_x1"
  or
  opcode = 91 and result = "dup_x2"
  or
  opcode = 92 and result = "dup2"
  or
  opcode = 93 and result = "dup2_x1"
  or
  opcode = 94 and result = "dup2_x2"
  or
  opcode = 95 and result = "swap"
  or
  opcode = 96 and result = "iadd"
  or
  opcode = 97 and result = "ladd"
  or
  opcode = 98 and result = "fadd"
  or
  opcode = 99 and result = "dadd"
  or
  opcode = 100 and result = "isub"
  or
  opcode = 101 and result = "lsub"
  or
  opcode = 102 and result = "fsub"
  or
  opcode = 103 and result = "dsub"
  or
  opcode = 104 and result = "imul"
  or
  opcode = 105 and result = "lmul"
  or
  opcode = 106 and result = "fmul"
  or
  opcode = 107 and result = "dmul"
  or
  opcode = 108 and result = "idiv"
  or
  opcode = 109 and result = "ldiv"
  or
  opcode = 110 and result = "fdiv"
  or
  opcode = 111 and result = "ddiv"
  or
  opcode = 112 and result = "irem"
  or
  opcode = 113 and result = "lrem"
  or
  opcode = 114 and result = "frem"
  or
  opcode = 115 and result = "drem"
  or
  opcode = 116 and result = "ineg"
  or
  opcode = 117 and result = "lneg"
  or
  opcode = 118 and result = "fneg"
  or
  opcode = 119 and result = "dneg"
  or
  opcode = 120 and result = "ishl"
  or
  opcode = 121 and result = "lshl"
  or
  opcode = 122 and result = "ishr"
  or
  opcode = 123 and result = "lshr"
  or
  opcode = 124 and result = "iushr"
  or
  opcode = 125 and result = "lushr"
  or
  opcode = 126 and result = "iand"
  or
  opcode = 127 and result = "land"
  or
  opcode = 128 and result = "ior"
  or
  opcode = 129 and result = "lor"
  or
  opcode = 130 and result = "ixor"
  or
  opcode = 131 and result = "lxor"
  or
  opcode = 132 and result = "iinc"
  or
  opcode = 133 and result = "i2l"
  or
  opcode = 134 and result = "i2f"
  or
  opcode = 135 and result = "i2d"
  or
  opcode = 136 and result = "l2i"
  or
  opcode = 137 and result = "l2f"
  or
  opcode = 138 and result = "l2d"
  or
  opcode = 139 and result = "f2i"
  or
  opcode = 140 and result = "f2l"
  or
  opcode = 141 and result = "f2d"
  or
  opcode = 142 and result = "d2i"
  or
  opcode = 143 and result = "d2l"
  or
  opcode = 144 and result = "d2f"
  or
  opcode = 145 and result = "i2b"
  or
  opcode = 146 and result = "i2c"
  or
  opcode = 147 and result = "i2s"
  or
  opcode = 148 and result = "lcmp"
  or
  opcode = 149 and result = "fcmpl"
  or
  opcode = 150 and result = "fcmpg"
  or
  opcode = 151 and result = "dcmpl"
  or
  opcode = 152 and result = "dcmpg"
  or
  opcode = 153 and result = "ifeq"
  or
  opcode = 154 and result = "ifne"
  or
  opcode = 155 and result = "iflt"
  or
  opcode = 156 and result = "ifge"
  or
  opcode = 157 and result = "ifgt"
  or
  opcode = 158 and result = "ifle"
  or
  opcode = 159 and result = "if_icmpeq"
  or
  opcode = 160 and result = "if_icmpne"
  or
  opcode = 161 and result = "if_icmplt"
  or
  opcode = 162 and result = "if_icmpge"
  or
  opcode = 163 and result = "if_icmpgt"
  or
  opcode = 164 and result = "if_icmple"
  or
  opcode = 165 and result = "if_acmpeq"
  or
  opcode = 166 and result = "if_acmpne"
  or
  opcode = 167 and result = "goto"
  or
  opcode = 168 and result = "jsr"
  or
  opcode = 169 and result = "ret"
  or
  opcode = 170 and result = "tableswitch"
  or
  opcode = 171 and result = "lookupswitch"
  or
  opcode = 172 and result = "ireturn"
  or
  opcode = 173 and result = "lreturn"
  or
  opcode = 174 and result = "freturn"
  or
  opcode = 175 and result = "dreturn"
  or
  opcode = 176 and result = "areturn"
  or
  opcode = 177 and result = "return"
  or
  opcode = 178 and result = "getstatic"
  or
  opcode = 179 and result = "putstatic"
  or
  opcode = 180 and result = "getfield"
  or
  opcode = 181 and result = "putfield"
  or
  opcode = 182 and result = "invokevirtual"
  or
  opcode = 183 and result = "invokespecial"
  or
  opcode = 184 and result = "invokestatic"
  or
  opcode = 185 and result = "invokeinterface"
  or
  opcode = 186 and result = "invokedynamic"
  or
  opcode = 187 and result = "new"
  or
  opcode = 188 and result = "newarray"
  or
  opcode = 189 and result = "anewarray"
  or
  opcode = 190 and result = "arraylength"
  or
  opcode = 191 and result = "athrow"
  or
  opcode = 192 and result = "checkcast"
  or
  opcode = 193 and result = "instanceof"
  or
  opcode = 194 and result = "monitorenter"
  or
  opcode = 195 and result = "monitorexit"
  or
  opcode = 196 and result = "wide"
  or
  opcode = 197 and result = "multianewarray"
  or
  opcode = 198 and result = "ifnull"
  or
  opcode = 199 and result = "ifnonnull"
  or
  opcode = 200 and result = "goto_w"
  or
  opcode = 201 and result = "jsr_w"
}

bindingset[opcode]
private string opcodeToMnemonic(int opcode) {
  result = opcodeToMnemonic0(opcode)
  or
  not exists(opcodeToMnemonic0(opcode)) and
  result = "unknown_" + opcode.toString()
}

// ============================================================================
// Instruction Categories
// ============================================================================
/** A no-operation instruction. */
class JvmNop extends @jvm_nop, JvmInstruction { }

/** Pushes null onto the stack. */
class JvmAconstNull extends @jvm_aconst_null, JvmLoadConstant { }

// Load local variable instructions (abstract base classes)
/** An instruction that loads a local variable onto the stack. */
abstract class JvmLoadLocal extends JvmInstruction {
  abstract int getLocalVariableIndex();
}

/** An instruction that stores a value into a local variable. */
abstract class JvmStoreLocal extends JvmInstruction {
  abstract int getLocalVariableIndex();
}

// iload variants
class JvmIload extends @jvm_iload, JvmLoadLocal {
  override int getLocalVariableIndex() { jvm_operand_local_index(this, result) }
}

class JvmIload0 extends @jvm_iload_0, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 0 }
}

class JvmIload1 extends @jvm_iload_1, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 1 }
}

class JvmIload2 extends @jvm_iload_2, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 2 }
}

class JvmIload3 extends @jvm_iload_3, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 3 }
}

// lload variants
class JvmLload extends @jvm_lload, JvmLoadLocal {
  override int getLocalVariableIndex() { jvm_operand_local_index(this, result) }
}

class JvmLload0 extends @jvm_lload_0, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 0 }
}

class JvmLload1 extends @jvm_lload_1, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 1 }
}

class JvmLload2 extends @jvm_lload_2, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 2 }
}

class JvmLload3 extends @jvm_lload_3, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 3 }
}

// fload variants
class JvmFload extends @jvm_fload, JvmLoadLocal {
  override int getLocalVariableIndex() { jvm_operand_local_index(this, result) }
}

class JvmFload0 extends @jvm_fload_0, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 0 }
}

class JvmFload1 extends @jvm_fload_1, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 1 }
}

class JvmFload2 extends @jvm_fload_2, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 2 }
}

class JvmFload3 extends @jvm_fload_3, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 3 }
}

// dload variants
class JvmDload extends @jvm_dload, JvmLoadLocal {
  override int getLocalVariableIndex() { jvm_operand_local_index(this, result) }
}

class JvmDload0 extends @jvm_dload_0, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 0 }
}

class JvmDload1 extends @jvm_dload_1, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 1 }
}

class JvmDload2 extends @jvm_dload_2, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 2 }
}

class JvmDload3 extends @jvm_dload_3, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 3 }
}

// aload variants
class JvmAload extends @jvm_aload, JvmLoadLocal {
  override int getLocalVariableIndex() { jvm_operand_local_index(this, result) }
}

class JvmAload0 extends @jvm_aload_0, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 0 }
}

class JvmAload1 extends @jvm_aload_1, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 1 }
}

class JvmAload2 extends @jvm_aload_2, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 2 }
}

class JvmAload3 extends @jvm_aload_3, JvmLoadLocal {
  override int getLocalVariableIndex() { result = 3 }
}

// istore variants
class JvmIstore extends @jvm_istore, JvmStoreLocal {
  override int getLocalVariableIndex() { jvm_operand_local_index(this, result) }
}

class JvmIstore0 extends @jvm_istore_0, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 0 }
}

class JvmIstore1 extends @jvm_istore_1, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 1 }
}

class JvmIstore2 extends @jvm_istore_2, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 2 }
}

class JvmIstore3 extends @jvm_istore_3, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 3 }
}

// lstore variants
class JvmLstore extends @jvm_lstore, JvmStoreLocal {
  override int getLocalVariableIndex() { jvm_operand_local_index(this, result) }
}

class JvmLstore0 extends @jvm_lstore_0, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 0 }
}

class JvmLstore1 extends @jvm_lstore_1, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 1 }
}

class JvmLstore2 extends @jvm_lstore_2, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 2 }
}

class JvmLstore3 extends @jvm_lstore_3, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 3 }
}

// fstore variants
class JvmFstore extends @jvm_fstore, JvmStoreLocal {
  override int getLocalVariableIndex() { jvm_operand_local_index(this, result) }
}

class JvmFstore0 extends @jvm_fstore_0, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 0 }
}

class JvmFstore1 extends @jvm_fstore_1, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 1 }
}

class JvmFstore2 extends @jvm_fstore_2, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 2 }
}

class JvmFstore3 extends @jvm_fstore_3, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 3 }
}

// dstore variants
class JvmDstore extends @jvm_dstore, JvmStoreLocal {
  override int getLocalVariableIndex() { jvm_operand_local_index(this, result) }
}

class JvmDstore0 extends @jvm_dstore_0, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 0 }
}

class JvmDstore1 extends @jvm_dstore_1, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 1 }
}

class JvmDstore2 extends @jvm_dstore_2, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 2 }
}

class JvmDstore3 extends @jvm_dstore_3, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 3 }
}

// astore variants
class JvmAstore extends @jvm_astore, JvmStoreLocal {
  override int getLocalVariableIndex() { jvm_operand_local_index(this, result) }
}

class JvmAstore0 extends @jvm_astore_0, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 0 }
}

class JvmAstore1 extends @jvm_astore_1, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 1 }
}

class JvmAstore2 extends @jvm_astore_2, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 2 }
}

class JvmAstore3 extends @jvm_astore_3, JvmStoreLocal {
  override int getLocalVariableIndex() { result = 3 }
}

// Array load instructions (abstract base)
/** An instruction that loads an element from an array onto the stack. */
abstract class JvmArrayLoad extends JvmInstruction { }

class JvmIaload extends @jvm_iaload, JvmArrayLoad { }

class JvmLaload extends @jvm_laload, JvmArrayLoad { }

class JvmFaload extends @jvm_faload, JvmArrayLoad { }

class JvmDaload extends @jvm_daload, JvmArrayLoad { }

class JvmAaload extends @jvm_aaload, JvmArrayLoad { }

class JvmBaload extends @jvm_baload, JvmArrayLoad { }

class JvmCaload extends @jvm_caload, JvmArrayLoad { }

class JvmSaload extends @jvm_saload, JvmArrayLoad { }

// Array store instructions (abstract base)
/** An instruction that stores a value into an array element. */
abstract class JvmArrayStore extends JvmInstruction { }

class JvmIastore extends @jvm_iastore, JvmArrayStore { }

class JvmLastore extends @jvm_lastore, JvmArrayStore { }

class JvmFastore extends @jvm_fastore, JvmArrayStore { }

class JvmDastore extends @jvm_dastore, JvmArrayStore { }

class JvmAastore extends @jvm_aastore, JvmArrayStore { }

class JvmBastore extends @jvm_bastore, JvmArrayStore { }

class JvmCastore extends @jvm_castore, JvmArrayStore { }

class JvmSastore extends @jvm_sastore, JvmArrayStore { }

// Stack manipulation (abstract bases)
/** An instruction that pops values from the stack without using them. */
abstract class JvmPopInstruction extends JvmInstruction { }

/** An instruction that duplicates values on the stack. */
abstract class JvmDupInstruction extends JvmInstruction { }

class JvmPop extends @jvm_pop, JvmPopInstruction { }

class JvmPop2 extends @jvm_pop2, JvmPopInstruction { }

class JvmDup extends @jvm_dup, JvmDupInstruction { }

class JvmDupX1 extends @jvm_dup_x1, JvmDupInstruction { }

class JvmDupX2 extends @jvm_dup_x2, JvmDupInstruction { }

class JvmDup2 extends @jvm_dup2, JvmDupInstruction { }

class JvmDup2X1 extends @jvm_dup2_x1, JvmDupInstruction { }

class JvmDup2X2 extends @jvm_dup2_x2, JvmDupInstruction { }

class JvmSwap extends @jvm_swap, JvmInstruction { }

// Arithmetic (abstract hierarchy)
/** An instruction that performs a binary operation on two stack operands. */
abstract class JvmBinaryInstruction extends JvmInstruction { }

/** An instruction that performs a unary operation on one stack operand. */
abstract class JvmUnaryInstruction extends JvmInstruction { }

/** An arithmetic instruction (add, sub, mul, div, rem). */
abstract class JvmArithmeticInstruction extends JvmBinaryInstruction { }

/** An addition instruction. */
abstract class JvmAddInstruction extends JvmArithmeticInstruction { }

/** A subtraction instruction. */
abstract class JvmSubInstruction extends JvmArithmeticInstruction { }

/** A multiplication instruction. */
abstract class JvmMulInstruction extends JvmArithmeticInstruction { }

/** A division instruction. */
abstract class JvmDivInstruction extends JvmArithmeticInstruction { }

/** A remainder instruction. */
abstract class JvmRemInstruction extends JvmArithmeticInstruction { }

/** A negation instruction. */
abstract class JvmNegInstruction extends JvmUnaryInstruction { }

class JvmIadd extends @jvm_iadd, JvmAddInstruction { }

class JvmLadd extends @jvm_ladd, JvmAddInstruction { }

class JvmFadd extends @jvm_fadd, JvmAddInstruction { }

class JvmDadd extends @jvm_dadd, JvmAddInstruction { }

class JvmIsub extends @jvm_isub, JvmSubInstruction { }

class JvmLsub extends @jvm_lsub, JvmSubInstruction { }

class JvmFsub extends @jvm_fsub, JvmSubInstruction { }

class JvmDsub extends @jvm_dsub, JvmSubInstruction { }

class JvmImul extends @jvm_imul, JvmMulInstruction { }

class JvmLmul extends @jvm_lmul, JvmMulInstruction { }

class JvmFmul extends @jvm_fmul, JvmMulInstruction { }

class JvmDmul extends @jvm_dmul, JvmMulInstruction { }

class JvmIdiv extends @jvm_idiv, JvmDivInstruction { }

class JvmLdiv extends @jvm_ldiv, JvmDivInstruction { }

class JvmFdiv extends @jvm_fdiv, JvmDivInstruction { }

class JvmDdiv extends @jvm_ddiv, JvmDivInstruction { }

class JvmIrem extends @jvm_irem, JvmRemInstruction { }

class JvmLrem extends @jvm_lrem, JvmRemInstruction { }

class JvmFrem extends @jvm_frem, JvmRemInstruction { }

class JvmDrem extends @jvm_drem, JvmRemInstruction { }

class JvmIneg extends @jvm_ineg, JvmNegInstruction { }

class JvmLneg extends @jvm_lneg, JvmNegInstruction { }

class JvmFneg extends @jvm_fneg, JvmNegInstruction { }

class JvmDneg extends @jvm_dneg, JvmNegInstruction { }

// Shifts and bitwise (abstract hierarchy)
/** A bitwise instruction (and, or, xor). */
abstract class JvmBitwiseInstruction extends JvmBinaryInstruction { }

/** A shift instruction (shl, shr, ushr). */
abstract class JvmShiftInstruction extends JvmBinaryInstruction { }

class JvmIshl extends @jvm_ishl, JvmShiftInstruction { }

class JvmLshl extends @jvm_lshl, JvmShiftInstruction { }

class JvmIshr extends @jvm_ishr, JvmShiftInstruction { }

class JvmLshr extends @jvm_lshr, JvmShiftInstruction { }

class JvmIushr extends @jvm_iushr, JvmShiftInstruction { }

class JvmLushr extends @jvm_lushr, JvmShiftInstruction { }

class JvmIand extends @jvm_iand, JvmBitwiseInstruction { }

class JvmLand extends @jvm_land, JvmBitwiseInstruction { }

class JvmIor extends @jvm_ior, JvmBitwiseInstruction { }

class JvmLor extends @jvm_lor, JvmBitwiseInstruction { }

class JvmIxor extends @jvm_ixor, JvmBitwiseInstruction { }

class JvmLxor extends @jvm_lxor, JvmBitwiseInstruction { }

// iinc
class JvmIinc extends @jvm_iinc, JvmInstruction {
  int getLocalVariableIndex() { jvm_operand_iinc(this, result, _) }

  int getIncrement() { jvm_operand_iinc(this, _, result) }
}

// Type conversions (abstract hierarchy)
/** An instruction that converts a value from one type to another. */
abstract class JvmConversionInstruction extends JvmUnaryInstruction { }

class JvmI2l extends @jvm_i2l, JvmConversionInstruction { }

class JvmI2f extends @jvm_i2f, JvmConversionInstruction { }

class JvmI2d extends @jvm_i2d, JvmConversionInstruction { }

class JvmL2i extends @jvm_l2i, JvmConversionInstruction { }

class JvmL2f extends @jvm_l2f, JvmConversionInstruction { }

class JvmL2d extends @jvm_l2d, JvmConversionInstruction { }

class JvmF2i extends @jvm_f2i, JvmConversionInstruction { }

class JvmF2l extends @jvm_f2l, JvmConversionInstruction { }

class JvmF2d extends @jvm_f2d, JvmConversionInstruction { }

class JvmD2i extends @jvm_d2i, JvmConversionInstruction { }

class JvmD2l extends @jvm_d2l, JvmConversionInstruction { }

class JvmD2f extends @jvm_d2f, JvmConversionInstruction { }

class JvmI2b extends @jvm_i2b, JvmConversionInstruction { }

class JvmI2c extends @jvm_i2c, JvmConversionInstruction { }

class JvmI2s extends @jvm_i2s, JvmConversionInstruction { }

// Comparisons (abstract hierarchy)
/** An instruction that compares two values and pushes a result onto the stack. */
abstract class JvmComparisonInstruction extends JvmBinaryInstruction { }

class JvmLcmp extends @jvm_lcmp, JvmComparisonInstruction { }

class JvmFcmpl extends @jvm_fcmpl, JvmComparisonInstruction { }

class JvmFcmpg extends @jvm_fcmpg, JvmComparisonInstruction { }

class JvmDcmpl extends @jvm_dcmpl, JvmComparisonInstruction { }

class JvmDcmpg extends @jvm_dcmpg, JvmComparisonInstruction { }

// Branch instructions (abstract hierarchy)
/** A branch instruction that may transfer control to another location. */
abstract class JvmBranch extends JvmInstruction {
  int getBranchTarget() { jvm_branch_target(this, result) }

  /** Gets the instruction at the branch target. */
  JvmInstruction getBranchTargetInstruction() {
    exists(JvmMethod m, int target |
      this.getEnclosingMethod() = m and
      target = this.getBranchTarget() and
      hasMethodAndOffset(m, target, result)
    )
  }

  override JvmInstruction getASuccessor() {
    result = JvmInstruction.super.getASuccessor()
    or
    result = this.getBranchTargetInstruction()
  }
}

/** A conditional branch instruction that branches based on a condition. */
abstract class JvmConditionalBranch extends JvmBranch {
  /** Gets the fall-through successor (when condition is false). */
  JvmInstruction getFallThroughSuccessor() {
    // Fall-through is the next sequential instruction
    exists(int offset, JvmMethod m |
      hasMethodAndIndex(m, offset, this) and
      hasMethodAndIndex(m, offset + 1, result)
    )
  }
}

/** A conditional branch that compares a single value against zero or null. */
abstract class JvmUnaryConditionalBranch extends JvmConditionalBranch { }

/** A conditional branch that compares two values. */
abstract class JvmBinaryConditionalBranch extends JvmConditionalBranch { }

/** An unconditional branch instruction (goto). */
abstract class JvmUnconditionalBranch extends JvmBranch {
  override JvmInstruction getASuccessor() { result = this.getBranchTargetInstruction() }
}

// Unary conditional branches (compare against zero/null)
class JvmIfeq extends @jvm_ifeq, JvmUnaryConditionalBranch { }

class JvmIfne extends @jvm_ifne, JvmUnaryConditionalBranch { }

class JvmIflt extends @jvm_iflt, JvmUnaryConditionalBranch { }

class JvmIfge extends @jvm_ifge, JvmUnaryConditionalBranch { }

class JvmIfgt extends @jvm_ifgt, JvmUnaryConditionalBranch { }

class JvmIfle extends @jvm_ifle, JvmUnaryConditionalBranch { }

class JvmIfnull extends @jvm_ifnull, JvmUnaryConditionalBranch { }

class JvmIfnonnull extends @jvm_ifnonnull, JvmUnaryConditionalBranch { }

// Binary conditional branches (compare two values)
class JvmIfIcmpeq extends @jvm_if_icmpeq, JvmBinaryConditionalBranch { }

class JvmIfIcmpne extends @jvm_if_icmpne, JvmBinaryConditionalBranch { }

class JvmIfIcmplt extends @jvm_if_icmplt, JvmBinaryConditionalBranch { }

class JvmIfIcmpge extends @jvm_if_icmpge, JvmBinaryConditionalBranch { }

class JvmIfIcmpgt extends @jvm_if_icmpgt, JvmBinaryConditionalBranch { }

class JvmIfIcmple extends @jvm_if_icmple, JvmBinaryConditionalBranch { }

class JvmIfAcmpeq extends @jvm_if_acmpeq, JvmBinaryConditionalBranch { }

class JvmIfAcmpne extends @jvm_if_acmpne, JvmBinaryConditionalBranch { }

// Unconditional branches
class JvmGoto extends @jvm_goto, JvmUnconditionalBranch { }

class JvmGotoW extends @jvm_goto_w, JvmUnconditionalBranch { }

class JvmJsr extends @jvm_jsr, JvmBranch { }

class JvmJsrW extends @jvm_jsr_w, JvmBranch { }

class JvmRet extends @jvm_ret, JvmInstruction {
  int getLocalVariableIndex() { jvm_operand_local_index(this, result) }
}

// Switch instructions
abstract class JvmSwitch extends JvmInstruction {
  int getDefaultTarget() { jvm_switch_default(this, result) }

  override JvmInstruction getASuccessor() {
    exists(JvmMethod m, int target |
      this.getEnclosingMethod() = m and
      (
        target = this.getDefaultTarget()
        or
        jvm_switch_case(this, _, _, target)
      ) and
      hasMethodAndOffset(m, target, result)
    )
  }
}

class JvmTableswitch extends @jvm_tableswitch, JvmSwitch { }

class JvmLookupswitch extends @jvm_lookupswitch, JvmSwitch { }

// Return instructions
abstract class JvmReturn extends JvmInstruction {
  override JvmInstruction getASuccessor() { none() }
}

class JvmIreturn extends @jvm_ireturn, JvmReturn { }

class JvmLreturn extends @jvm_lreturn, JvmReturn { }

class JvmFreturn extends @jvm_freturn, JvmReturn { }

class JvmDreturn extends @jvm_dreturn, JvmReturn { }

class JvmAreturn extends @jvm_areturn, JvmReturn { }

class JvmReturnVoid extends @jvm_return, JvmReturn { }

// Field access (abstract hierarchy)
/** An instruction that accesses a field. */
abstract class JvmFieldAccess extends JvmInstruction {
  string getFieldClassName() { jvm_field_operand(this, result, _, _) }

  string getFieldName() { jvm_field_operand(this, _, result, _) }

  string getFieldDescriptor() { jvm_field_operand(this, _, _, result) }

  /** Holds if this is a static field access. */
  predicate isStatic() { this instanceof JvmGetstatic or this instanceof JvmPutstatic }
}

/** An instruction that loads a field value onto the stack. */
abstract class JvmFieldLoad extends JvmFieldAccess { }

/** An instruction that stores a value into a field. */
abstract class JvmFieldStore extends JvmFieldAccess { }

class JvmGetstatic extends @jvm_getstatic, JvmFieldLoad { }

class JvmPutstatic extends @jvm_putstatic, JvmFieldStore { }

class JvmGetfield extends @jvm_getfield, JvmFieldLoad { }

class JvmPutfield extends @jvm_putfield, JvmFieldStore { }

// Method invocations
abstract class JvmInvoke extends JvmInstruction {
  string getCallTarget() { jvm_call_target_unresolved(this, result) }

  int getNumberOfArguments() { jvm_number_of_arguments(this, result) }

  predicate hasReturnValue() { jvm_call_has_return_value(this) }
}

class JvmInvokevirtual extends @jvm_invokevirtual, JvmInvoke { }

class JvmInvokespecial extends @jvm_invokespecial, JvmInvoke { }

class JvmInvokestatic extends @jvm_invokestatic, JvmInvoke { }

class JvmInvokeinterface extends @jvm_invokeinterface, JvmInvoke { }

class JvmInvokedynamic extends @jvm_invokedynamic, JvmInstruction { }

// Object creation
class JvmNew extends @jvm_new, JvmInstruction {
  string getTypeName() { jvm_type_operand(this, result) }
}

class JvmNewarray extends @jvm_newarray, JvmInstruction { }

class JvmAnewarray extends @jvm_anewarray, JvmInstruction {
  string getElementTypeName() { jvm_type_operand(this, result) }
}

class JvmMultianewarray extends @jvm_multianewarray, JvmInstruction {
  string getTypeName() { jvm_type_operand(this, result) }

  int getDimensions() { jvm_operand_byte(this, result) }
}

class JvmArraylength extends @jvm_arraylength, JvmInstruction { }

// Exception handling
class JvmAthrow extends @jvm_athrow, JvmInstruction {
  override JvmInstruction getASuccessor() { none() }
}

// Type checking
class JvmCheckcast extends @jvm_checkcast, JvmInstruction {
  string getTypeName() { jvm_type_operand(this, result) }
}

class JvmInstanceof extends @jvm_instanceof, JvmInstruction {
  string getTypeName() { jvm_type_operand(this, result) }
}

// Monitor
class JvmMonitorenter extends @jvm_monitorenter, JvmInstruction { }

class JvmMonitorexit extends @jvm_monitorexit, JvmInstruction { }

// Wide prefix
class JvmWide extends @jvm_wide, JvmInstruction { }

// Constants (abstract hierarchy)
/** An instruction that loads a constant value onto the stack. */
abstract class JvmLoadConstant extends JvmInstruction { }

/** An instruction that loads an integer constant onto the stack. */
abstract class JvmLoadIntConstant extends JvmLoadConstant {
  /** Gets the integer value loaded by this instruction. */
  abstract int getIntValue();
}

/** An instruction that loads a long constant onto the stack. */
abstract class JvmLoadLongConstant extends JvmLoadConstant {
  /** Gets the long value loaded by this instruction. */
  abstract int getLongValue();
}

/** An instruction that loads a float constant onto the stack. */
abstract class JvmLoadFloatConstant extends JvmLoadConstant {
  /** Gets the float value loaded by this instruction. */
  abstract float getFloatValue();
}

/** An instruction that loads a double constant onto the stack. */
abstract class JvmLoadDoubleConstant extends JvmLoadConstant {
  /** Gets the double value loaded by this instruction. */
  abstract float getDoubleValue();
}

class JvmIconstM1 extends @jvm_iconst_m1, JvmLoadIntConstant {
  override int getIntValue() { result = -1 }
}

class JvmIconst0 extends @jvm_iconst_0, JvmLoadIntConstant {
  override int getIntValue() { result = 0 }
}

class JvmIconst1 extends @jvm_iconst_1, JvmLoadIntConstant {
  override int getIntValue() { result = 1 }
}

class JvmIconst2 extends @jvm_iconst_2, JvmLoadIntConstant {
  override int getIntValue() { result = 2 }
}

class JvmIconst3 extends @jvm_iconst_3, JvmLoadIntConstant {
  override int getIntValue() { result = 3 }
}

class JvmIconst4 extends @jvm_iconst_4, JvmLoadIntConstant {
  override int getIntValue() { result = 4 }
}

class JvmIconst5 extends @jvm_iconst_5, JvmLoadIntConstant {
  override int getIntValue() { result = 5 }
}

class JvmLconst0 extends @jvm_lconst_0, JvmLoadLongConstant {
  override int getLongValue() { result = 0 }
}

class JvmLconst1 extends @jvm_lconst_1, JvmLoadLongConstant {
  override int getLongValue() { result = 1 }
}

class JvmFconst0 extends @jvm_fconst_0, JvmLoadFloatConstant {
  override float getFloatValue() { result = 0.0 }
}

class JvmFconst1 extends @jvm_fconst_1, JvmLoadFloatConstant {
  override float getFloatValue() { result = 1.0 }
}

class JvmFconst2 extends @jvm_fconst_2, JvmLoadFloatConstant {
  override float getFloatValue() { result = 2.0 }
}

class JvmDconst0 extends @jvm_dconst_0, JvmLoadDoubleConstant {
  override float getDoubleValue() { result = 0.0 }
}

class JvmDconst1 extends @jvm_dconst_1, JvmLoadDoubleConstant {
  override float getDoubleValue() { result = 1.0 }
}

// Push constants (integer values from immediate operand)
class JvmBipush extends @jvm_bipush, JvmLoadIntConstant {
  override int getIntValue() { jvm_operand_byte(this, result) }
}

class JvmSipush extends @jvm_sipush, JvmLoadIntConstant {
  override int getIntValue() { jvm_operand_short(this, result) }
}

// Load constants from constant pool
class JvmLdc extends @jvm_ldc, JvmLoadConstant { }

class JvmLdcW extends @jvm_ldc_w, JvmLoadConstant { }

class JvmLdc2W extends @jvm_ldc2_w, JvmLoadConstant { }

/**
 * A JVM exception handler entry.
 */
class JvmExceptionHandler extends @jvm_exception_handler {
  string toString() { result = "exception handler" }

  JvmMethod getMethod() { jvm_exception_handler(this, result, _, _, _, _) }

  int getStartPC() { jvm_exception_handler(this, _, result, _, _, _) }

  int getEndPC() { jvm_exception_handler(this, _, _, result, _, _) }

  int getHandlerPC() { jvm_exception_handler(this, _, _, _, result, _) }

  string getCatchType() { jvm_exception_handler(this, _, _, _, _, result) }

  predicate catchesAll() { this.getCatchType() = "" }
}
