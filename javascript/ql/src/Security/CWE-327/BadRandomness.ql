/**
 * @name Creating biased random numbers from a cryptographically secure source
 * @description Some mathematical operations on random numbers can cause bias in
 *              the results and compromise security.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision high
 * @id js/biased-cryptographic-random
 * @tags security
 *       external/cwe/cwe-327
 */

import javascript
private import semmle.javascript.dataflow.internal.StepSummary
private import semmle.javascript.security.dataflow.InsecureRandomnessCustomizations
private import semmle.javascript.dataflow.InferredTypes

/**
 * Gets a number that is a power of 2.
 */
private int powerOfTwo() {
  result = 1
  or
  result = 2 * powerOfTwo() and
  not result < 0
}

/**
 * Gets a node that has value 2^n for some n.
 */
private DataFlow::Node isPowerOfTwo() {
  exists(DataFlow::Node prev |
    prev.getIntValue() = powerOfTwo()
    or
    // Getting around the 32 bit ints in QL. These are some hex values of the form 0x10000000
    prev.asExpr().(NumberLiteral).getValue() =
      ["281474976710656", "17592186044416", "1099511627776", "68719476736", "4294967296"]
  |
    result = prev.getASuccessor*()
  )
}

/**
 * Gets a node that has value (2^n)-1 for some n.
 */
private DataFlow::Node isPowerOfTwoMinusOne() {
  exists(DataFlow::Node prev |
    prev.getIntValue() = powerOfTwo() - 1
    or
    // Getting around the 32 bit ints in QL. These are some hex values of the form 0xfffffff
    prev.asExpr().(NumberLiteral).getValue() =
      ["281474976710655", "17592186044415", "1099511627775", "68719476735", "4294967295"]
  |
    result = prev.getASuccessor*()
  )
}

/**
 * Gets the pseudo-property used to track elements inside a Buffer.
 * The API for `Set` is close enough to the API for `Buffer` that we can reuse the type-tracking steps.
 */
private string prop() { result = DataFlow::PseudoProperties::setElement() }

/**
 * Gets a reference to a cryptographically secure random number produced by `source` and type tracked using `t`.
 */
private DataFlow::Node goodRandom(DataFlow::TypeTracker t, DataFlow::SourceNode source) {
  t.startInProp(prop()) and
  result = InsecureRandomness::randomBufferSource() and
  result = source
  or
  // Loading a number from a `Buffer`.
  exists(DataFlow::TypeTracker t2 | t = t2.append(LoadStep(prop())) |
    // the random generators return arrays/Buffers of random numbers, we therefore track through an indexed read.
    exists(DataFlow::PropRead read | result = read |
      read.getBase() = goodRandom(t2, source) and
      not read.getPropertyNameExpr() instanceof Label
    )
    or
    // reading a number from a Buffer.
    exists(DataFlow::MethodCallNode call | result = call |
      call.getReceiver() = goodRandom(t2, source) and
      call.getMethodName()
          .regexpMatch("read(BigInt|BigUInt|Double|Float|Int|UInt)(8|16|32|64)?(BE|LE)?")
    )
  )
  or
  exists(DataFlow::TypeTracker t2 | t = t2.smallstep(goodRandom(t2, source), result))
  or
  InsecureRandomness::isAdditionalTaintStep(goodRandom(t.continue(), source), result) and
  // bit shifts and multiplication by powers of two are generally used for constructing larger numbers from smaller numbers.
  not exists(BinaryExpr binop | binop = result.asExpr() |
    binop.getOperator().regexpMatch(".*(<|>).*")
    or
    binop.getOperator() = "*" and isPowerOfTwo().asExpr() = binop.getAnOperand()
    or
    // string concat does not produce a number
    unique(InferredType type | type = binop.flow().analyze().getAType()) = TTString()
  )
}

/**
 * Gets a reference to a cryptographically secure random number produced by `source`.
 */
DataFlow::Node goodRandom(DataFlow::SourceNode source) {
  result = goodRandom(DataFlow::TypeTracker::end(), source)
}

/**
 * Gets a node that is passed to a rounding function from `Math`, using type-backtracker `t`.
 */
DataFlow::Node isRounded(DataFlow::TypeBackTracker t) {
  t.start() and
  result = DataFlow::globalVarRef("Math").getAMemberCall(["round", "floor", "ceil"]).getArgument(0)
  or
  exists(DataFlow::TypeBackTracker t2 | t2 = t.smallstep(result, isRounded(t2)))
  or
  InsecureRandomness::isAdditionalTaintStep(result, isRounded(t.continue()))
}

/**
 * Gets a node that that produces a biased result from otherwise cryptographically secure random numbers produced by `source`.
 */
DataFlow::Node badCrypto(string description, DataFlow::SourceNode source) {
  // addition and multiplication - always bad when both the lhs and rhs are random.
  exists(BinaryExpr binop | result.asExpr() = binop |
    goodRandom(_).asExpr() = binop.getLeftOperand() and
    goodRandom(_).asExpr() = binop.getRightOperand() and
    goodRandom(source).asExpr() = binop.getAnOperand() and
    (
      binop.getOperator() = "+" and description = "addition"
      or
      binop.getOperator() = "*" and description = "multiplication"
    )
  )
  or
  // division - bad if result is rounded.
  exists(DivExpr div | result.asExpr() = div |
    goodRandom(source).asExpr() = div.getLeftOperand() and
    description = "division and rounding the result" and
    not div.getRightOperand() = isPowerOfTwoMinusOne().asExpr() and // division by (2^n)-1 most of the time produces a uniformly random number between 0 and 1.
    div = isRounded(DataFlow::TypeBackTracker::end()).asExpr()
  )
  or
  // modulo - only bad if not by a power of 2 - and the result is not checked for bias
  exists(ModExpr mod, DataFlow::Node random | result.asExpr() = mod and mod.getOperator() = "%" |
    description = "modulo" and
    goodRandom(source) = random and
    random.asExpr() = mod.getLeftOperand() and
    // division by a power of 2 is OK. E.g. if `x` is uniformly random is in the range [0..255] then `x % 32` is uniformly random in the range [0..31].
    not mod.getRightOperand() = isPowerOfTwo().asExpr() and
    // not exists a comparison that checks if the result is potentially biased.
    not exists(BinaryExpr comparison | comparison.getOperator() = [">", "<", "<=", ">="] |
      AccessPath::getAnAliasedSourceNode(random.getALocalSource())
          .flowsToExpr(comparison.getAnOperand())
      or
      exists(DataFlow::PropRead otherRead |
        otherRead = random.(DataFlow::PropRead).getBase().getALocalSource().getAPropertyRead() and
        not exists(otherRead.getPropertyName()) and
        otherRead.flowsToExpr(comparison.getAnOperand())
      )
    )
  )
  or
  // create a number from a string - always a bad idea.
  exists(DataFlow::CallNode number, StringOps::ConcatenationRoot root | result = number |
    number = DataFlow::globalVarRef(["Number", "parseInt", "parseFloat"]).getACall() and
    root = number.getArgument(0) and
    goodRandom(source) = root.getALeaf() and
    exists(root.getALeaf().getStringValue()) and
    description = "string concatenation"
  )
}

from DataFlow::Node node, string description, DataFlow::SourceNode source
where node = badCrypto(description, source)
select node, "Using " + description + " on a $@ produces biased results.", source,
  "cryptographically secure random number"
