private import instructions
private import registers

class Operand extends @operand, Element {
  final override string toString() { operand_string(this, result) }

  Instruction getUse() { result.getAnOperand() = this }

  Function getEnclosingFunction() { result = this.getUse().getEnclosingFunction() }

  int getIndex() { this = this.getUse().getOperand(result) }
}

class RegisterAccess extends @register_access {
  Register getTarget() { register_access(this, result) }

  string toString() { result = this.getTarget().toString() }

  RegisterOperand getDirectUse() { result.getAccess() = this }

  Operand getUse() {
    exists(RegisterOperand ro |
      ro.getAccess() = this and
      result = ro
    )
    or
    exists(MemoryOperand mo |
      [mo.getBaseRegister(), mo.getIndexRegister(), mo.getSegmentRegister()] = this and
      result = mo
    )
  }

  Function getEnclosingFunction() { result = this.getUse().getEnclosingFunction() }
}

class UnusedOperand extends Operand {
  UnusedOperand() { operand_unused(this) }
}

class RegisterOperand extends Operand {
  RegisterOperand() { operand_reg(this, _) }

  RegisterAccess getAccess() { operand_reg(this, result) }

  Register getRegister() { result = this.getAccess().getTarget() }
}

class MemoryOperand extends Operand {
  MemoryOperand() { operand_mem(this) }

  predicate hasDisplacement() { operand_mem_displacement(this, _) }

  RegisterAccess getSegmentRegister() { operand_mem_segment_register(this, result) }

  RegisterAccess getBaseRegister() { operand_mem_base_register(this, result) }

  RegisterAccess getIndexRegister() { operand_mem_index_register(this, result) }

  int getScaleFactor() { operand_mem_scale_factor(this, result) }

  int getDisplacementValue() { operand_mem_displacement(this, result) }
}

class DisplacedMemoryOperand extends MemoryOperand {
  DisplacedMemoryOperand() { this.hasDisplacement() }
}

class PointerOperand extends Operand {
  PointerOperand() { operand_ptr(this, _, _) }
}

class ImmediateOperand extends Operand {
  ImmediateOperand() { operand_imm(this, _, _, _) }

  int getValue() { operand_imm(this, result, _, _) }

  predicate isSigned() { operand_imm_is_signed(this) }

  predicate isAddress() { operand_imm_is_address(this) }

  predicate isRelative() { operand_imm_is_relative(this) }
}

class SignedImmediateOperand extends ImmediateOperand {
  SignedImmediateOperand() { this.isSigned() }
}

class AddressImmediateOperand extends ImmediateOperand {
  AddressImmediateOperand() { this.isAddress() }
}

class RelativeImmediateOperand extends ImmediateOperand {
  RelativeImmediateOperand() { this.isRelative() }
}
