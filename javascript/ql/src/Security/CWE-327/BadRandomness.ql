/**
 * @name Creating biased random numbers from cryptographically secure source.
 * @description Some mathematical operations on random numbers can cause bias in
 *              the results and compromise security.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id js/biased-cryptographic-random
 * @tags security
 *       external/cwe/cwe-327
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes
private import semmle.javascript.dataflow.internal.StepSummary
private import semmle.javascript.security.dataflow.InsecureRandomnessCustomizations

/**
 * Gets a Buffer/TypedArray containing cryptographically secure random numbers.
 */
private DataFlow::SourceNode randomBufferSource() {
  result = DataFlow::moduleMember("crypto", ["randomBytes", "randomFillSync"]).getACall()
  or
  exists(DataFlow::CallNode call |
    call = DataFlow::moduleMember("crypto", ["randomFill", "randomFillSync"]) and
    result = call.getArgument(0).getALocalSource()
  )
  or
  result = DataFlow::globalVarRef("crypto").getAMethodCall("getRandomValues")
  or
  result = DataFlow::moduleImport("secure-random").getACall()
  or
  result =
    DataFlow::moduleImport("secure-random")
        .getAMethodCall(["randomArray", "randomUint8Array", "randomBuffer"])
}

/**
 * Gets the pseudo-property used to track elements inside a Buffer.
 * The API for `Set` is close enough to the API for `Buffer` that we can reuse the type-tracking steps.
 */
private string prop() { result = DataFlow::PseudoProperties::setElement() }

/**
 * Gets a reference to a cryptographically secure random number, type tracked using `t`.
 */
private DataFlow::Node goodRandom(DataFlow::TypeTracker t) {
  t.startInProp(prop()) and
  result = randomBufferSource()
  or
  // Loading a number from a `Buffer`.
  exists(DataFlow::TypeTracker t2 | t = t2.append(LoadStep(prop())) |
    // the random generators return arrays/Buffers of random numbers, we therefore track through an indexed read.
    exists(DataFlow::PropRead read | result = read |
      read.getBase() = goodRandom(t2) and
      not read.getPropertyNameExpr() instanceof Label
    )
    or
    // reading a number from a Buffer.
    exists(DataFlow::MethodCallNode call | result = call |
      call.getReceiver() = goodRandom(t2) and
      call
          .getMethodName()
          .regexpMatch("read(BigInt|BigUInt|Double|Float|Int|UInt)(8|16|32|64)?(BE|LE)?")
    )
  )
  or
  exists(DataFlow::TypeTracker t2 | t = t2.smallstep(goodRandom(t2), result))
  or
  // re-using the collection steps for `Set`.
  exists(DataFlow::TypeTracker t2 |
    result = CollectionsTypeTracking::collectionStep(goodRandom(t2), t, t2)
  )
  or
  InsecureRandomness::isAdditionalTaintStep(goodRandom(t.continue()), result)
}

/**
 * Gets a reference to a cryptographically random number.
 */
DataFlow::Node goodRandom() { result = goodRandom(DataFlow::TypeTracker::end()) }

/**
 * Gets a node that that produces a biased result from otherwise cryptographically secure random numbers.
 */
DataFlow::Node badCrypto(string description) {
  // addition and multiplication - always bad when both the lhs and rhs are random.
  exists(BinaryExpr binop | result.asExpr() = binop |
    goodRandom().asExpr() = binop.getLeftOperand() and
    goodRandom().asExpr() = binop.getRightOperand() and
    (
      binop.getOperator() = "+" and description = "addition"
      or
      binop.getOperator() = "*" and description = "multiplication"
    )
  )
  or
  // division - always bad
  exists(DivExpr div | result.asExpr() = div |
    goodRandom().asExpr() = div.getLeftOperand() and
    description = "division"
  )
  or
  // modulo - only bad if not by a power of 2 - and the result is not checked for bias
  exists(ModExpr mod, DataFlow::Node random | result.asExpr() = mod and mod.getOperator() = "%" |
    description = "modulo" and
    goodRandom() = random and
    random.asExpr() = mod.getLeftOperand() and
    // division by a power of 2 is OK. E.g. if `x` is uniformly random is in the range [0..255] then `x % 32` is uniformly random in the range [0..31].
    not mod.getRightOperand().getIntValue() = [2, 4, 8, 16, 32, 64, 128] and
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
    goodRandom() = root.getALeaf() and
    exists(root.getALeaf().getStringValue()) and
    description = "string concatenation"
  )
}

from DataFlow::Node node, string description
where node = badCrypto(description)
select node,
  "Using " + description + " on cryptographically random numbers produces biased results."
