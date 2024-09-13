private import codeql.swift.generated.decl.MissingMemberDecl

module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A placeholder for missing declarations that can arise on object deserialization.
   */
  class MissingMemberDecl extends Generated::MissingMemberDecl {
    override string toString() { result = this.getName() + " (missing)" }
  }
}
