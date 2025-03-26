private import AstImport

class PropertyMember extends Member, TPropertyMember {
  final override string getName() { result = getRawAst(this).(Raw::PropertyMember).getName() }

  final override string toString() { result = this.getName() }
}
