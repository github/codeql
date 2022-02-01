/**
 * @name Use detect
 * @description Use 'detect' instead of 'select' followed by 'first' or 'last'.
 * @kind problem
 * @problem.severity warning
 * @id rb/use-detect
 * @tags performance rubocop
 * @precision high
 */

// This is an implementation of the Rubocop rule
// https://github.com/rubocop/rubocop-performance/blob/master/lib/rubocop/cop/performance/detect.rb
import ruby
import codeql.ruby.dataflow.SSA

/** A call that extracts the first or last element of a list. */
class EndCall extends MethodCall {
  string detect;

  EndCall() {
    detect = "detect" and
    (
      this.getMethodName() = "first" and
      this.getNumberOfArguments() = 0
      or
      this.getNumberOfArguments() = 1 and
      this.getArgument(0).getConstantValue().isInt(0)
    )
    or
    detect = "reverse_detect" and
    (
      this.getMethodName() = "last" and
      this.getNumberOfArguments() = 0
      or
      this.getNumberOfArguments() = 1 and
      this.getArgument(0).getConstantValue().isInt(-1)
    )
  }

  string detectCall() { result = detect }
}

Expr getUniqueRead(Expr e) {
  exists(AssignExpr ae |
    e = ae.getRightOperand() and
    forex(Ssa::WriteDefinition def | def.getWriteAccess() = ae.getLeftOperand() |
      strictcount(def.getARead()) = 1 and
      not def = any(Ssa::PhiNode phi).getAnInput() and
      def.getARead() = result.getAControlFlowNode()
    )
  )
}

class SelectBlock extends MethodCall {
  SelectBlock() {
    this.getMethodName() in ["select", "filter", "find_all"] and
    exists(this.getBlock())
  }
}

from EndCall call, SelectBlock selectBlock
where getUniqueRead*(selectBlock) = call.getReceiver()
select call, "Replace this call and $@ with '" + call.detectCall() + "'.", selectBlock,
  "'select' call"
