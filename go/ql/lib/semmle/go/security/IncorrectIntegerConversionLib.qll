import go

/**
 * Gets the maximum value of an integer (signed if `isSigned`
 * is true, unsigned otherwise) with `bitSize` bits.
 */
float getMaxIntValue(int bitSize, boolean isSigned) {
  bitSize in [8, 16, 32] and
  (
    isSigned = true and result = 2.pow(bitSize - 1) - 1
    or
    isSigned = false and result = 2.pow(bitSize) - 1
  )
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

/**
 * Holds if converting from an integer types with size `sourceBitSize` to
 * one with size `sinkBitSize` can produce unexpected values, where 0 means
 * architecture-dependent.
 *
 * Architecture-dependent bit sizes can be 32 or 64. To catch flows that
 * only manifest on 64-bit architectures we consider an
 * architecture-dependent source bit size to be 64. To catch flows that
 * only happen on 32-bit architectures we consider an
 * architecture-dependent sink bit size to be 32. We exclude the case where
 * both source and sink have architecture-dependent bit sizes.
 */
private predicate isIncorrectIntegerConversion(int sourceBitSize, int sinkBitSize) {
  sourceBitSize in [16, 32, 64] and
  sinkBitSize in [8, 16, 32] and
  sourceBitSize > sinkBitSize
  or
  // Treat `sourceBitSize = 0` like `sourceBitSize = 64`, and exclude `sinkBitSize = 0`
  sourceBitSize = 0 and
  sinkBitSize in [8, 16, 32]
  or
  // Treat `sinkBitSize = 0` like `sinkBitSize = 32`, and exclude `sourceBitSize = 0`
  sourceBitSize = 64 and
  sinkBitSize = 0
}

/**
 * DEPRECATED: use `Flow` instead.
 *
 * A taint-tracking configuration for reasoning about when an integer
 * obtained from parsing a string flows to a type conversion to a smaller
 * integer types, which could cause unexpected values.
 */
deprecated class ConversionWithoutBoundsCheckConfig extends TaintTracking::Configuration {
  boolean sinkIsSigned;
  int sourceBitSize;
  int sinkBitSize;

  ConversionWithoutBoundsCheckConfig() {
    sinkIsSigned in [true, false] and
    isIncorrectIntegerConversion(sourceBitSize, sinkBitSize) and
    this = "ConversionWithoutBoundsCheckConfig" + sourceBitSize + sinkIsSigned + sinkBitSize
  }

  /** Gets the bit size of the source. */
  int getSourceBitSize() { result = sourceBitSize }

  override predicate isSource(DataFlow::Node source) {
    exists(
      DataFlow::CallNode c, IntegerParser::Range ip, int apparentBitSize, int effectiveBitSize
    |
      c.getTarget() = ip and source = c.getResult(0)
    |
      (
        apparentBitSize = ip.getTargetBitSize()
        or
        // If we are reading a variable, check if it is
        // `strconv.IntSize`, and use 0 if it is.
        exists(DataFlow::Node rawBitSize | rawBitSize = ip.getTargetBitSizeInput().getNode(c) |
          if rawBitSize = any(Strconv::IntSize intSize).getARead()
          then apparentBitSize = 0
          else apparentBitSize = rawBitSize.getIntValue()
        )
      ) and
      (
        if apparentBitSize = 0
        then effectiveBitSize = getIntTypeBitSize(source.getFile(), 0)
        else effectiveBitSize = apparentBitSize
      ) and
      // `effectiveBitSize` could be any value between 0 and 64, but we
      // can round it up to the nearest size of an integer type without
      // changing behavior.
      sourceBitSize = min(int b | b in [0, 8, 16, 32, 64] and b >= effectiveBitSize)
    )
  }

  /**
   * Holds if `sink` is a typecast to an integer type with size `bitSize` (where
   * 0 represents architecture-dependent) and the expression being typecast is
   * not also in a right-shift expression. We allow this case because it is
   * a common pattern to serialise `byte(v)`, `byte(v >> 8)`, and so on.
   */
  predicate isSinkWithBitSize(DataFlow::TypeCastNode sink, int bitSize) {
    sink.asExpr() instanceof ConversionExpr and
    exists(IntegerType integerType | sink.getResultType().getUnderlyingType() = integerType |
      (
        bitSize = integerType.getSize()
        or
        not exists(integerType.getSize()) and
        bitSize = getIntTypeBitSize(sink.getFile(), 0)
      ) and
      if integerType instanceof SignedIntegerType then sinkIsSigned = true else sinkIsSigned = false
    ) and
    not exists(ShrExpr shrExpr |
      shrExpr.getLeftOperand().getGlobalValueNumber() =
        sink.getOperand().asExpr().getGlobalValueNumber() or
      shrExpr.getLeftOperand().(AndExpr).getAnOperand().getGlobalValueNumber() =
        sink.getOperand().asExpr().getGlobalValueNumber()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    // We use the argument of the type conversion as the configuration sink so that we
    // can sanitize the result of the conversion to prevent flow on to further sinks
    // without needing to use `isSanitizerOut`, which doesn't work with flow states
    // (and therefore the legacy `TaintTracking::Configuration` class).
    this.isSinkWithBitSize(sink.getASuccessor(), sinkBitSize)
  }

  override predicate isSanitizer(DataFlow::Node node) {
    // To catch flows that only happen on 32-bit architectures we
    // consider an architecture-dependent sink bit size to be 32.
    exists(UpperBoundCheckGuard g, int bitSize |
      if sinkBitSize != 0 then bitSize = sinkBitSize else bitSize = 32
    |
      node = DataFlow::BarrierGuard<upperBoundCheckGuard/3>::getABarrierNodeForGuard(g) and
      if sinkIsSigned = true then g.isBoundFor(bitSize, 32) else g.isBoundFor(bitSize - 1, 32)
    )
    or
    exists(int bitSize |
      isIncorrectIntegerConversion(sourceBitSize, bitSize) and
      this.isSinkWithBitSize(node, bitSize)
    )
  }
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
   * Gets the bitsize we should use for a sink.
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
abstract class BarrierFlowStateTransformer extends DataFlow::Node {
  /**
   * Holds if this should be a barrier for `flowstate`.
   *
   * This includes flow states which are transformed into other flow states.
   */
  abstract predicate barrierFor(MaxValueState flowstate);

  /**
   * Gets the flow state that `flowstate` is transformed into.
   *
   * Due to limitations of the implementation the transformation defined by this
   * predicate must be idempotent, that is, for any input `x` it must be that:
   * ```
   * transform(transform(x)) = transform(x)
   * ```
   */
  abstract MaxValueState transform(MaxValueState flowstate);
}

private predicate upperBoundCheckGuard(DataFlow::Node g, Expr e, boolean branch) {
  g.(UpperBoundCheckGuard).checks(e, branch)
}

/** An upper bound check that compares a variable to a constant value. */
class UpperBoundCheckGuard extends DataFlow::RelationalComparisonNode {
  UpperBoundCheckGuard() {
    count(expr.getAnOperand().getExactValue()) = 1 and
    expr.getAnOperand().getType().getUnderlyingType() instanceof IntegerType
  }

  /**
   * Holds if this upper bound check ensures the non-constant operand is less
   * than or equal to `2^(bitsize) - 1`. In this  case, the upper bound check
   * is a barrier guard. `architectureBitSize` is used if the constant operand
   * is `math.MaxInt` or `math.MaxUint`.
   *
   * Note that we have to use floats here because integers in CodeQL are
   * represented by 32-bit signed integers, which cannot represent some of the
   * integer values which we will encounter.
   */
  predicate isBoundFor(int bitSize, int architectureBitSize) {
    bitSize = validBitSize() and
    architectureBitSize = [32, 64] and
    exists(float bound, float strictnessOffset |
      // For `x < c` the bound is `c-1`. For `x >= c` we will be an upper bound
      // on the `branch` argument of `checks` is false, which is equivalent to
      // `x < c`.
      if expr instanceof LssExpr or expr instanceof GeqExpr
      then strictnessOffset = 1
      else strictnessOffset = 0
    |
      exists(DeclaredConstant maxint, DeclaredConstant maxuint |
        maxint.hasQualifiedName("math", "MaxInt") and maxuint.hasQualifiedName("math", "MaxUint")
      |
        if expr.getAnOperand() = maxint.getAReference()
        then bound = getMaxIntValue(architectureBitSize, true)
        else
          if expr.getAnOperand() = maxuint.getAReference()
          then bound = getMaxIntValue(architectureBitSize, false)
          else bound = expr.getAnOperand().getExactValue().toFloat()
      ) and
      bound - strictnessOffset < 2.pow(bitSize) - 1
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
 * `parsed < math.MaxInt16` is an `UpperBoundCheckGuard` and `uint16(parsed)`
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
class UpperBoundCheck extends BarrierFlowStateTransformer {
  UpperBoundCheckGuard g;

  UpperBoundCheck() {
    this = DataFlow::BarrierGuard<upperBoundCheckGuard/3>::getABarrierNodeForGuard(g)
  }

  override predicate barrierFor(MaxValueState flowstate) {
    g.isBoundFor(flowstate.getBitSize(), flowstate.getSinkBitSize())
  }

  override MaxValueState transform(MaxValueState state) {
    this.barrierFor(state) and
    result.getBitSize() =
      max(int bitsize |
        bitsize = validBitSize() and
        bitsize < state.getBitSize() and
        not g.isBoundFor(bitsize, state.getSinkBitSize())
      ) and
    (
      result.getArchitectureBitSize() = state.getArchitectureBitSize()
      or
      state.architectureBitSizeUnknown() and result.architectureBitSizeUnknown()
    )
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
    exists(BarrierFlowStateTransformer bfst | node = bfst and bfst.barrierFor(state))
    or
    // When there is a flow from a source to a sink, do not allow the flow to
    // continue to a further sink.
    isSink2(node, state)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    // Create additional flow steps for `BarrierFlowStateTransformer`s
    state2 = node2.(BarrierFlowStateTransformer).transform(state1) and
    DataFlow::simpleLocalFlowStep(node1, node2)
  }
}

/**
 * Tracks taint flow from an integer obtained from parsing a string that flows
 * to a type conversion to a smaller integer type, which could cause data loss.
 */
module Flow = TaintTracking::GlobalWithState<ConversionWithoutBoundsCheckConfig>;

/** Gets a string describing the size of the integer parsed. */
deprecated string describeBitSize(int bitSize, int intTypeBitSize) {
  intTypeBitSize in [0, 32, 64] and
  if bitSize != 0
  then bitSize in [8, 16, 32, 64] and result = "a " + bitSize + "-bit integer"
  else
    if intTypeBitSize = 0
    then result = "an integer with architecture-dependent bit size"
    else
      result =
        "a number with architecture-dependent bit-width, which is constrained to be " +
          intTypeBitSize + "-bit by build constraints,"
}

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
