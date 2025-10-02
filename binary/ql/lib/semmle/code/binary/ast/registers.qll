import binary

class Register extends @register {
  RegisterAccess getAnAccess() { result.getTarget() = this }

  string toString() { register(this, result) }
}

class RipRegister extends Register {
  RipRegister() { register(this, "rip") }
}

class RspRegister extends Register {
  RspRegister() { register(this, "rsp") }
}

class RbpRegister extends Register {
  RbpRegister() { register(this, "rbp") }
}
