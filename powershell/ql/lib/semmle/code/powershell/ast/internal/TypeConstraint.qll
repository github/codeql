private import AstImport

class TypeConstraint extends Ast, TTypeConstraint {
  string getName() { result = getRawAst(this).(Raw::TypeConstraint).getName() }

  override string toString() { result = this.getName() }
}
