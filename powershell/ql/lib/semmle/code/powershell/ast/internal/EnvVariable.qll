private import AstImport

class EnvVariable extends Expr, TEnvVariable {
  final override string toString() { result = this.getName() }

  string getName() { any(Synthesis s).envVariableName(this, result) }
}

class SystemDrive extends EnvVariable {
  SystemDrive() { this.getName() = "systemdrive" }
}