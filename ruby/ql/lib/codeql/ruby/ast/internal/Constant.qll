private import codeql.ruby.AST
private import codeql.ruby.ast.internal.Literal
private import codeql.ruby.ast.internal.Module
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.dataflow.SSA
private import ExprNodes

/**
 * Provides an implementation of constant propagation for control-flow graph
 * (CFG) nodes and expressions (AST nodes).
 *
 * The end result are two predicates
 * ```ql
 * ConstantValue getConstantValue(ExprCfgNode n);
 * ConstantValue getConstantValueExpr(Expr e);
 * ```
 *
 * It would be natural to define those predicates recursively. However, because
 * of how `newtype`s work, this results in bad performance as a result of
 * unnecessary recursion through the constructors of `TConstantValue`. Instead,
 * we define a set of predicates for each possible `ConstantValue` type, and each
 * set of predicates needs to replicate logic, e.g., how a constant may be propagated
 * from an assignment to a variable read.
 *
 * For each `ConstantValue` type `T`, we define three predicates:
 * ```ql
 * predicate isT(ExprCfgNode n, T v);
 * predicate isTExprNoCfg(Expr e, T v);
 * predicate isTExpr(Expr e, T v);
 * ```
 *
 * `isT` and `isTExpr` rely on the CFG to determine the constant value of a CFG
 * node and expression, respectively, whereas `isTExprNoCfg` is able to determine
 * the constant value of an expression without relying on the CFG. This means that
 * even if the CFG is not available (dead code), we may still be able to infer a
 * constant value in some cases.
 */
private module Propagation {
  private ExprCfgNode getSource(VariableReadAccessCfgNode read) {
    exists(Ssa::WriteDefinition def |
      def.assigns(result) and
      read = def.getARead()
    )
  }

  predicate isInt(ExprCfgNode e, int i) {
    isIntExprNoCfg(e.getExpr(), i)
    or
    isIntExpr(e.getExpr().(ConstantReadAccess).getValue(), i)
    or
    isInt(getSource(e), i)
    or
    e =
      any(UnaryOperationCfgNode unop |
        unop.getExpr() instanceof UnaryMinusExpr and
        isInt(unop.getOperand(), -i)
        or
        unop.getExpr() instanceof UnaryPlusExpr and
        isInt(unop.getOperand(), i)
      )
    or
    exists(BinaryOperationCfgNode binop, BinaryOperation b, int left, int right |
      e = binop and
      isInt(binop.getLeftOperand(), left) and
      isInt(binop.getRightOperand(), right) and
      b = binop.getExpr()
    |
      b instanceof AddExpr and
      i = left + right
      or
      b instanceof SubExpr and
      i = left - right
      or
      b instanceof MulExpr and
      i = left * right
      or
      b instanceof DivExpr and
      i = left / right
    )
  }

  private predicate isIntExprNoCfg(Expr e, int i) {
    i = e.(IntegerLiteralImpl).getValue()
    or
    i = e.(LineLiteralImpl).getValue()
    or
    isIntExprNoCfg(e.(ConstantReadAccess).getValue(), i)
  }

  predicate isIntExpr(Expr e, int i) {
    isIntExprNoCfg(e, i)
    or
    isIntExpr(e.(ConstantReadAccess).getValue(), i)
    or
    forex(ExprCfgNode n | n = e.getAControlFlowNode() | isInt(n, i))
  }

  predicate isFloat(ExprCfgNode e, float f) {
    isFloatExprNoCfg(e.getExpr(), f)
    or
    isFloatExpr(e.getExpr().(ConstantReadAccess).getValue(), f)
    or
    isFloat(getSource(e), f)
    or
    e =
      any(UnaryOperationCfgNode unop |
        unop.getExpr() instanceof UnaryMinusExpr and
        isFloat(unop.getOperand(), -f)
        or
        unop.getExpr() instanceof UnaryPlusExpr and
        isFloat(unop.getOperand(), f)
      )
    or
    exists(BinaryOperationCfgNode binop, BinaryOperation b, float left, float right |
      e = binop and
      b = binop.getExpr() and
      exists(ExprCfgNode l, ExprCfgNode r |
        l = binop.getLeftOperand() and
        r = binop.getRightOperand()
      |
        isFloat(l, left) and isFloat(r, right)
        or
        isInt(l, left) and isFloat(r, right)
        or
        isFloat(l, left) and isInt(r, right)
      )
    |
      b instanceof AddExpr and
      f = left + right
      or
      b instanceof SubExpr and
      f = left - right
      or
      b instanceof MulExpr and
      f = left * right
      or
      b instanceof DivExpr and
      f = left / right
    )
  }

  private predicate isFloatExprNoCfg(Expr e, float f) {
    f = e.(FloatLiteralImpl).getValue()
    or
    isFloatExprNoCfg(e.(ConstantReadAccess).getValue(), f)
  }

  predicate isFloatExpr(Expr e, float f) {
    isFloatExprNoCfg(e, f)
    or
    isFloatExpr(e.(ConstantReadAccess).getValue(), f)
    or
    forex(ExprCfgNode n | n = e.getAControlFlowNode() | isFloat(n, f))
  }

  predicate isRational(ExprCfgNode e, int numerator, int denominator) {
    isRationalExprNoCfg(e.getExpr(), numerator, denominator)
    or
    isRationalExpr(e.getExpr().(ConstantReadAccess).getValue(), numerator, denominator)
    or
    isRational(getSource(e), numerator, denominator)
  }

  private predicate isRationalExprNoCfg(Expr e, int numerator, int denominator) {
    e.(RationalLiteralImpl).hasValue(numerator, denominator)
    or
    isRationalExprNoCfg(e.(ConstantReadAccess).getValue(), numerator, denominator)
  }

  predicate isRationalExpr(Expr e, int numerator, int denominator) {
    isRationalExprNoCfg(e, numerator, denominator)
    or
    isRationalExpr(e.(ConstantReadAccess).getValue(), numerator, denominator)
    or
    forex(ExprCfgNode n | n = e.getAControlFlowNode() | isRational(n, numerator, denominator))
  }

  predicate isComplex(ExprCfgNode e, float real, float imaginary) {
    isComplexExprNoCfg(e.getExpr(), real, imaginary)
    or
    isComplexExpr(e.getExpr().(ConstantReadAccess).getValue(), real, imaginary)
    or
    isComplex(getSource(e), real, imaginary)
  }

  private predicate isComplexExprNoCfg(Expr e, float real, float imaginary) {
    e.(ComplexLiteralImpl).hasValue(real, imaginary)
    or
    isComplexExprNoCfg(e.(ConstantReadAccess).getValue(), real, imaginary)
  }

  predicate isComplexExpr(Expr e, float real, float imaginary) {
    isComplexExprNoCfg(e, real, imaginary)
    or
    isComplexExpr(e.(ConstantReadAccess).getValue(), real, imaginary)
    or
    forex(ExprCfgNode n | n = e.getAControlFlowNode() | isComplex(n, real, imaginary))
  }

  private class StringlikeLiteralWithInterpolationCfgNode extends StringlikeLiteralCfgNode {
    StringlikeLiteralWithInterpolationCfgNode() {
      this.getAComponent() =
        any(StringComponentCfgNode c |
          c instanceof StringInterpolationComponentCfgNode or
          c instanceof RegExpInterpolationComponentCfgNode
        )
    }

    pragma[nomagic]
    private string getComponentValue(int i) {
      this.getComponent(i) =
        any(StringComponentCfgNode c |
          isString(c, result)
          or
          result = c.getNode().(StringComponentImpl).getValue()
        )
    }

    language[monotonicAggregates]
    private string getValue() {
      result =
        strictconcat(int i | exists(this.getComponent(i)) | this.getComponentValue(i) order by i)
    }

    pragma[nomagic]
    string getSymbolValue() {
      result = this.getValue() and
      this.getExpr() instanceof SymbolLiteral
    }

    pragma[nomagic]
    string getStringValue() {
      result = this.getValue() and
      not this.getExpr() instanceof SymbolLiteral and
      not this.getExpr() instanceof RegExpLiteral
    }

    pragma[nomagic]
    string getRegExpValue(string flags) {
      result = this.getValue() and
      flags = this.getExpr().(RegExpLiteral).getFlagString()
    }
  }

  predicate isString(ExprCfgNode e, string s) {
    isStringExprNoCfg(e.getExpr(), s)
    or
    isStringExpr(e.getExpr().(ConstantReadAccess).getValue(), s)
    or
    isString(getSource(e), s)
    or
    exists(BinaryOperationCfgNode binop, string left, string right |
      e = binop and
      isString(binop.getLeftOperand(), left) and
      isString(binop.getRightOperand(), right) and
      binop.getExpr() instanceof AddExpr and
      left.length() + right.length() <= 1000 and
      s = left + right
    )
    or
    s = e.(StringlikeLiteralWithInterpolationCfgNode).getStringValue()
    or
    // If last statement in the interpolation is a constant or local variable read,
    // we attempt to look up its string value.
    // If there's a result, we return that as the string value of the interpolation.
    exists(ExprCfgNode last | last = e.(StringInterpolationComponentCfgNode).getLastStmt() |
      isInt(last, any(int i | s = i.toString())) or
      isFloat(last, any(float f | s = f.toString())) or
      isString(last, s)
    )
    or
    // If last statement in the interpolation is a constant or local variable read,
    // attempt to look up its definition and return the definition's `getConstantValue()`.
    exists(ExprCfgNode last | last = e.(RegExpInterpolationComponentCfgNode).getLastStmt() |
      isInt(last, any(int i | s = i.toString())) or
      isFloat(last, any(float f | s = f.toString())) or
      isString(last, s) or
      isRegExp(last, s, _) // Note: we lose the flags for interpolated regexps here.
    )
  }

  private predicate isStringExprNoCfg(Expr e, string s) {
    s = e.(StringlikeLiteralImpl).getStringValue() and
    not e instanceof SymbolLiteral and
    not e instanceof RegExpLiteral
    or
    s = e.(EncodingLiteralImpl).getValue()
    or
    s = e.(FileLiteralImpl).getValue()
    or
    s = e.(TokenMethodName).getValue()
    or
    s = e.(CharacterLiteralImpl).getValue()
    or
    isStringExprNoCfg(e.(ConstantReadAccess).getValue(), s)
  }

  predicate isStringExpr(Expr e, string s) {
    isStringExprNoCfg(e, s)
    or
    isStringExpr(e.(ConstantReadAccess).getValue(), s)
    or
    forex(ExprCfgNode n | n = e.getAControlFlowNode() | isString(n, s))
  }

  predicate isSymbol(ExprCfgNode e, string s) {
    isSymbolExprNoCfg(e.getExpr(), s)
    or
    isSymbolExpr(e.getExpr().(ConstantReadAccess).getValue(), s)
    or
    isSymbol(getSource(e), s)
    or
    s = e.(StringlikeLiteralWithInterpolationCfgNode).getSymbolValue()
  }

  private predicate isSymbolExprNoCfg(Expr e, string s) {
    s = e.(StringlikeLiteralImpl).getStringValue() and
    e instanceof SymbolLiteral
    or
    isSymbolExprNoCfg(e.(ConstantReadAccess).getValue(), s)
  }

  predicate isSymbolExpr(Expr e, string s) {
    isSymbolExprNoCfg(e, s)
    or
    isSymbolExpr(e.(ConstantReadAccess).getValue(), s)
    or
    forex(ExprCfgNode n | n = e.getAControlFlowNode() | isSymbol(n, s))
  }

  predicate isRegExp(ExprCfgNode e, string s, string flags) {
    isRegExpExprNoCfg(e.getExpr(), s, flags)
    or
    isRegExpExpr(e.getExpr().(ConstantReadAccess).getValue(), s, flags)
    or
    isRegExp(getSource(e), s, flags)
    or
    s = e.(StringlikeLiteralWithInterpolationCfgNode).getRegExpValue(flags)
  }

  private predicate isRegExpExprNoCfg(Expr e, string s, string flags) {
    s = e.(StringlikeLiteralImpl).getStringValue() and
    e.(RegExpLiteral).getFlagString() = flags
    or
    isRegExpExprNoCfg(e.(ConstantReadAccess).getValue(), s, flags)
  }

  predicate isRegExpExpr(Expr e, string s, string flags) {
    isRegExpExprNoCfg(e, s, flags)
    or
    isRegExpExpr(e.(ConstantReadAccess).getValue(), s, flags)
    or
    forex(ExprCfgNode n | n = e.getAControlFlowNode() | isRegExp(n, s, flags))
  }

  predicate isBoolean(ExprCfgNode e, boolean b) {
    isBooleanExprNoCfg(e.getExpr(), b)
    or
    isBooleanExpr(e.getExpr().(ConstantReadAccess).getValue(), b)
    or
    isBoolean(getSource(e), b)
  }

  private predicate isBooleanExprNoCfg(Expr e, boolean b) {
    b = e.(BooleanLiteralImpl).getValue()
    or
    isBooleanExprNoCfg(e.(ConstantReadAccess).getValue(), b)
  }

  predicate isBooleanExpr(Expr e, boolean b) {
    isBooleanExprNoCfg(e, b)
    or
    isBooleanExpr(e.(ConstantReadAccess).getValue(), b)
    or
    forex(ExprCfgNode n | n = e.getAControlFlowNode() | isBoolean(n, b))
  }

  predicate isNil(ExprCfgNode e) {
    isNilExprNoCfg(e.getExpr())
    or
    isNilExpr(e.getExpr().(ConstantReadAccess).getValue())
    or
    isNil(getSource(e))
  }

  private predicate isNilExprNoCfg(Expr e) {
    e instanceof NilLiteralImpl
    or
    isNilExprNoCfg(e.(ConstantReadAccess).getValue())
  }

  predicate isNilExpr(Expr e) {
    isNilExprNoCfg(e)
    or
    isNilExpr(e.(ConstantReadAccess).getValue())
    or
    forex(ExprCfgNode n | n = e.getAControlFlowNode() | isNil(n))
  }
}

private import Propagation

cached
private module Cached {
  cached
  newtype TConstantValue =
    TInt(int i) { isInt(_, i) or isIntExpr(_, i) } or
    TFloat(float f) { isFloat(_, f) or isFloatExpr(_, f) } or
    TRational(int numerator, int denominator) {
      isRational(_, numerator, denominator) or
      isRationalExpr(_, numerator, denominator)
    } or
    TComplex(float real, float imaginary) {
      isComplex(_, real, imaginary) or
      isComplexExpr(_, real, imaginary)
    } or
    TString(string s) {
      isString(_, s)
      or
      isStringExpr(_, s)
      or
      s = any(StringComponentImpl c).getValue()
    } or
    TSymbol(string s) { isString(_, s) or isSymbolExpr(_, s) } or
    TRegExp(string s, string flags) {
      isRegExp(_, s, flags)
      or
      isRegExpExpr(_, s, flags)
      or
      s = any(StringComponentImpl c).getValue() and flags = ""
    } or
    TBoolean(boolean b) { b in [false, true] } or
    TNil()

  class TStringlike = TString or TSymbol or TRegExp;

  cached
  ConstantValue getConstantValue(ExprCfgNode n) {
    result.isInt(any(int i | isInt(n, i)))
    or
    result.isFloat(any(float f | isFloat(n, f)))
    or
    exists(int numerator, int denominator |
      isRational(n, numerator, denominator) and
      result = TRational(numerator, denominator)
    )
    or
    exists(float real, float imaginary |
      isComplex(n, real, imaginary) and
      result = TComplex(real, imaginary)
    )
    or
    result.isString(any(string s | isString(n, s)))
    or
    result.isSymbol(any(string s | isSymbol(n, s)))
    or
    exists(string s, string flags | isRegExp(n, s, flags) and result = TRegExp(s, flags))
    or
    result.isBoolean(any(boolean b | isBoolean(n, b)))
    or
    result.isNil() and
    isNil(n)
  }

  cached
  ConstantValue getConstantValueExpr(Expr e) {
    result.isInt(any(int i | isIntExpr(e, i)))
    or
    result.isFloat(any(float f | isFloatExpr(e, f)))
    or
    exists(int numerator, int denominator |
      isRationalExpr(e, numerator, denominator) and
      result = TRational(numerator, denominator)
    )
    or
    exists(float real, float imaginary |
      isComplexExpr(e, real, imaginary) and
      result = TComplex(real, imaginary)
    )
    or
    result.isString(any(string s | isStringExpr(e, s)))
    or
    result.isSymbol(any(string s | isSymbolExpr(e, s)))
    or
    exists(string s, string flags | isRegExpExpr(e, s, flags) and result = TRegExp(s, flags))
    or
    result.isBoolean(any(boolean b | isBooleanExpr(e, b)))
    or
    result.isNil() and
    isNilExpr(e)
  }

  cached
  Expr getConstantReadAccessValue(ConstantReadAccess read) {
    not exists(read.getScopeExpr()) and
    result = lookupConst(read.getEnclosingModule+().getModule(), read.getName()) and
    // For now, we restrict the scope of top-level declarations to their file.
    // This may remove some plausible targets, but also removes a lot of
    // implausible targets
    if result.getEnclosingModule() instanceof Toplevel
    then result.getFile() = read.getFile()
    else any()
    or
    read.hasGlobalScope() and
    result = lookupConst(TResolved("Object"), read.getName())
    or
    result = lookupConst(resolveConstantReadAccess(read.getScopeExpr()), read.getName())
  }
}

import Cached
