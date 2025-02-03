import go

/** The constant `math.MaxInt` or the constant `math.MaxUint`. */
abstract private class MaxIntOrMaxUint extends DeclaredConstant {
  /**
   * Gets the (binary) order of magnitude when the architecture has bit size
   * `architectureBitSize`, which is defined to be the integer `x` such that
   * `2.pow(x) - 1` is the value of this constant.
   */
  abstract int getOrder(int architectureBitSize);

  /**
   * Holds if the value of this constant given `architectureBitSize` minus
   * `strictnessOffset` is less than or equal to `2.pow(b) - 1`.
   */
  predicate isBoundFor(int b, int architectureBitSize, float strictnessOffset) {
    // 2.pow(x) - 1 - strictnessOffset <= 2.pow(b) - 1
    // For the values that we are restricting `b` to, `strictnessOffset` has no
    // effect on the result, so we can ignore it.
    b = validBitSize() and
    strictnessOffset = [0, 1] and
    this.getOrder(architectureBitSize) <= b
  }
}

/** The constant `math.MaxInt`. */
private class MaxInt extends MaxIntOrMaxUint {
  MaxInt() { this.hasQualifiedName("math", "MaxInt") }

  override int getOrder(int architectureBitSize) {
    architectureBitSize = [32, 64] and result = architectureBitSize - 1
  }
}

/** The constant `math.MaxUint`. */
private class MaxUint extends MaxIntOrMaxUint {
  MaxUint() { this.hasQualifiedName("math", "MaxUint") }

  override int getOrder(int architectureBitSize) {
    architectureBitSize = [32, 64] and result = architectureBitSize
  }
}

/**
 * Get the size of `int` or `uint` in `file`, or
 * `architectureSpecificBitSize` if it is architecture-specific.
 */
bindingset[architectureSpecificBitSize]
int getIntTypeBitSize(File file, int architectureSpecificBitSize) {
  file.constrainsIntBitSize(result)
  or
  not file.constrainsIntBitSize(_) and
  result = architectureSpecificBitSize
}

private int validBitSize() { result = [7, 8, 15, 16, 31, 32, 63, 64] }

private newtype TArchitectureBitSize =
  TMk32Bit() or
  TMk64Bit() or
  TMkUnknown()

private class ArchitectureBitSize extends TArchitectureBitSize {
  /** Gets an integer for the architecture bit size, if known. */
  int toInt() {
    this = TMk32Bit() and result = 32
    or
    this = TMk64Bit() and result = 64
  }

  /** Holds if the architecture bit size is unknown. */
  predicate isUnknown() { this = TMkUnknown() }

  /** Gets a textual representation of this element. */
  string toString() {
    result = this.toInt() + "-bit"
    or
    this.isUnknown() and result = "unknown"
  }
}

private newtype TMaxValueState =
  TMkMaxValueState(int bitSize, ArchitectureBitSize architectureBitSize) {
    bitSize = validBitSize()
  }

/** Flow state for ConversionWithoutBoundsCheckConfig. */
private class MaxValueState extends TMaxValueState {
  /**
   * Gets the smallest bitsize where the maximum value that could get to this
   * point fits into an integer type whose maximum value is 2^(result) - 1.
   *
   * For example, if we know `1 << 12` can get to a particular program point,
   * then the result would be 15, since a 16-bit signed integer can represent
   * that value and that type has maximum value 2^15 -1. An unsigned 8-bit
   * integer cannot represent that value as its maximum value is 2^8 - 1.
   */
  int getBitSize() { this = TMkMaxValueState(result, _) }

  private ArchitectureBitSize architectureBitSize() { this = TMkMaxValueState(_, result) }

  /** Gets whether the architecture is 32 bit or 64 bit, if it is known. */
  int getArchitectureBitSize() { result = this.architectureBitSize().toInt() }

  /** Holds if the architecture is not known. */
  predicate architectureBitSizeUnknown() { this.architectureBitSize().isUnknown() }

  /**
   * Gets the bitsize we should use for a sink of type `uint`.
   *
   * If the architecture bit size is known, then we should use that. Otherwise,
   * we should use 32 bits, because that will find results that only exist on
   * 32-bit architectures.
   */
  int getSinkBitSize() {
    if this = TMkMaxValueState(_, TMk64Bit()) then result = 64 else result = 32
  }

  /** Gets a textual representation of this element. */
  string toString() {
    exists(string suffix |
      suffix = " (on " + this.getArchitectureBitSize() + "-bit architecture)"
      or
      this.architectureBitSizeUnknown() and suffix = ""
    |
      result = "MaxValueState(max value <= 2^(" + this.getBitSize() + ")-1" + suffix
    )
  }
}

/**
 * A node that blocks some flow states and transforms some others as they flow
 * through it.
 */
abstract class FlowStateTransformer extends DataFlow::Node {
  /**
   * Holds if this should be a barrier for a flow state with bit size `bitSize`
   * and architecture bit size `architectureBitSize`.
   *
   * This includes flow states which are transformed into other flow states.
   */
  abstract predicate barrierFor(int bitSize, int architectureBitSize);

  /**
   * Gets the flow state that `flowstate` is transformed into.
   *
   * Due to limitations of the implementation the transformation defined by this
   * predicate must be idempotent, that is, for any input `x` it must be that:
   * ```
   * transform(transform(x)) = transform(x)
   * ```
   */
  MaxValueState transform(MaxValueState state) {
    this.barrierFor(state.getBitSize(), state.getSinkBitSize()) and
    result.getBitSize() =
      max(int bitsize |
        bitsize = validBitSize() and
        bitsize < state.getBitSize() and
        not this.barrierFor(bitsize, state.getSinkBitSize())
      ) and
    (
      result.getArchitectureBitSize() = state.getArchitectureBitSize()
      or
      state.architectureBitSizeUnknown() and result.architectureBitSizeUnknown()
    )
  }
}

private predicate upperBoundCheckGuard(DataFlow::Node g, Expr e, boolean branch) {
  g.(UpperBoundCheckGuard).checks(e, branch)
}

/** An upper bound check that compares a variable to a constant value. */
class UpperBoundCheckGuard extends DataFlow::RelationalComparisonNode {
  UpperBoundCheckGuard() {
    // Note that even though `x > c` and `x >= c` do not look like upper bound
    // checks, on the branches where they are false the conditions are `x <= c`
    // and `x < c` respectively, which are upper bound checks.
    count(expr.getAnOperand().getExactValue()) = 1 and
    expr.getAnOperand().getType().getUnderlyingType() instanceof IntegerType
  }

  /**
   * Holds if this upper bound check should stop flow for a flow state with bit
   * size `bitSize` and architecture bit size `architectureBitSize`.
   *
   * A flow state has bit size `bitSize` if that is the smallest valid bit size
   * `b` such that the maximum value that could get to that point is less than
   * or equal to `2^(b) - 1`. So the flow should be stopped if there is a valid
   * bit size `b` which is less than `bitSize` such that the maximum value that
   * could get to that point is than or equal to `2^(b) - 1`. In this  case,
   * the upper bound check is a barrier guard, because the flow should have bit
   * size equal to the smallest such `b` instead of `bitSize`.
   *
   * The argument `architectureBitSize` is only used if the constant operand is
   * `math.MaxInt` or `math.MaxUint`.
   *
   * Note that we have to use floats here because integers in CodeQL are
   * represented by 32-bit signed integers, which cannot represent some of the
   * integer values which we will encounter.
   */
  predicate isBoundFor(int bitSize, int architectureBitSize) {
    bitSize = validBitSize() and
    architectureBitSize = [32, 64] and
    exists(int b, float strictnessOffset |
      // It is sufficient to check for the next valid bit size below `bitSize`.
      b = max(int a | a = validBitSize() and a < bitSize) and
      // We will use the format `x <= c - strictnessOffset`. Since `x < c` is
      // the same as `x <= c-1`, we set `strictnessOffset` to 1 in this case.
      // For `x >= c` we will be dealing with the case where the `branch`
      // argument of `checks` is false, which is equivalent to `x < c`.
      if expr instanceof LssExpr or expr instanceof GeqExpr
      then strictnessOffset = 1
      else strictnessOffset = 0
    |
      if expr.getAnOperand() = any(MaxIntOrMaxUint m).getAReference()
      then
        any(MaxIntOrMaxUint m | expr.getAnOperand() = m.getAReference())
            .isBoundFor(b, architectureBitSize, strictnessOffset)
      else
        // We want `x <= c - strictnessOffset` to guarantee that `x <= 2^b - 1`,
        // which is equivalent to saying `c - strictnessOffset <= 2^b - 1`.
        expr.getAnOperand().getExactValue().toFloat() - strictnessOffset <= 2.pow(b) - 1
    )
  }

  /** Holds if this guard validates `e` upon evaluating to `branch`. */
  predicate checks(Expr e, boolean branch) {
    this.leq(branch, DataFlow::exprNode(e), _, _) and
    not e.isConst()
  }
}

/**
 * A node that is safely guarded by an `UpperBoundCheckGuard`.
 *
 * When this guarantees that a variable in the non-constant operand is less
 * than some value this may be a barrier guard which should block some flow
 * states and transform some others as they flow through.
 *
 * For example, in the following code:
 * ```go
 * if parsed <= math.MaxInt16 {
 *   _ = uint16(parsed)
 * }
 * ```
 * `parsed <= math.MaxInt16` is an `UpperBoundCheckGuard` and `uint16(parsed)`
 * is an `UpperBoundCheck` that would be a barrier for flow states with bit
 * size greater than 15 and would transform them to a flow state with bit size
 * 15 and the same architecture bit size.
 *
 * However, in the following code:
 * ```go
 * parsed, _ := strconv.ParseUint(input, 10, 32)
 * if parsed < 5 {
 *   _ = uint16(parsed)
 * }
 * ```
 * `parsed < 5` is an `UpperBoundCheckGuard` and `uint16(parsed)` is a barrier
 * for all flow states and would not transform any flow states, thus
 * effectively blocking them.
 */
class UpperBoundCheck extends FlowStateTransformer {
  UpperBoundCheckGuard g;

  UpperBoundCheck() {
    this = DataFlow::BarrierGuard<upperBoundCheckGuard/3>::getABarrierNodeForGuard(g)
  }

  override predicate barrierFor(int bitSize, int architectureBitSize) {
    g.isBoundFor(bitSize, architectureBitSize)
  }
}

private predicate integerTypeBound(IntegerType it, int bitSize, int architectureBitSize) {
  bitSize = validBitSize() and
  architectureBitSize = [32, 64] and
  exists(int offset | if it instanceof SignedIntegerType then offset = 1 else offset = 0 |
    if it instanceof IntType or it instanceof UintType
    then bitSize >= architectureBitSize - offset
    else bitSize >= it.getSize() - offset
  )
}

/**
 * An expression which a type assertion guarantees will have a particular
 * integer type.
 *
 * If this is a checked type expression then this value will only be used if
 * the type assertion succeeded. If it is not checked then there will be a
 * run-time panic if the type assertion fails, so we can assume it succeeded.
 */
class TypeAssertionCheck extends DataFlow::ExprNode, FlowStateTransformer {
  IntegerType it;

  TypeAssertionCheck() {
    exists(TypeAssertExpr tae |
      this = DataFlow::exprNode(tae.getExpr()) and
      it = tae.getTypeExpr().getType().getUnderlyingType()
    )
  }

  override predicate barrierFor(int bitSize, int architectureBitSize) {
    integerTypeBound(it, bitSize, architectureBitSize)
  }
}

/**
 * The implicit definition of a variable with integer type for a case clause of
 * a type switch statement which declares a variable in its guard, which has
 * effectively had a checked type assertion.
 */
class TypeSwitchVarFlowStateTransformer extends DataFlow::SsaNode, FlowStateTransformer {
  IntegerType it;

  TypeSwitchVarFlowStateTransformer() {
    exists(IR::TypeSwitchImplicitVariableInstruction insn, LocalVariable lv | insn.writes(lv, _) |
      this.getSourceVariable() = lv and
      it = lv.getType().getUnderlyingType()
    )
  }

  override predicate barrierFor(int bitSize, int architectureBitSize) {
    integerTypeBound(it, bitSize, architectureBitSize)
  }
}

/**
 * Holds if `source` is the result of a call to `strconv.Atoi`,
 * `strconv.ParseInt`, or `strconv.ParseUint`, `bitSize` is the `bitSize`
 * argument to that call (or 0 for `strconv.Atoi`) and hence must be between 0
 * and 64, and `isSigned` is true for `strconv.Atoi`, true for
 * `strconv.ParseInt` and false for `strconv.ParseUint`.
 */
predicate isSourceWithBitSize(DataFlow::Node source, int bitSize, boolean isSigned) {
  exists(DataFlow::CallNode c, IntegerParser::Range ip, int apparentBitSize |
    c = ip.getACall() and
    source = c.getResult(0) and
    (
      apparentBitSize = ip.getTargetBitSize()
      or
      // If we are reading a variable, check if it is
      // `strconv.IntSize`, and use 0 if it is.
      exists(DataFlow::Node rawBitSize |
        rawBitSize = ip.getTargetBitSizeInput().getNode(c) and
        if rawBitSize = any(Strconv::IntSize intSize).getARead()
        then apparentBitSize = 0
        else apparentBitSize = rawBitSize.getIntValue()
      )
    ) and
    // Note that `bitSize` is not necessarily the bit-size of an integer type.
    // It can be any integer between 0 and 64.
    bitSize = replaceZeroWith(apparentBitSize, getIntTypeBitSize(source.getFile(), 0)) and
    isSigned = ip.isSigned()
  )
}

private module ConversionWithoutBoundsCheckConfig implements DataFlow::StateConfigSig {
  class FlowState = MaxValueState;

  predicate isSource(DataFlow::Node source, FlowState state) {
    exists(int effectiveBitSize, boolean sourceIsSigned |
      isSourceWithBitSize(source, effectiveBitSize, sourceIsSigned) and
      if effectiveBitSize = 0
      then
        exists(int b | b = [32, 64] |
          state.getBitSize() = adjustBitSize(0, sourceIsSigned, b) and
          state.getArchitectureBitSize() = b
        )
      else (
        state.architectureBitSizeUnknown() and
        state.getBitSize() =
          min(int bitsize |
            bitsize = validBitSize() and
            // The `bitSizeForZero` argument will not be used because on this
            // branch `effectiveBitSize != 0`.
            adjustBitSize(effectiveBitSize, sourceIsSigned, 64) <= bitsize
          )
      )
    )
  }

  /**
   * Holds if `sink` is a typecast to an integer type with size `bitSize` (where
   * 0 represents architecture-dependent) and the expression being typecast is
   * not also in a right-shift expression. We allow this case because it is
   * a common pattern to serialise `byte(v)`, `byte(v >> 8)`, and so on.
   */
  additional predicate isSink2(DataFlow::TypeCastNode sink, FlowState state) {
    sink.asExpr() instanceof ConversionExpr and
    exists(int architectureBitSize, IntegerType integerType, int sinkBitsize, boolean sinkIsSigned |
      architectureBitSize = getIntTypeBitSize(sink.getFile(), state.getSinkBitSize()) and
      not (state.getArchitectureBitSize() = 32 and architectureBitSize = 64) and
      sink.getResultType().getUnderlyingType() = integerType and
      (
        sinkBitsize = integerType.getSize()
        or
        not exists(integerType.getSize()) and
        sinkBitsize = 0
      ) and
      (
        if integerType instanceof SignedIntegerType
        then sinkIsSigned = true
        else sinkIsSigned = false
      ) and
      adjustBitSize(sinkBitsize, sinkIsSigned, architectureBitSize) < state.getBitSize()
    ) and
    not exists(ShrExpr shrExpr |
      shrExpr.getLeftOperand().getGlobalValueNumber() =
        sink.getOperand().asExpr().getGlobalValueNumber() or
      shrExpr.getLeftOperand().(AndExpr).getAnOperand().getGlobalValueNumber() =
        sink.getOperand().asExpr().getGlobalValueNumber()
    )
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    // We use the argument of the type conversion as the configuration sink so that we
    // can sanitize the result of the conversion to prevent flow on to further sinks
    // without needing to use `isSanitizerOut`, which doesn't work with flow states
    // (and therefore the legacy `TaintTracking::Configuration` class).
    isSink2(sink.getASuccessor(), state)
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    // Safely guarded by a barrier guard.
    exists(FlowStateTransformer fst |
      node = fst and
      fst.barrierFor(state.getBitSize(), state.getSinkBitSize())
    )
    or
    // When there is a flow from a source to a sink, do not allow the flow to
    // continue to a further sink.
    isSink2(node, state)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    // Create additional flow steps for `FlowStateTransformer`s
    state2 = node2.(FlowStateTransformer).transform(state1) and
    DataFlow::simpleLocalFlowStep(node1, node2, _)
  }
}

/**
 * Tracks taint flow from an integer obtained from parsing a string that flows
 * to a type conversion to a smaller integer type, which could cause data loss.
 */
module Flow = DataFlow::GlobalWithState<ConversionWithoutBoundsCheckConfig>;

/** Gets a string describing the size of the integer parsed. */
string describeBitSize2(DataFlow::Node source) {
  exists(int sourceBitSize, int intTypeBitSize, boolean isSigned, string signedString |
    isSourceWithBitSize(source, sourceBitSize, isSigned) and
    intTypeBitSize = getIntTypeBitSize(source.getFile(), 0)
  |
    (if isSigned = true then signedString = "a signed " else signedString = "an unsigned ") and
    if sourceBitSize != 0
    then result = signedString + sourceBitSize + "-bit integer"
    else
      if intTypeBitSize = 0
      then result = "an integer with architecture-dependent bit size"
      else
        result =
          "a number with architecture-dependent bit-width, which is constrained to be " +
            intTypeBitSize + "-bit by build constraints,"
  )
}

/**
 * The integer type with bit size `bitSize` and signedness `isSigned` has
 * maximum value `2^result - 1`.
 */
bindingset[bitSize, bitSizeForZero]
private int adjustBitSize(int bitSize, boolean isSigned, int bitSizeForZero) {
  exists(int effectiveBitSize | effectiveBitSize = replaceZeroWith(bitSize, bitSizeForZero) |
    isSigned = true and result = effectiveBitSize - 1
    or
    isSigned = false and result = effectiveBitSize
  )
}

bindingset[inputBitSize, replacementForZero]
private int replaceZeroWith(int inputBitSize, int replacementForZero) {
  if inputBitSize = 0 then result = replacementForZero else result = inputBitSize
}
