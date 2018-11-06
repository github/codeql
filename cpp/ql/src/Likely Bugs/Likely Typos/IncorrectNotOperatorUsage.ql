/**
 * @name Incorrect Not Operator Usage
 * @description Usage of a logical-not (!) operator as an operand for a bit-wise operation.
 *              This commonly indicates the usage of an incorrect operator instead of the bit-wise not (~) operator,
 *              also known as ones' complement operator.
 * @kind problem
 * @id cpp/incorrect-not-operator-usage
 * @problem.severity warning
 * @precision low
 * @tags security
 *       external/cwe/cwe-480
 *       external/microsoft/c6317
 */

import cpp

/**
 * It's common in some projects to use "a double negation" to normalize the boolean
 * result to either 1 or 0.
 * This predciate is intended to filter explicit usage of a double negation as it typically 
 * indicates the explicit purpose to normalize the result for bit-wise or arithmetic purposes. 
 */
predicate doubleNegationNormalization( NotExpr notexpr ){
  exists( NotExpr doubleNot |
    doubleNot  = notexpr.getAnOperand())
}

from BinaryBitwiseOperation binbitwop
where exists( NotExpr notexpr | 
  binbitwop.getAnOperand() = notexpr
  and not doubleNegationNormalization(notexpr)
)
select binbitwop, "Usage of a logical not (!) expression as a bitwise operator."

