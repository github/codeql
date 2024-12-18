private import codeql.swift.generated.stmt.CaseLabelItem

module Impl {
  class CaseLabelItem extends Generated::CaseLabelItem {
    override string toString() {
      if this.hasGuard()
      then result = this.getPattern().toString() + " where ..."
      else result = this.getPattern().toString()
    }
  }
}
