private import AstImport

class PropertyMember extends Member, TPropertyMember {
  final override string getLowerCaseName() { result = getRawAst(this).(Raw::PropertyMember).getName().toLowerCase() }

  final override string toString() { result = this.getLowerCaseName() }
}
