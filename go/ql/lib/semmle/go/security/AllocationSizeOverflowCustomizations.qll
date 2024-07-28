/**
 * Provides default sources, sinks, and sanitizers for reasoning about allocation-size overflows,
 * as well as extension points for adding your own.
 */

import go

/**
 * Provides extension points for customizing the taint-tracking configuration for reasoning
 * about allocation-size overflow.
 */
module AllocationSizeOverflow {
  /**
   * A source of data that might cause an allocation-size overflow.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data-flow node where an overflow might occur, and whose result is used to compute
   * an allocation size.
   */
  abstract class Sink extends DataFlow::Node {
    /** Gets the allocation size which is influenced by the result of this node. */
    abstract DataFlow::Node getAllocationSize();
  }

  /**
   * A sanitizer node that prevents allocation-size overflow.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A data-flow node that is an operand to an operation that may overflow.
   */
  abstract class OverflowProneOperand extends DataFlow::Node { }

  /**
   * A data-flow node that represents the size argument of an allocation, such as the `n` in
   * `make([]byte, n)`.
   */
  abstract class AllocationSize extends DataFlow::Node { }

  /** A call to a marshaling function, considered as a source of taint. */
  class MarshalingSource extends Source {
    MarshalingSource() {
      exists(MarshalingFunction marshal, DataFlow::CallNode call |
        // Binding order tweak: start with marshalling function calls then work outwards:
        pragma[only_bind_into](call) = marshal.getACall() and
        // rule out cases where we can tell that the result will always be small
        exists(FunctionInput inp | inp = marshal.getAnInput() | isBig(inp.getNode(call).asExpr())) and
        this = marshal.getOutput().getNode(call)
      )
    }
  }

  /**
   * A call to a function that reads from the file system or a stream, considered as
   * a source of taint.
   */
  class FileReadSource extends Source {
    FileReadSource() {
      exists(Function read |
        read.hasQualifiedName("io/ioutil", "ReadAll") or
        read.hasQualifiedName("io/ioutil", "ReadFile")
      |
        this = DataFlow::extractTupleElement(read.getACall(), 0)
      )
    }
  }

  private predicate allocationSizeCheck(DataFlow::Node g, Expr e, boolean branch) {
    exists(DataFlow::Node lesser |
      g.(DataFlow::RelationalComparisonNode).leq(branch, lesser, _, _) and
      not lesser.isConst() and
      globalValueNumber(DataFlow::exprNode(e)) = globalValueNumber(lesser)
    )
  }

  /** A check of the allocation size, acting as a guard to prevent allocation-size overflow. */
  class AllocationSizeCheckBarrier extends DataFlow::Node {
    AllocationSizeCheckBarrier() {
      this = DataFlow::BarrierGuard<allocationSizeCheck/3>::getABarrierNode()
    }
  }

  /**
   * An arithmetic operation that might overflow, and whose result is used to compute an
   * allocation size.
   */
  class DefaultSink extends Sink {
    AllocationSize allocsz;

    DefaultSink() {
      this instanceof OverflowProneOperand and
      localStep*(this, allocsz) and
      not allocsz instanceof AllocationSizeCheckBarrier
    }

    override DataFlow::Node getAllocationSize() { result = allocsz }
  }

  private predicate lengthCheck(DataFlow::Node g, Expr e, boolean branch) {
    exists(DataFlow::CallNode lesser |
      g.(DataFlow::RelationalComparisonNode).leq(branch, lesser, _, _)
    |
      lesser = Builtin::len().getACall() and
      globalValueNumber(DataFlow::exprNode(e)) = globalValueNumber(lesser.getArgument(0))
    )
  }

  /** A length check, acting as a guard to prevent allocation-size overflow. */
  class LengthCheckSanitizer extends Sanitizer {
    LengthCheckSanitizer() { this = DataFlow::BarrierGuard<lengthCheck/3>::getABarrierNode() }
  }

  /**
   * A conversion to a 64-bit type, acting as a sanitizer to mitigate the risk of allocation-size
   * overflow.
   *
   * Such conversions do not really protect against overflow, but code bases dealing with strings
   * or slices large enough to overflow 64 bits are likely to encounter other problems before the
   * overflow happens.
   */
  class WidenTo64BitSanitizer extends Sanitizer {
    WidenTo64BitSanitizer() { this.getType().(NumericType).getSize() >= 64 }
  }

  /** Holds if `e` is an arithmetic expression that could cause overflow. */
  private predicate isOverflowProne(ArithmeticBinaryExpr e) {
    (e instanceof AddExpr or e instanceof MulExpr) and
    // rule out string concatenation and floating-point operations
    e.getType() instanceof IntegerType
  }

  /** An operand of an arithmetic expression that could cause overflow. */
  private class DefaultOverflowProneOperand extends OverflowProneOperand {
    DefaultOverflowProneOperand() {
      exists(OperatorExpr parent | isOverflowProne(parent) |
        this.asExpr() = parent.getAnOperand() and
        // only consider outermost operands to avoid double reporting
        not exists(OperatorExpr grandparent | parent = grandparent.getAnOperand().stripParens() |
          isOverflowProne(grandparent)
        )
      )
    }
  }

  /**
   * The first or second (non-type) argument to a call to `make`, considered as an allocation size.
   */
  private class DefaultAllocationSize extends AllocationSize {
    DefaultAllocationSize() { this = Builtin::make().getACall().getArgument([0 .. 1]) }
  }

  /** Holds if `t` is a type whose values are likely to marshal to relatively small blobs. */
  private predicate isSmallType(Type t) {
    t instanceof BasicType and
    not t instanceof StringType
    or
    isSmallType(t.(NamedType).getUnderlyingType())
    or
    isSmallType(t.(PointerType).getBaseType())
    or
    isSmallType(t.(ArrayType).getElementType())
    or
    exists(StructType st | st = t | forall(Field f | f = st.getField(_) | isSmallType(f.getType())))
  }

  /** Holds if `e` is an expression whose values might marshal to relatively large blobs. */
  private predicate isBig(Expr e) {
    not isSmallType(e.getType()) and
    not e.isConst()
    or
    exists(KeyValueExpr kv | kv = e |
      isBig(kv.getKey()) or
      isBig(kv.getValue())
    )
    or
    isBig(e.(CompositeLit).getAnElement())
  }

  /**
   * Holds if the value of `pred` can flow into `succ` in one step, either through a call to `len`
   * or through an arithmetic operation (other than remainder).
   */
  predicate additionalStep(DataFlow::Node pred, DataFlow::Node succ) {
    succ.asExpr().(ArithmeticExpr).getAnOperand() = pred.asExpr() and
    not succ.asExpr() instanceof RemExpr
  }

  /**
   * Holds if the value of `pred` can flow into `succ` in one step, either by a standard taint step
   * or by an additional step.
   */
  private predicate localStep(DataFlow::Node pred, DataFlow::Node succ) {
    TaintTracking::localTaintStep(pred, succ) or
    additionalStep(pred, succ)
  }
}
