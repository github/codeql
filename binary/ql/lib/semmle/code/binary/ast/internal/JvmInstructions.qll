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
  opcode = 0x00 and result = "nop"
  or
  opcode = 0x01 and result = "aconst_null"
  or
  opcode = 0x02 and result = "iconst_m1"
  or
  opcode = 0x03 and result = "iconst_0"
  or
  opcode = 0x04 and result = "iconst_1"
  or
  opcode = 0x05 and result = "iconst_2"
  or
  opcode = 0x06 and result = "iconst_3"
  or
  opcode = 0x07 and result = "iconst_4"
  or
  opcode = 0x08 and result = "iconst_5"
  or
  opcode = 0x09 and result = "lconst_0"
  or
  opcode = 0x0A and result = "lconst_1"
  or
  opcode = 0x0B and result = "fconst_0"
  or
  opcode = 0x0C and result = "fconst_1"
  or
  opcode = 0x0D and result = "fconst_2"
  or
  opcode = 0x0E and result = "dconst_0"
  or
  opcode = 0x0F and result = "dconst_1"
  or
  opcode = 0x10 and result = "bipush"
  or
  opcode = 0x11 and result = "sipush"
  or
  opcode = 0x12 and result = "ldc"
  or
  opcode = 0x13 and result = "ldc_w"
  or
  opcode = 0x14 and result = "ldc2_w"
  or
  opcode = 0x15 and result = "iload"
  or
  opcode = 0x16 and result = "lload"
  or
  opcode = 0x17 and result = "fload"
  or
  opcode = 0x18 and result = "dload"
  or
  opcode = 0x19 and result = "aload"
  or
  opcode = 0x1A and result = "iload_0"
  or
  opcode = 0x1B and result = "iload_1"
  or
  opcode = 0x1C and result = "iload_2"
  or
  opcode = 0x1D and result = "iload_3"
  or
  opcode = 0x1E and result = "lload_0"
  or
  opcode = 0x1F and result = "lload_1"
  or
  opcode = 0x20 and result = "lload_2"
  or
  opcode = 0x21 and result = "lload_3"
  or
  opcode = 0x22 and result = "fload_0"
  or
  opcode = 0x23 and result = "fload_1"
  or
  opcode = 0x24 and result = "fload_2"
  or
  opcode = 0x25 and result = "fload_3"
  or
  opcode = 0x26 and result = "dload_0"
  or
  opcode = 0x27 and result = "dload_1"
  or
  opcode = 0x28 and result = "dload_2"
  or
  opcode = 0x29 and result = "dload_3"
  or
  opcode = 0x2A and result = "aload_0"
  or
  opcode = 0x2B and result = "aload_1"
  or
  opcode = 0x2C and result = "aload_2"
  or
  opcode = 0x2D and result = "aload_3"
  or
  opcode = 0x2E and result = "iaload"
  or
  opcode = 0x2F and result = "laload"
  or
  opcode = 0x30 and result = "faload"
  or
  opcode = 0x31 and result = "daload"
  or
  opcode = 0x32 and result = "aaload"
  or
  opcode = 0x33 and result = "baload"
  or
  opcode = 0x34 and result = "caload"
  or
  opcode = 0x35 and result = "saload"
  or
  opcode = 0x36 and result = "istore"
  or
  opcode = 0x37 and result = "lstore"
  or
  opcode = 0x38 and result = "fstore"
  or
  opcode = 0x39 and result = "dstore"
  or
  opcode = 0x3A and result = "astore"
  or
  opcode = 0x3B and result = "istore_0"
  or
  opcode = 0x3C and result = "istore_1"
  or
  opcode = 0x3D and result = "istore_2"
  or
  opcode = 0x3E and result = "istore_3"
  or
  opcode = 0x3F and result = "lstore_0"
  or
  opcode = 0x40 and result = "lstore_1"
  or
  opcode = 0x41 and result = "lstore_2"
  or
  opcode = 0x42 and result = "lstore_3"
  or
  opcode = 0x43 and result = "fstore_0"
  or
  opcode = 0x44 and result = "fstore_1"
  or
  opcode = 0x45 and result = "fstore_2"
  or
  opcode = 0x46 and result = "fstore_3"
  or
  opcode = 0x47 and result = "dstore_0"
  or
  opcode = 0x48 and result = "dstore_1"
  or
  opcode = 0x49 and result = "dstore_2"
  or
  opcode = 0x4A and result = "dstore_3"
  or
  opcode = 0x4B and result = "astore_0"
  or
  opcode = 0x4C and result = "astore_1"
  or
  opcode = 0x4D and result = "astore_2"
  or
  opcode = 0x4E and result = "astore_3"
  or
  opcode = 0x4F and result = "iastore"
  or
  opcode = 0x50 and result = "lastore"
  or
  opcode = 0x51 and result = "fastore"
  or
  opcode = 0x52 and result = "dastore"
  or
  opcode = 0x53 and result = "aastore"
  or
  opcode = 0x54 and result = "bastore"
  or
  opcode = 0x55 and result = "castore"
  or
  opcode = 0x56 and result = "sastore"
  or
  opcode = 0x57 and result = "pop"
  or
  opcode = 0x58 and result = "pop2"
  or
  opcode = 0x59 and result = "dup"
  or
  opcode = 0x5A and result = "dup_x1"
  or
  opcode = 0x5B and result = "dup_x2"
  or
  opcode = 0x5C and result = "dup2"
  or
  opcode = 0x5D and result = "dup2_x1"
  or
  opcode = 0x5E and result = "dup2_x2"
  or
  opcode = 0x5F and result = "swap"
  or
  opcode = 0x60 and result = "iadd"
  or
  opcode = 0x61 and result = "ladd"
  or
  opcode = 0x62 and result = "fadd"
  or
  opcode = 0x63 and result = "dadd"
  or
  opcode = 0x64 and result = "isub"
  or
  opcode = 0x65 and result = "lsub"
  or
  opcode = 0x66 and result = "fsub"
  or
  opcode = 0x67 and result = "dsub"
  or
  opcode = 0x68 and result = "imul"
  or
  opcode = 0x69 and result = "lmul"
  or
  opcode = 0x6A and result = "fmul"
  or
  opcode = 0x6B and result = "dmul"
  or
  opcode = 0x6C and result = "idiv"
  or
  opcode = 0x6D and result = "ldiv"
  or
  opcode = 0x6E and result = "fdiv"
  or
  opcode = 0x6F and result = "ddiv"
  or
  opcode = 0x70 and result = "irem"
  or
  opcode = 0x71 and result = "lrem"
  or
  opcode = 0x72 and result = "frem"
  or
  opcode = 0x73 and result = "drem"
  or
  opcode = 0x74 and result = "ineg"
  or
  opcode = 0x75 and result = "lneg"
  or
  opcode = 0x76 and result = "fneg"
  or
  opcode = 0x77 and result = "dneg"
  or
  opcode = 0x78 and result = "ishl"
  or
  opcode = 0x79 and result = "lshl"
  or
  opcode = 0x7A and result = "ishr"
  or
  opcode = 0x7B and result = "lshr"
  or
  opcode = 0x7C and result = "iushr"
  or
  opcode = 0x7D and result = "lushr"
  or
  opcode = 0x7E and result = "iand"
  or
  opcode = 0x7F and result = "land"
  or
  opcode = 0x80 and result = "ior"
  or
  opcode = 0x81 and result = "lor"
  or
  opcode = 0x82 and result = "ixor"
  or
  opcode = 0x83 and result = "lxor"
  or
  opcode = 0x84 and result = "iinc"
  or
  opcode = 0x85 and result = "i2l"
  or
  opcode = 0x86 and result = "i2f"
  or
  opcode = 0x87 and result = "i2d"
  or
  opcode = 0x88 and result = "l2i"
  or
  opcode = 0x89 and result = "l2f"
  or
  opcode = 0x8A and result = "l2d"
  or
  opcode = 0x8B and result = "f2i"
  or
  opcode = 0x8C and result = "f2l"
  or
  opcode = 0x8D and result = "f2d"
  or
  opcode = 0x8E and result = "d2i"
  or
  opcode = 0x8F and result = "d2l"
  or
  opcode = 0x90 and result = "d2f"
  or
  opcode = 0x91 and result = "i2b"
  or
  opcode = 0x92 and result = "i2c"
  or
  opcode = 0x93 and result = "i2s"
  or
  opcode = 0x94 and result = "lcmp"
  or
  opcode = 0x95 and result = "fcmpl"
  or
  opcode = 0x96 and result = "fcmpg"
  or
  opcode = 0x97 and result = "dcmpl"
  or
  opcode = 0x98 and result = "dcmpg"
  or
  opcode = 0x99 and result = "ifeq"
  or
  opcode = 0x9A and result = "ifne"
  or
  opcode = 0x9B and result = "iflt"
  or
  opcode = 0x9C and result = "ifge"
  or
  opcode = 0x9D and result = "ifgt"
  or
  opcode = 0x9E and result = "ifle"
  or
  opcode = 0x9F and result = "if_icmpeq"
  or
  opcode = 0xA0 and result = "if_icmpne"
  or
  opcode = 0xA1 and result = "if_icmplt"
  or
  opcode = 0xA2 and result = "if_icmpge"
  or
  opcode = 0xA3 and result = "if_icmpgt"
  or
  opcode = 0xA4 and result = "if_icmple"
  or
  opcode = 0xA5 and result = "if_acmpeq"
  or
  opcode = 0xA6 and result = "if_acmpne"
  or
  opcode = 0xA7 and result = "goto"
  or
  opcode = 0xA8 and result = "jsr"
  or
  opcode = 0xA9 and result = "ret"
  or
  opcode = 0xAA and result = "tableswitch"
  or
  opcode = 0xAB and result = "lookupswitch"
  or
  opcode = 0xAC and result = "ireturn"
  or
  opcode = 0xAD and result = "lreturn"
  or
  opcode = 0xAE and result = "freturn"
  or
  opcode = 0xAF and result = "dreturn"
  or
  opcode = 0xB0 and result = "areturn"
  or
  opcode = 0xB1 and result = "return"
  or
  opcode = 0xB2 and result = "getstatic"
  or
  opcode = 0xB3 and result = "putstatic"
  or
  opcode = 0xB4 and result = "getfield"
  or
  opcode = 0xB5 and result = "putfield"
  or
  opcode = 0xB6 and result = "invokevirtual"
  or
  opcode = 0xB7 and result = "invokespecial"
  or
  opcode = 0xB8 and result = "invokestatic"
  or
  opcode = 0xB9 and result = "invokeinterface"
  or
  opcode = 0xBA and result = "invokedynamic"
  or
  opcode = 0xBB and result = "new"
  or
  opcode = 0xBC and result = "newarray"
  or
  opcode = 0xBD and result = "anewarray"
  or
  opcode = 0xBE and result = "arraylength"
  or
  opcode = 0xBF and result = "athrow"
  or
  opcode = 0xC0 and result = "checkcast"
  or
  opcode = 0xC1 and result = "instanceof"
  or
  opcode = 0xC2 and result = "monitorenter"
  or
  opcode = 0xC3 and result = "monitorexit"
  or
  opcode = 0xC4 and result = "wide"
  or
  opcode = 0xC5 and result = "multianewarray"
  or
  opcode = 0xC6 and result = "ifnull"
  or
  opcode = 0xC7 and result = "ifnonnull"
  or
  opcode = 0xC8 and result = "goto_w"
  or
  opcode = 0xC9 and result = "jsr_w"
  or
  result = "unknown_" + opcode.toString()
}

// ============================================================================
// Instruction Categories
// ============================================================================

/** A no-operation instruction. */
class JvmNop extends @jvm_nop, JvmInstruction { }

/** Pushes null onto the stack. */
class JvmAconstNull extends @jvm_aconst_null, JvmInstruction { }

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

// Array load instructions
class JvmIaload extends @jvm_iaload, JvmInstruction { }

class JvmLaload extends @jvm_laload, JvmInstruction { }

class JvmFaload extends @jvm_faload, JvmInstruction { }

class JvmDaload extends @jvm_daload, JvmInstruction { }

class JvmAaload extends @jvm_aaload, JvmInstruction { }

class JvmBaload extends @jvm_baload, JvmInstruction { }

class JvmCaload extends @jvm_caload, JvmInstruction { }

class JvmSaload extends @jvm_saload, JvmInstruction { }

// Array store instructions
class JvmIastore extends @jvm_iastore, JvmInstruction { }

class JvmLastore extends @jvm_lastore, JvmInstruction { }

class JvmFastore extends @jvm_fastore, JvmInstruction { }

class JvmDastore extends @jvm_dastore, JvmInstruction { }

class JvmAastore extends @jvm_aastore, JvmInstruction { }

class JvmBastore extends @jvm_bastore, JvmInstruction { }

class JvmCastore extends @jvm_castore, JvmInstruction { }

class JvmSastore extends @jvm_sastore, JvmInstruction { }

// Stack manipulation
class JvmPop extends @jvm_pop, JvmInstruction { }

class JvmPop2 extends @jvm_pop2, JvmInstruction { }

class JvmDup extends @jvm_dup, JvmInstruction { }

class JvmDupX1 extends @jvm_dup_x1, JvmInstruction { }

class JvmDupX2 extends @jvm_dup_x2, JvmInstruction { }

class JvmDup2 extends @jvm_dup2, JvmInstruction { }

class JvmDup2X1 extends @jvm_dup2_x1, JvmInstruction { }

class JvmDup2X2 extends @jvm_dup2_x2, JvmInstruction { }

class JvmSwap extends @jvm_swap, JvmInstruction { }

// Arithmetic
class JvmIadd extends @jvm_iadd, JvmInstruction { }

class JvmLadd extends @jvm_ladd, JvmInstruction { }

class JvmFadd extends @jvm_fadd, JvmInstruction { }

class JvmDadd extends @jvm_dadd, JvmInstruction { }

class JvmIsub extends @jvm_isub, JvmInstruction { }

class JvmLsub extends @jvm_lsub, JvmInstruction { }

class JvmFsub extends @jvm_fsub, JvmInstruction { }

class JvmDsub extends @jvm_dsub, JvmInstruction { }

class JvmImul extends @jvm_imul, JvmInstruction { }

class JvmLmul extends @jvm_lmul, JvmInstruction { }

class JvmFmul extends @jvm_fmul, JvmInstruction { }

class JvmDmul extends @jvm_dmul, JvmInstruction { }

class JvmIdiv extends @jvm_idiv, JvmInstruction { }

class JvmLdiv extends @jvm_ldiv, JvmInstruction { }

class JvmFdiv extends @jvm_fdiv, JvmInstruction { }

class JvmDdiv extends @jvm_ddiv, JvmInstruction { }

class JvmIrem extends @jvm_irem, JvmInstruction { }

class JvmLrem extends @jvm_lrem, JvmInstruction { }

class JvmFrem extends @jvm_frem, JvmInstruction { }

class JvmDrem extends @jvm_drem, JvmInstruction { }

class JvmIneg extends @jvm_ineg, JvmInstruction { }

class JvmLneg extends @jvm_lneg, JvmInstruction { }

class JvmFneg extends @jvm_fneg, JvmInstruction { }

class JvmDneg extends @jvm_dneg, JvmInstruction { }

// Shifts
class JvmIshl extends @jvm_ishl, JvmInstruction { }

class JvmLshl extends @jvm_lshl, JvmInstruction { }

class JvmIshr extends @jvm_ishr, JvmInstruction { }

class JvmLshr extends @jvm_lshr, JvmInstruction { }

class JvmIushr extends @jvm_iushr, JvmInstruction { }

class JvmLushr extends @jvm_lushr, JvmInstruction { }

// Bitwise
class JvmIand extends @jvm_iand, JvmInstruction { }

class JvmLand extends @jvm_land, JvmInstruction { }

class JvmIor extends @jvm_ior, JvmInstruction { }

class JvmLor extends @jvm_lor, JvmInstruction { }

class JvmIxor extends @jvm_ixor, JvmInstruction { }

class JvmLxor extends @jvm_lxor, JvmInstruction { }

// iinc
class JvmIinc extends @jvm_iinc, JvmInstruction {
  int getLocalVariableIndex() {
    exists(int idx | jvm_operand_iinc(this, idx, _) | result = idx)
  }

  int getIncrement() { exists(int inc | jvm_operand_iinc(this, _, inc) | result = inc) }
}

// Type conversions
class JvmI2l extends @jvm_i2l, JvmInstruction { }

class JvmI2f extends @jvm_i2f, JvmInstruction { }

class JvmI2d extends @jvm_i2d, JvmInstruction { }

class JvmL2i extends @jvm_l2i, JvmInstruction { }

class JvmL2f extends @jvm_l2f, JvmInstruction { }

class JvmL2d extends @jvm_l2d, JvmInstruction { }

class JvmF2i extends @jvm_f2i, JvmInstruction { }

class JvmF2l extends @jvm_f2l, JvmInstruction { }

class JvmF2d extends @jvm_f2d, JvmInstruction { }

class JvmD2i extends @jvm_d2i, JvmInstruction { }

class JvmD2l extends @jvm_d2l, JvmInstruction { }

class JvmD2f extends @jvm_d2f, JvmInstruction { }

class JvmI2b extends @jvm_i2b, JvmInstruction { }

class JvmI2c extends @jvm_i2c, JvmInstruction { }

class JvmI2s extends @jvm_i2s, JvmInstruction { }

// Comparisons
class JvmLcmp extends @jvm_lcmp, JvmInstruction { }

class JvmFcmpl extends @jvm_fcmpl, JvmInstruction { }

class JvmFcmpg extends @jvm_fcmpg, JvmInstruction { }

class JvmDcmpl extends @jvm_dcmpl, JvmInstruction { }

class JvmDcmpg extends @jvm_dcmpg, JvmInstruction { }

// Branch instructions (abstract base)
abstract class JvmBranch extends JvmInstruction {
  int getBranchTarget() { jvm_branch_target(this, result) }

  override JvmInstruction getASuccessor() {
    result = JvmInstruction.super.getASuccessor()
    or
    exists(JvmMethod m, int target |
      this.getEnclosingMethod() = m and
      target = this.getBranchTarget() and
      hasMethodAndOffset(m, target, result)
    )
  }
}

// Conditional branches
class JvmIfeq extends @jvm_ifeq, JvmBranch { }

class JvmIfne extends @jvm_ifne, JvmBranch { }

class JvmIflt extends @jvm_iflt, JvmBranch { }

class JvmIfge extends @jvm_ifge, JvmBranch { }

class JvmIfgt extends @jvm_ifgt, JvmBranch { }

class JvmIfle extends @jvm_ifle, JvmBranch { }

class JvmIfIcmpeq extends @jvm_if_icmpeq, JvmBranch { }

class JvmIfIcmpne extends @jvm_if_icmpne, JvmBranch { }

class JvmIfIcmplt extends @jvm_if_icmplt, JvmBranch { }

class JvmIfIcmpge extends @jvm_if_icmpge, JvmBranch { }

class JvmIfIcmpgt extends @jvm_if_icmpgt, JvmBranch { }

class JvmIfIcmple extends @jvm_if_icmple, JvmBranch { }

class JvmIfAcmpeq extends @jvm_if_acmpeq, JvmBranch { }

class JvmIfAcmpne extends @jvm_if_acmpne, JvmBranch { }

class JvmIfnull extends @jvm_ifnull, JvmBranch { }

class JvmIfnonnull extends @jvm_ifnonnull, JvmBranch { }

// Unconditional branches
class JvmGoto extends @jvm_goto, JvmBranch {
  override JvmInstruction getASuccessor() {
    exists(JvmMethod m, int target |
      this.getEnclosingMethod() = m and
      target = this.getBranchTarget() and
      hasMethodAndOffset(m, target, result)
    )
  }
}

class JvmGotoW extends @jvm_goto_w, JvmBranch {
  override JvmInstruction getASuccessor() {
    exists(JvmMethod m, int target |
      this.getEnclosingMethod() = m and
      target = this.getBranchTarget() and
      hasMethodAndOffset(m, target, result)
    )
  }
}

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

// Field access
abstract class JvmFieldAccess extends JvmInstruction {
  string getFieldClassName() {
    exists(string cn | jvm_field_operand(this, cn, _, _) | result = cn)
  }

  string getFieldName() { exists(string fn | jvm_field_operand(this, _, fn, _) | result = fn) }

  string getFieldDescriptor() {
    exists(string fd | jvm_field_operand(this, _, _, fd) | result = fd)
  }
}

class JvmGetstatic extends @jvm_getstatic, JvmFieldAccess { }

class JvmPutstatic extends @jvm_putstatic, JvmFieldAccess { }

class JvmGetfield extends @jvm_getfield, JvmFieldAccess { }

class JvmPutfield extends @jvm_putfield, JvmFieldAccess { }

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

// Constants
class JvmIconstM1 extends @jvm_iconst_m1, JvmInstruction { }

class JvmIconst0 extends @jvm_iconst_0, JvmInstruction { }

class JvmIconst1 extends @jvm_iconst_1, JvmInstruction { }

class JvmIconst2 extends @jvm_iconst_2, JvmInstruction { }

class JvmIconst3 extends @jvm_iconst_3, JvmInstruction { }

class JvmIconst4 extends @jvm_iconst_4, JvmInstruction { }

class JvmIconst5 extends @jvm_iconst_5, JvmInstruction { }

class JvmLconst0 extends @jvm_lconst_0, JvmInstruction { }

class JvmLconst1 extends @jvm_lconst_1, JvmInstruction { }

class JvmFconst0 extends @jvm_fconst_0, JvmInstruction { }

class JvmFconst1 extends @jvm_fconst_1, JvmInstruction { }

class JvmFconst2 extends @jvm_fconst_2, JvmInstruction { }

class JvmDconst0 extends @jvm_dconst_0, JvmInstruction { }

class JvmDconst1 extends @jvm_dconst_1, JvmInstruction { }

// Push constants
class JvmBipush extends @jvm_bipush, JvmInstruction {
  int getValue() { jvm_operand_byte(this, result) }
}

class JvmSipush extends @jvm_sipush, JvmInstruction {
  int getValue() { jvm_operand_short(this, result) }
}

// Load constants from constant pool
class JvmLdc extends @jvm_ldc, JvmInstruction { }

class JvmLdcW extends @jvm_ldc_w, JvmInstruction { }

class JvmLdc2W extends @jvm_ldc2_w, JvmInstruction { }

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
