private import codeql.swift.generated.stmt.CaseLabelItem

module Impl {
  class CaseLabelItem extends Generated::CaseLabelItem {
    override string toStringImpl() {
      if this.hasGuard()
      then result = this.getPattern().toStringImpl() + " where ..."
      else result = this.getPattern().toStringImpl()
    }
  }
}
