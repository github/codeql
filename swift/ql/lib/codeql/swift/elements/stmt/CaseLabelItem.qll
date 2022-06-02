private import codeql.swift.generated.stmt.CaseLabelItem

class CaseLabelItem extends CaseLabelItemBase {
  override string toString() {
    if this.hasGuard()
    then result = this.getPattern().toString() + " where ..."
    else result = this.getPattern().toString()
  }
}
