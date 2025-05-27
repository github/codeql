/**
 * This module provides a hand-modifiable wrapper around the generated class `RefExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.RefExpr
private import codeql.rust.elements.internal.OperationImpl::Impl as OperationImpl

/**
 * INTERNAL: This module contains the customizable definition of `RefExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A reference expression. For example:
   * ```rust
   *     let ref_const = &foo;
   *     let ref_mut = &mut foo;
   *     let raw_const: &mut i32 = &raw const foo;
   *     let raw_mut: &mut i32 = &raw mut foo;
   * ```
   */
  class RefExpr extends Generated::RefExpr, OperationImpl::Operation {
    override string toStringImpl() {
      result = "&" + concat(int i | | this.getSpecPart(i), " " order by i)
    }

    override string getOperatorName() { result = "&" }

    override int getNumberOfOperands() { result = 1 }

    override Expr getOperand(int n) { n = 0 and result = this.getExpr() }

    private string getSpecPart(int index) {
      index = 0 and this.isRaw() and result = "raw"
      or
      index = 1 and this.isConst() and result = "const"
      or
      index = 2 and this.isMut() and result = "mut"
      or
      index = 3 and result = this.getExpr().toAbbreviatedString()
    }
  }
}
