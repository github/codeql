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
bindingset[opcode]
private string opcodeToMnemonic(int opcode) {
  if opcode = 0 then result = "nop"
  else if opcode = 1 then result = "aconst_null"
  else if opcode = 2 then result = "iconst_m1"
  else if opcode = 3 then result = "iconst_0"
  else if opcode = 4 then result = "iconst_1"
  else if opcode = 5 then result = "iconst_2"
  else if opcode = 6 then result = "iconst_3"
  else if opcode = 7 then result = "iconst_4"
  else if opcode = 8 then result = "iconst_5"
  else if opcode = 9 then result = "lconst_0"
  else if opcode = 10 then result = "lconst_1"
  else if opcode = 11 then result = "fconst_0"
  else if opcode = 12 then result = "fconst_1"
  else if opcode = 13 then result = "fconst_2"
  else if opcode = 14 then result = "dconst_0"
  else if opcode = 15 then result = "dconst_1"
  else if opcode = 16 then result = "bipush"
  else if opcode = 17 then result = "sipush"
  else if opcode = 18 then result = "ldc"
  else if opcode = 19 then result = "ldc_w"
  else if opcode = 20 then result = "ldc2_w"
  else if opcode = 21 then result = "iload"
  else if opcode = 22 then result = "lload"
  else if opcode = 23 then result = "fload"
  else if opcode = 24 then result = "dload"
  else if opcode = 25 then result = "aload"
  else if opcode = 26 then result = "iload_0"
  else if opcode = 27 then result = "iload_1"
  else if opcode = 28 then result = "iload_2"
  else if opcode = 29 then result = "iload_3"
  else if opcode = 30 then result = "lload_0"
  else if opcode = 31 then result = "lload_1"
  else if opcode = 32 then result = "lload_2"
  else if opcode = 33 then result = "lload_3"
  else if opcode = 34 then result = "fload_0"
  else if opcode = 35 then result = "fload_1"
  else if opcode = 36 then result = "fload_2"
  else if opcode = 37 then result = "fload_3"
  else if opcode = 38 then result = "dload_0"
  else if opcode = 39 then result = "dload_1"
  else if opcode = 40 then result = "dload_2"
  else if opcode = 41 then result = "dload_3"
  else if opcode = 42 then result = "aload_0"
  else if opcode = 43 then result = "aload_1"
  else if opcode = 44 then result = "aload_2"
  else if opcode = 45 then result = "aload_3"
  else if opcode = 46 then result = "iaload"
  else if opcode = 47 then result = "laload"
  else if opcode = 48 then result = "faload"
  else if opcode = 49 then result = "daload"
  else if opcode = 50 then result = "aaload"
  else if opcode = 51 then result = "baload"
  else if opcode = 52 then result = "caload"
  else if opcode = 53 then result = "saload"
  else if opcode = 54 then result = "istore"
  else if opcode = 55 then result = "lstore"
  else if opcode = 56 then result = "fstore"
  else if opcode = 57 then result = "dstore"
  else if opcode = 58 then result = "astore"
  else if opcode = 59 then result = "istore_0"
  else if opcode = 60 then result = "istore_1"
  else if opcode = 61 then result = "istore_2"
  else if opcode = 62 then result = "istore_3"
  else if opcode = 63 then result = "lstore_0"
  else if opcode = 64 then result = "lstore_1"
  else if opcode = 65 then result = "lstore_2"
  else if opcode = 66 then result = "lstore_3"
  else if opcode = 67 then result = "fstore_0"
  else if opcode = 68 then result = "fstore_1"
  else if opcode = 69 then result = "fstore_2"
  else if opcode = 70 then result = "fstore_3"
  else if opcode = 71 then result = "dstore_0"
  else if opcode = 72 then result = "dstore_1"
  else if opcode = 73 then result = "dstore_2"
  else if opcode = 74 then result = "dstore_3"
  else if opcode = 75 then result = "astore_0"
  else if opcode = 76 then result = "astore_1"
  else if opcode = 77 then result = "astore_2"
  else if opcode = 78 then result = "astore_3"
  else if opcode = 79 then result = "iastore"
  else if opcode = 80 then result = "lastore"
  else if opcode = 81 then result = "fastore"
  else if opcode = 82 then result = "dastore"
  else if opcode = 83 then result = "aastore"
  else if opcode = 84 then result = "bastore"
  else if opcode = 85 then result = "castore"
  else if opcode = 86 then result = "sastore"
  else if opcode = 87 then result = "pop"
  else if opcode = 88 then result = "pop2"
  else if opcode = 89 then result = "dup"
  else if opcode = 90 then result = "dup_x1"
  else if opcode = 91 then result = "dup_x2"
  else if opcode = 92 then result = "dup2"
  else if opcode = 93 then result = "dup2_x1"
  else if opcode = 94 then result = "dup2_x2"
  else if opcode = 95 then result = "swap"
  else if opcode = 96 then result = "iadd"
  else if opcode = 97 then result = "ladd"
  else if opcode = 98 then result = "fadd"
  else if opcode = 99 then result = "dadd"
  else if opcode = 100 then result = "isub"
  else if opcode = 101 then result = "lsub"
  else if opcode = 102 then result = "fsub"
  else if opcode = 103 then result = "dsub"
  else if opcode = 104 then result = "imul"
  else if opcode = 105 then result = "lmul"
  else if opcode = 106 then result = "fmul"
  else if opcode = 107 then result = "dmul"
  else if opcode = 108 then result = "idiv"
  else if opcode = 109 then result = "ldiv"
  else if opcode = 110 then result = "fdiv"
  else if opcode = 111 then result = "ddiv"
  else if opcode = 112 then result = "irem"
  else if opcode = 113 then result = "lrem"
  else if opcode = 114 then result = "frem"
  else if opcode = 115 then result = "drem"
  else if opcode = 116 then result = "ineg"
  else if opcode = 117 then result = "lneg"
  else if opcode = 118 then result = "fneg"
  else if opcode = 119 then result = "dneg"
  else if opcode = 120 then result = "ishl"
  else if opcode = 121 then result = "lshl"
  else if opcode = 122 then result = "ishr"
  else if opcode = 123 then result = "lshr"
  else if opcode = 124 then result = "iushr"
  else if opcode = 125 then result = "lushr"
  else if opcode = 126 then result = "iand"
  else if opcode = 127 then result = "land"
  else if opcode = 128 then result = "ior"
  else if opcode = 129 then result = "lor"
  else if opcode = 130 then result = "ixor"
  else if opcode = 131 then result = "lxor"
  else if opcode = 132 then result = "iinc"
  else if opcode = 133 then result = "i2l"
  else if opcode = 134 then result = "i2f"
  else if opcode = 135 then result = "i2d"
  else if opcode = 136 then result = "l2i"
  else if opcode = 137 then result = "l2f"
  else if opcode = 138 then result = "l2d"
  else if opcode = 139 then result = "f2i"
  else if opcode = 140 then result = "f2l"
  else if opcode = 141 then result = "f2d"
  else if opcode = 142 then result = "d2i"
  else if opcode = 143 then result = "d2l"
  else if opcode = 144 then result = "d2f"
  else if opcode = 145 then result = "i2b"
  else if opcode = 146 then result = "i2c"
  else if opcode = 147 then result = "i2s"
  else if opcode = 148 then result = "lcmp"
  else if opcode = 149 then result = "fcmpl"
  else if opcode = 150 then result = "fcmpg"
  else if opcode = 151 then result = "dcmpl"
  else if opcode = 152 then result = "dcmpg"
  else if opcode = 153 then result = "ifeq"
  else if opcode = 154 then result = "ifne"
  else if opcode = 155 then result = "iflt"
  else if opcode = 156 then result = "ifge"
  else if opcode = 157 then result = "ifgt"
  else if opcode = 158 then result = "ifle"
  else if opcode = 159 then result = "if_icmpeq"
  else if opcode = 160 then result = "if_icmpne"
  else if opcode = 161 then result = "if_icmplt"
  else if opcode = 162 then result = "if_icmpge"
  else if opcode = 163 then result = "if_icmpgt"
  else if opcode = 164 then result = "if_icmple"
  else if opcode = 165 then result = "if_acmpeq"
  else if opcode = 166 then result = "if_acmpne"
  else if opcode = 167 then result = "goto"
  else if opcode = 168 then result = "jsr"
  else if opcode = 169 then result = "ret"
  else if opcode = 170 then result = "tableswitch"
  else if opcode = 171 then result = "lookupswitch"
  else if opcode = 172 then result = "ireturn"
  else if opcode = 173 then result = "lreturn"
  else if opcode = 174 then result = "freturn"
  else if opcode = 175 then result = "dreturn"
  else if opcode = 176 then result = "areturn"
  else if opcode = 177 then result = "return"
  else if opcode = 178 then result = "getstatic"
  else if opcode = 179 then result = "putstatic"
  else if opcode = 180 then result = "getfield"
  else if opcode = 181 then result = "putfield"
  else if opcode = 182 then result = "invokevirtual"
  else if opcode = 183 then result = "invokespecial"
  else if opcode = 184 then result = "invokestatic"
  else if opcode = 185 then result = "invokeinterface"
  else if opcode = 186 then result = "invokedynamic"
  else if opcode = 187 then result = "new"
  else if opcode = 188 then result = "newarray"
  else if opcode = 189 then result = "anewarray"
  else if opcode = 190 then result = "arraylength"
  else if opcode = 191 then result = "athrow"
  else if opcode = 192 then result = "checkcast"
  else if opcode = 193 then result = "instanceof"
  else if opcode = 194 then result = "monitorenter"
  else if opcode = 195 then result = "monitorexit"
  else if opcode = 196 then result = "wide"
  else if opcode = 197 then result = "multianewarray"
  else if opcode = 198 then result = "ifnull"
  else if opcode = 199 then result = "ifnonnull"
  else if opcode = 200 then result = "goto_w"
  else if opcode = 201 then result = "jsr_w"
  else result = "unknown_" + opcode.toString()
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
  int getLocalVariableIndex() {
    exists(int idx | jvm_operand_iinc(this, idx, _) | result = idx)
  }

  int getIncrement() { exists(int inc | jvm_operand_iinc(this, _, inc) | result = inc) }
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
  string getFieldClassName() {
    exists(string cn | jvm_field_operand(this, cn, _, _) | result = cn)
  }

  string getFieldName() { exists(string fn | jvm_field_operand(this, _, fn, _) | result = fn) }

  string getFieldDescriptor() {
    exists(string fd | jvm_field_operand(this, _, _, fd) | result = fd)
  }

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
