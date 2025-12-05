import cpp

/**
 * Determines if the sizeOfExpr is ignorable.
 */
predicate ignorableSizeof(SizeofExprOperator sizeofExpr) {
  // a common pattern found is to sizeof a binary operation to check a type
  // to then perfomr an onperaiton for a 32 or 64 bit type.
  // these cases often look like sizeof(x) >=4
  // more generally we see binary operations frequently used in different type
  // checks, where the sizeof is part of some comparison operation of a switch statement guard.
  // sizeof as an argument is also similarly used, but seemingly less frequently.
  exists(ComparisonOperation comp | comp.getAnOperand() = sizeofExpr)
  or
  exists(ConditionalStmt s | s.getControllingExpr() = sizeofExpr)
  or
  // another common practice is to use bit-wise operations in sizeof to allow the compiler to
  // 'pack' the size appropriate but get the size of the result out of a sizeof operation.
  sizeofExpr.getExprOperand() instanceof BinaryBitwiseOperation
  or
  // Known intentional misuses in corecrt_math.h
  // Windows SDK corecrt_math.h defines a macro _CLASS_ARG that
  // intentionally misuses sizeof to determine the size of a floating point type.
  // Explicitly ignoring any hit in this macro.
  exists(MacroInvocation mi |
    mi.getMacroName() = "_CLASS_ARG" and
    mi.getMacro().getFile().getBaseName() = "corecrt_math.h" and
    mi.getAnExpandedElement() = sizeofExpr
  )
  or
  // the linux minmax.h header has macros that intentionally miuse sizeof,
  // for type checking, see __typecheck
  // This code has been observed in kernel.h as well.
  // Ignoring cases in linux build_bug.h and bug.h see BUILD_BUG_ON_INVALID
  // Ignoring cases of uses of FP_XSTATE_MAGIC2_SIZE found in sigcontext.h
  // which uses sizeof a constant as a way to get an architecturally agnostic size by
  // using the special magic number constant already defined
  exists(MacroInvocation mi |
    (
      // Generally ignore anything from these linux headers
      mi.getMacro().getFile().getBaseName() in [
          "minmax.h", "build_bug.h", "kernel.h", "bug.h", "sigcontext.h"
        ] and
      mi.getMacro().getFile().getRelativePath().toLowerCase().matches("%linux%")
      or
      // Sometimes the same macros are copied into other files, so also check the macro name
      // this is redundant, but the first check above blocks all macros in these headers
      // while this second check blocks any copies of these specific macros if found elsewhere.
      mi.getMacroName() = "FP_XSTATE_MAGIC2_SIZE"
      or
      mi.getMacroName() = "__typecheck"
    ) and
    mi.getAnExpandedElement() = sizeofExpr
  )
  or
  // if the operand is a macro invocation of something resembling "null"
  // assume sizeof is intended for strings, and ignore as this is a
  // potential null pointer issue, not a misuse of sizeof.
  exists(MacroInvocation mi |
    mi.getAnExpandedElement() = sizeofExpr.getExprOperand() and
    mi.getMacroName().toLowerCase().matches("%null%")
  )
  or
  // LLVM has known test cases under gcc-torture, ignore any hits under any matching directory
  // see for example 20020226-1.c
  sizeofExpr.getFile().getRelativePath().toLowerCase().matches("%gcc-%torture%")
  or
  // The user seems to be ignoring the output of the sizeof by casting the sizeof to void
  // this has been observed as a common pattern in assert macros (I believe for disabling asserts in release builds).
  // NOTE: having to check the conversion's type rather than the conversion itself
  // i.e., checking if VoidConversion
  // as nesting in parenthesis creats a ParenConversion
  sizeofExpr.getExplicitlyConverted().getUnspecifiedType() instanceof VoidType
  or
  // A common macro seen that gets size of arguments, considered ignorable
  exists(MacroInvocation mi |
    mi.getMacroName() = "_SDT_ARGSIZE" and mi.getAnExpandedElement() = sizeofExpr
  )
}

class CandidateSizeofCall extends SizeofExprOperator {
  CandidateSizeofCall() { not ignorableSizeof(this) }
}
