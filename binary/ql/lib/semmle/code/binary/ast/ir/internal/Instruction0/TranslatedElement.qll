private import semmle.code.binary.ast.instructions as Raw
private import semmle.code.binary.ast.Location
private import codeql.controlflow.SuccessorType
private import semmle.code.binary.ast.ir.internal.Tags
private import InstructionTag
private import TempVariableTag
private import Instruction
private import semmle.code.binary.ast.ir.internal.Opcode as Opcode
private import codeql.util.Either
private import TranslatedInstruction
private import TranslatedOperand
private import Variable
private import codeql.util.Option
private import TranslatedFunction

class Opcode = Opcode::Opcode;

/**
 * Holds if the instruction `instr` should be translated into IR.
 */
private predicate shouldTranslateX86Instr(Raw::X86Instruction instr) { any() }

/**
 * Holds if the operand `operand` should be translated into IR.
 */
private predicate shouldTranslateX86Operand(Raw::X86Operand operand) {
  // If it has a target we will synthesize an instruction reference instruction
  // instead of translating the operand directly.
  not exists(operand.getUse().(Raw::X86Jmp).getTarget())
}

/**
 * Holds if the instruction `instr` should be translated into IR.
 */
private predicate shouldTranslateCilInstr(Raw::CilInstruction instr) { any() }

/**
 * Holds if the method `m` should be translated into IR.
 */
private predicate shouldTranslateMethod(Raw::CilMethod m) { any() }

/**
 * Holds if the parameter `p` should be translated into IR.
 */
private predicate shouldTranslateCilParameter(Raw::CilParameter p) { any() }

private predicate shouldTranslatedCilType(Raw::CilType t) { any() }

/**
 * Holds if the JVM instruction `instr` should be translated into IR.
 */
private predicate shouldTranslateJvmInstr(Raw::JvmInstruction instr) { any() }

/**
 * Holds if the JVM method `m` should be translated into IR.
 */
private predicate shouldTranslateJvmMethod(Raw::JvmMethod m) { any() }

/**
 * Holds if the JVM parameter `p` should be translated into IR.
 */
private predicate shouldTranslateJvmParameter(Raw::JvmParameter p) { any() }

/**
 * Holds if the JVM type `t` should be translated into IR.
 */
private predicate shouldTranslateJvmType(Raw::JvmType t) { any() }

/**
 * The "base type" for all translated elements.
 *
 * To add support for a new instruction do the following:
 * - Define a new branch of this type.
 * - Add a new class in `TranslatedInstruction.qll` that extends `TranslatedInstruction` (or
 * a more specific subclass such as `TranslatedX86Instruction`. `TranslatedCilInstruction`, etc).
 * - Implement the abstract predicates required by the base class. Pay special attention to whether
 * you also need to implement certain predicates that have a default `none()` implementation. This
 * is necessary when you want to define a new temporary variable or local variable that is written
 * to by the instruction.
 */
newtype TTranslatedElement =
  TTranslatedX86Function(Raw::X86Instruction entry) {
    shouldTranslateX86Instr(entry) and
    (
      entry = any(Raw::X86Call call).getTarget()
      or
      entry instanceof Raw::X86ProgramEntryInstruction
      or
      entry instanceof Raw::X86ExportedEntryInstruction
    )
  } or
  TTranslatedCilMethod(Raw::CilMethod m) { shouldTranslateMethod(m) } or
  TTranslatedX86SimpleBinaryInstruction(Raw::X86Instruction instr) {
    shouldTranslateX86Instr(instr) and
    isSimpleBinaryInstruction(instr, _, _)
  } or
  TTranslatedX86ImmediateOperand(Raw::X86ImmediateOperand op) { shouldTranslateX86Operand(op) } or
  TTranslatedX86RegisterOperand(Raw::X86RegisterOperand reg) { shouldTranslateX86Operand(reg) } or
  TTranslatedX86MemoryOperand(Raw::X86MemoryOperand mem) { shouldTranslateX86Operand(mem) } or
  TTranslatedX86Call(Raw::X86Call call) { shouldTranslateX86Instr(call) } or
  TTranslatedX86Jmp(Raw::X86Jmp jmp) { shouldTranslateX86Instr(jmp) and exists(jmp.getTarget()) } or
  TTranslatedX86Mov(Raw::X86Mov mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movsd(Raw::X86Movsd mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movq(Raw::X86Movq mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movss(Raw::X86Movss mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movzx(Raw::X86Movzx mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movsxd(Raw::X86Movsxd mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movsx(Raw::X86Movsx mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movdqu(Raw::X86Movdqu mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movdqa(Raw::X86Movdqa mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movaps(Raw::X86Movaps mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Movups(Raw::X86Movups mov) { shouldTranslateX86Instr(mov) } or
  TTranslatedX86Push(Raw::X86Push push) { shouldTranslateX86Instr(push) } or
  TTranslatedX86Test(Raw::X86Test test) { shouldTranslateX86Instr(test) } or
  TTranslatedX86ConditionalJump(Raw::X86ConditionalJumpInstruction cjmp) {
    shouldTranslateX86Instr(cjmp)
  } or
  TTranslatedX86Cmp(Raw::X86Cmp cmp) { shouldTranslateX86Instr(cmp) } or
  TTranslatedX86Lea(Raw::X86Lea lea) { shouldTranslateX86Instr(lea) } or
  TTranslatedX86Pop(Raw::X86Pop pop) { shouldTranslateX86Instr(pop) } or
  TTranslatedX86Ret(Raw::X86Ret ret) { shouldTranslateX86Instr(ret) } or
  TTranslatedX86Dec(Raw::X86Dec dec) { shouldTranslateX86Instr(dec) } or
  TTranslatedX86Inc(Raw::X86Inc inc) { shouldTranslateX86Instr(inc) } or
  TTranslatedX86Nop(Raw::X86Nop nop) { shouldTranslateX86Instr(nop) } or
  TTranslatedX86Bt(Raw::X86Bt bt) { shouldTranslateX86Instr(bt) } or
  TTranslatedX86Btr(Raw::X86Btr btr) { shouldTranslateX86Instr(btr) } or
  TTranslatedX86Neg(Raw::X86Neg neg) { shouldTranslateX86Instr(neg) } or
  TTranslatedCilNop(Raw::CilNop nop) { shouldTranslateCilInstr(nop) } or
  TTranslatedCilLdc(Raw::CilLoadConstant ldc) { shouldTranslateCilInstr(ldc) } or
  TTranslatedCilStloc(Raw::CilStoreLocal stloc) { shouldTranslateCilInstr(stloc) } or
  TTranslatedCilLdloc(Raw::CilLoadLocal ldloc) { shouldTranslateCilInstr(ldloc) } or
  TTranslatedCilUnconditionalBranch(Raw::CilUnconditionalBranchInstruction br) {
    shouldTranslateCilInstr(br)
  } or
  TTranslatedCilArithmeticInstruction(Raw::CilArithmeticInstruction arith) {
    shouldTranslateCilInstr(arith)
  } or
  TTranslatedCilRelationalInstruction(Raw::CilRelationalInstruction rel) {
    shouldTranslateCilInstr(rel)
  } or
  TTranslatedCilBooleanBranchInstruction(Raw::CilBooleanBranchInstruction cbr) {
    shouldTranslateCilInstr(cbr)
  } or
  TTranslatedCilRet(Raw::CilIl_ret ret) { shouldTranslateCilInstr(ret) } or
  TTranslatedCilCall(Raw::CilCall call) { shouldTranslateCilInstr(call) } or
  TTranslatedCilLoadString(Raw::CilLdstr ldstr) { shouldTranslateCilInstr(ldstr) } or
  TTranslatedCilParameter(Raw::CilParameter param) { shouldTranslateCilParameter(param) } or
  TTranslatedCilLoadArg(Raw::CilLoadArgument ldstr) { shouldTranslateCilInstr(ldstr) } or
  TTranslatedCilLoadIndirect(Raw::CilLoadIndirectInstruction ldind) {
    shouldTranslateCilInstr(ldind)
  } or
  TTranslatedCilStoreIndirect(Raw::CilStoreIndirectInstruction stind) {
    shouldTranslateCilInstr(stind)
  } or
  TTranslatedCilType(Raw::CilType type) { shouldTranslatedCilType(type) } or
  TTranslatedNewObject(Raw::CilNewobj newObj) { shouldTranslateCilInstr(newObj) } or
  TTranslatedDup(Raw::CilDup dup) { shouldTranslateCilInstr(dup) } or
  TTranslatedCilStoreField(Raw::CilStfld store) { shouldTranslateCilInstr(store) } or
  TTranslatedCilLoadField(Raw::CilLdfld load) { shouldTranslateCilInstr(load) } or
  // JVM translated elements
  TTranslatedJvmMethod(Raw::JvmMethod m) { shouldTranslateJvmMethod(m) } or
  TTranslatedJvmType(Raw::JvmType t) { shouldTranslateJvmType(t) } or
  TTranslatedJvmParameter(Raw::JvmParameter p) { shouldTranslateJvmParameter(p) } or
  TTranslatedJvmInvoke(Raw::JvmInvoke invoke) { shouldTranslateJvmInstr(invoke) } or
  TTranslatedJvmReturn(Raw::JvmReturn ret) { shouldTranslateJvmInstr(ret) } or
  TTranslatedJvmLoadLocal(Raw::JvmLoadLocal load) { shouldTranslateJvmInstr(load) } or
  TTranslatedJvmStoreLocal(Raw::JvmStoreLocal store) { shouldTranslateJvmInstr(store) } or
  TTranslatedJvmBranch(Raw::JvmConditionalBranch branch) { shouldTranslateJvmInstr(branch) } or
  TTranslatedJvmGoto(Raw::JvmUnconditionalBranch goto) { shouldTranslateJvmInstr(goto) } or
  TTranslatedJvmArithmetic(Raw::JvmArithmeticInstruction arith) { shouldTranslateJvmInstr(arith) } or
  TTranslatedJvmFieldAccess(Raw::JvmFieldAccess field) { shouldTranslateJvmInstr(field) } or
  TTranslatedJvmNew(Raw::JvmNew newObj) { shouldTranslateJvmInstr(newObj) } or
  TTranslatedJvmDup(Raw::JvmDupInstruction dup) { shouldTranslateJvmInstr(dup) } or
  TTranslatedJvmPop(Raw::JvmPopInstruction pop) { shouldTranslateJvmInstr(pop) } or
  TTranslatedJvmNop(Raw::JvmNop nop) { shouldTranslateJvmInstr(nop) } or
  TTranslatedJvmLoadConstant(Raw::JvmLoadConstant ldc) { shouldTranslateJvmInstr(ldc) }

TranslatedElement getTranslatedElement(Raw::Element raw) {
  result.getRawElement() = raw and
  result.producesResult()
}

TranslatedInstruction getTranslatedInstruction(Raw::Element raw) {
  result.getRawElement() = raw and
  result.producesResult()
}

TranslatedCilInstruction getTranslatedCilInstruction(Raw::CilInstruction raw) {
  result.getRawElement() = raw and
  result.producesResult()
}

TranslatedJvmInstruction getTranslatedJvmInstruction(Raw::JvmInstruction raw) {
  result.getRawElement() = raw and
  result.producesResult()
}

abstract class TranslatedElement extends TTranslatedElement {
  /**
   * Holds if this translated element generated an instruction with opcode `opcode` that stores
   * the result of the instruction in `v` (unless `v.isNone()` holds. In that case the instruction
   * does not produce a result).
   *
   * To obtain the instruction of this `TranslatedElement`, use `this.getInstruction(tag)`.
   */
  abstract predicate hasInstruction(Opcode opcode, InstructionTag tag, Option<Variable>::Option v);

  /**
   * Holds if this translated elements generates a temporary variable with the given tag.
   *
   * The variable is "temporary" in the sense that two different translated elements may reuse
   * the `tag` and they will refer to different variables. This is unlike local variables, which
   * are unique per function.
   */
  predicate hasTempVariable(TempVariableTag tag) { none() }

  /**
   * Holds if this translated element generates a `CJump` instruction when given the tag `tag`, and
   * the condition kind of the jump is `kind`.
   */
  predicate hasJumpCondition(InstructionTag tag, Opcode::ConditionKind kind) { none() }

  /**
   * Holds if this translated element generates a local variable with the given tag.
   */
  predicate hasLocalVariable(LocalVariableTag tag) { none() }

  /**
   * Gets the local variable with the given tag.
   */
  final Variable getLocalVariable(LocalVariableTag tag) {
    result = TLocalVariable(this.getEnclosingFunction(), tag)
  }

  /**
   * Gets the temporary variable with the given tag.
   */
  Variable getTempVariable(TempVariableTag tag) { result = TTempVariable(this, tag) }

  /**
   * Gets the instruction with the given tag.
   */
  final Instruction getInstruction(InstructionTag tag) { result = MkInstruction(this, tag) }

  /**
   * Gets the constant value of the instruction with the given tag. This `tag` must refer to
   * a constant instruction (that is, an instruction for which `hasInstruction(Opcode::Const, tag, _)`
   * holds.).
   */
  int getConstantValue(InstructionTag tag) { none() }

  /**
   * Gets the string constant of the instruction with the given tag. This `tag` must refer to
   * a string constant instruction (that is, an instruction for which `hasInstruction(Opcode::Const, tag, _)`
   * holds.)
   */
  string getStringConstant(InstructionTag tag) { none() }

  /**
   * Gets the external name referenced by the instruction with the given tag. This `tag` must refer to
   * an `ExternalRef` (that is, an instruction for which `hasInstruction(Opcode::ExternalRef, tag, _)`
   * holds.)
   */
  string getExternalName(InstructionTag tag) { none() }

  /**
   * Gets the name of the field referenced by an instruction with the given tag. This `tag` must refer to
   * a `FieldAddress` instruction (that is, an instruction for which
   * `hasInstruction(Opcode::FieldAddress, tag, _)` holds.)
   */
  string getFieldName(InstructionTag tag) { none() }

  /**
   * Gets the raw element that this translated element is a translation of.
   *
   * This predicate is important for linking back to the original AST.
   */
  abstract Raw::Element getRawElement();

  /**
   * Gets the instruction that should be the successor of the instruction with the given tag
   * and successor type. The successor type what kind of successor it is. In 99% of the cases
   * this will be a `DirectSuccessor` (to represent that we proceed to the next instruction in
   * the normal control flow). In case of conditional jumps, this may also be an
   * `BooleanSuccessor` to represent that we may proceed to one of two different instructions
   * depending on the value of a condition.
   */
  abstract Instruction getSuccessor(InstructionTag tag, SuccessorType succType);

  /**
   * Gets the successor instruction of the given child translated element for the given successor type.
   * This predicate is rarely used for translating CIL instructions since they tend to not have children
   * (but rather have simple integer operands). For X86 instructions with complex operands (such as memory
   * operands) this predicate is used.
   */
  abstract Instruction getChildSuccessor(TranslatedElement child, SuccessorType succType);

  /**
   * Gets the variable referred to by the `operandTag` operand of the instruction with the given `tag`.
   * An operand _must_ refer to exactly 1 operand.
   */
  abstract Variable getVariableOperand(InstructionTag tag, OperandTag operandTag);

  /**
   * Holds if this is the translated element that produces the result of an instruction/operand. For a given
   * instruction there should be exactly one `TranslatedElement` for which:
   * 1. `getRawElement()` returns the instruction, and
   * 2. ``producesResult()`` holds.
   */
  abstract predicate producesResult();

  /**
   * Gets the variable that holds the result after executing the instruction represented by this
   * translated element.
   */
  abstract Variable getResultVariable();

  abstract string toString();

  abstract string getDumpId();

  /**
   * Gets the `TranslatedFunction` that is called when `tag` represents a call instruction.
   */
  TranslatedFunction getStaticCallTarget(InstructionTag tag) { none() }

  /**
   * Gets the enclosing translated function of this translated element.
   */
  abstract TranslatedFunction getEnclosingFunction();

  abstract Location getLocation();
}

/**
 * Holds if the translated element `te` has an instruction with the given `tag`.
 */
predicate hasInstruction(TranslatedElement te, InstructionTag tag) { te.hasInstruction(_, tag, _) }

/**
 * Holds if the translated element `te` has a temporary variable with the given `tag`.
 */
predicate hasTempVariable(TranslatedElement te, TempVariableTag tag) { te.hasTempVariable(tag) }

/**
 * Holds if the translated element `te` has a local variable with the given `tag`.
 */
predicate hasLocalVariable(TranslatedFunction tf, LocalVariableTag tag) {
  exists(TranslatedElement te |
    te.getEnclosingFunction() = tf and
    te.hasLocalVariable(tag)
  )
}
