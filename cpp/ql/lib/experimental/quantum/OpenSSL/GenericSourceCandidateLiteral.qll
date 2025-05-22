import cpp
private import semmle.code.cpp.models.Models
private import semmle.code.cpp.models.interfaces.FormattingFunction

/**
 * Holds if a StringLiteral could conceivably be used in some way for cryptography.
 * Note: this predicate should only consider restrictions with respect to strings only.
 * General restrictions are in the OpenSSLGenericSourceCandidateLiteral class.
 */
private predicate isOpenSSLStringLiteralGenericSourceCandidate(StringLiteral s) {
  // 'EC' is a constant that may be used where typical algorithms are specified,
  // but EC specifically means set up a default curve container, that will later be
  //specified explicitly (or if not a default) curve is used.
  s.getValue() != "EC" and
  // Ignore empty strings
  s.getValue() != "" and
  // Filter out strings with "%", to filter out format strings
  not s.getValue().matches("%\\%%") and
  // Filter out strings in brackets or braces (commonly seen strings not relevant for crypto)
  not s.getValue().matches(["[%]", "(%)"]) and
  // Filter out all strings of length 1, since these are not algorithm names
  // NOTE/ASSUMPTION: If a user legitimately passes a string of length 1 to some configuration
  // we will assume this is generally unknown. We may need to reassess this in the future.
  s.getValue().length() > 1 and
  // Ignore all strings that are in format string calls outputing to a stream (e.g., stdout)
  not exists(FormattingFunctionCall f |
    exists(f.getOutputArgument(true)) and s = f.(Call).getAnArgument()
  ) and
  // Ignore all format string calls where there is no known out param (resulting string)
  // i.e., ignore printf, since it will just output a string and not produce a new string
  not exists(FormattingFunctionCall f |
    // Note: using two ways of determining if there is an out param, since I'm not sure
    // which way is canonical
    not exists(f.getOutputArgument(false)) and
    not f.getTarget().hasTaintFlow(_, _) and
    f.(Call).getAnArgument() = s
  )
}

/**
 * Holds if an IntLiteral could be an algorithm literal.
 * Note: this predicate should only consider restrictions with respect to integers only.
 * General restrictions are in the OpenSSLGenericSourceCandidateLiteral class.
 */
private predicate isOpenSSLIntLiteralGenericSourceCandidate(Literal l) {
  exists(l.getValue().toInt()) and
  // Ignore char literals
  not l instanceof CharLiteral and
  not l instanceof StringLiteral and
  // Ignore integer values of 0, commonly referring to NULL only (no known algorithm 0)
  l.getValue().toInt() != 0 and
  // ASSUMPTION, no negative numbers are allowed
  // RATIONALE: this is a performance improvement to avoid having to trace every number
  not exists(UnaryMinusExpr u | u.getOperand() = l) and
  //  OPENSSL has a special macro for getting every line, ignore it
  not exists(MacroInvocation mi | mi.getExpr() = l and mi.getMacroName() = "OPENSSL_LINE") and
  // Filter out cases where an int is returned into a pointer, e.g., return NULL;
  not exists(ReturnStmt r |
    r.getExpr() = l and
    r.getEnclosingFunction().getType().getUnspecifiedType() instanceof DerivedType
  ) and
  // A literal as an array index should not be relevant for crypo
  not exists(ArrayExpr op | op.getArrayOffset() = l) and
  // A literal used in a bitwise should not be relevant for crypto
  not exists(BinaryBitwiseOperation op | op.getAnOperand() = l) and
  not exists(AssignBitwiseOperation op | op.getAnOperand() = l) and
  //Filter out cases where an int is assigned or initialized into a pointer, e.g., char* x = NULL;
  not exists(Assignment a |
    a.getRValue() = l and
    a.getLValue().getType().getUnspecifiedType() instanceof DerivedType
  ) and
  not exists(Initializer i |
    i.getExpr() = l and
    i.getDeclaration().getADeclarationEntry().getUnspecifiedType() instanceof DerivedType
  ) and
  // Filter out cases where the literal is used in any kind of arithmetic operation
  not exists(BinaryArithmeticOperation op | op.getAnOperand() = l) and
  not exists(UnaryArithmeticOperation op | op.getOperand() = l) and
  not exists(AssignArithmeticOperation op | op.getAnOperand() = l) and
  // If a literal has no parent ignore it, this is a workaround for the current inability
  // to find a literal in an array declaration: int x[100];
  // NOTE/ASSUMPTION: this value might actually be relevant for finding hard coded sizes
  // consider size as inferred through the allocation of a buffer.
  // In these cases, we advise that the source is not generic and must be traced explicitly.
  exists(l.getParent())
}

/**
 * Any literal that may represent an algorithm for use in an operation, even if an invalid or unknown algorithm.
 * The set of all literals is restricted by this class to cases where there is higher
 * plausibility that the literal is eventually used as an algorithm.
 * Literals are filtered, for example if they are used in a way no indicative of an algorithm use
 * such as in an array index, bitwise operation, or logical operation.
 * Note a case like this:
 *      if(algVal == "AES")
 *
 * "AES" may be a legitimate algorithm literal, but the literal will not be used for an operation directly
 * since it is in a equality comparison, hence this case would also be filtered.
 */
class OpenSSLGenericSourceCandidateLiteral extends Literal {
  OpenSSLGenericSourceCandidateLiteral() {
    (
      isOpenSSLIntLiteralGenericSourceCandidate(this) or
      isOpenSSLStringLiteralGenericSourceCandidate(this)
    ) and
    // ********* General filters beyond what is filtered for strings and ints *********
    // An algorithm literal in a switch case will not be directly applied to an operation.
    not exists(SwitchCase sc | sc.getExpr() = this) and
    // A literal in a logical operation may be an algorithm, but not a candidate
    // for the purposes of finding applied algorithms
    not exists(BinaryLogicalOperation op | op.getAnOperand() = this) and
    not exists(UnaryLogicalOperation op | op.getOperand() = this) and
    // A literal in a comparison operation may be an algorithm, but not a candidate
    // for the purposes of finding applied algorithms
    not exists(ComparisonOperation op | op.getAnOperand() = this)
  }
}
