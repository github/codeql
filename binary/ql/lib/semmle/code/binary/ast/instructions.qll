private import internal.X86Instructions as Internal
private import binary
private import Headers
private import Sections
private import codeql.util.Unit

private class TElement =
  @x86_instruction or @operand or @il_instruction or @method or @il_parameter or @type or
      @jvm_instruction or @jvm_parameter;

class Element extends TElement {
  final string toString() { none() }
}

private class X86InstructionElement extends Element, @x86_instruction {
  final string toString() {
    exists(string sInstr |
      instruction_string(this, sInstr) and
      result =
        sInstr + " " +
          concat(Element op, int i, string sOp |
            operand(op, this, i, _) and operand_string(op, sOp)
          |
            sOp, ", " order by i
          )
    )
  }
}

private class X86OperandElement extends Element, @operand {
  final string toString() { operand_string(this, result) }
}

private class IlInstructionElement extends Element, @il_instruction {
  final string toString() { instruction_string(this, result) }
}

private class CilMethodElement extends Element, @method {
  final string toString() { methods(this, result, _, _) }
}

private class CilParameterElement extends Element, @il_parameter {
  final string toString() { il_parameter(this, _, _, result) }
}

private class TypeElement extends Element, @type {
  final string toString() { types(this, result, _, _) }
}

private class JvmInstructionElement extends Element, @jvm_instruction {
  final string toString() { instruction_string(this, result) }
}

private class JvmParameterElement extends Element, @jvm_parameter {
  final string toString() { jvm_parameter(this, _, _, result, _) }
}

import internal.X86Instructions
import internal.CilInstructions
import internal.JvmInstructions
