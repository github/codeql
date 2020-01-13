/**
 * @name Inconsistent nullness check
 * @description The result value of a function is often checked for nullness,
 *              but not always. Since the value is mostly checked, it is likely
 *              that the function can return null values in some cases, and
 *              omitting the check could crash the program.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cpp/inconsistent-null-check
 * @tags reliability
 *       correctness
 *       statistical
 *       non-attributable
 *       external/cwe/cwe-476
 */

import cpp

predicate assertMacro(Macro m) { m.getHead().toLowerCase().matches("%assert%") }

predicate assertInvocation(File f, int line) {
  exists(MacroInvocation i, Location l | assertMacro(i.getMacro()) and l = i.getLocation() |
    l.getStartLine() = line and l.getEndLine() = line and f = l.getFile()
  )
}

class InterestingExpr extends Expr {
  InterestingExpr() { nullCheckInCondition(this, _, _) }
}

predicate nullCheckAssert(InterestingExpr e, Variable v, Declaration qualifier) {
  exists(File f, int i |
    e.getLocation().getStartLine() = i and
    e.getFile() = f and
    assertInvocation(f, i) and
    nullCheckInCondition(e, v, qualifier)
  )
}

VariableAccess qualifiedAccess(Variable v, Declaration qualifier) {
  result = v.getAnAccess() and
  (
    result.getQualifier().(VariableAccess).getTarget() = qualifier
    or
    exists(PointerDereferenceExpr e, VariableAccess va | result.getQualifier() = e |
      e.getOperand() = va and va.getTarget() = qualifier
    )
    or
    not exists(result.getQualifier()) and qualifier = result.getEnclosingFunction()
    or
    result.getQualifier() instanceof ThisExpr and qualifier = result.getEnclosingFunction()
  )
}

predicate nullCheckInCondition(Expr e, Variable v, Declaration qualifier) {
  // if(v)
  exists(FunctionCall fc |
    relevantFunctionCall(fc, _) and fc = assignedValueForVariableAndQualifier(v, qualifier)
  |
    e = qualifiedAccess(v, qualifier)
  )
  or
  exists(AssignExpr a | a = e and a.getLValue() = qualifiedAccess(v, qualifier))
  or
  // if(v == NULL), if(v != NULL), if(NULL != v), if(NULL == v)
  exists(EqualityOperation eq |
    eq = e and
    nullCheckInCondition(eq.getAnOperand(), v, qualifier) and
    eq.getAnOperand().getValue() = "0"
  )
  or
  // if(v && something)
  exists(LogicalAndExpr exp | exp = e and nullCheckInCondition(exp.getAnOperand(), v, qualifier))
  or
  // if(v || something)
  exists(LogicalOrExpr exp | exp = e and nullCheckInCondition(exp.getAnOperand(), v, qualifier))
  or
  // if(!v)
  exists(NotExpr exp | exp = e and nullCheckInCondition(exp.getAnOperand(), v, qualifier))
  or
  exists(FunctionCall c |
    c = e and
    nullCheckInCondition(c.getAnArgument(), v, qualifier) and
    c.getTarget().getName() = "__builtin_expect"
  )
  or
  exists(ConditionDeclExpr d | d = e and nullCheckInCondition(d.getVariableAccess(), v, qualifier))
}

predicate hasNullCheck(Function enclosing, Variable v, Declaration qualifier) {
  exists(Expr exp |
    nullCheckInCondition(exp, v, qualifier) and exp.getEnclosingFunction() = enclosing
  |
    exists(ControlStructure s | exp = s.getControllingExpr())
    or
    exists(ConditionalExpr e | exp = e.getCondition())
    or
    exists(ReturnStmt s | exp = s.getExpr() and not exp instanceof VariableAccess)
    or
    exists(AssignExpr e | exp = e.getRValue() and not exp instanceof VariableAccess)
    or
    exists(AggregateLiteral al | exp = al.getAChild() and not exp instanceof VariableAccess)
    or
    exists(Variable other |
      exp = other.getInitializer().getExpr() and not exp instanceof VariableAccess
    )
  )
}

Expr assignedValueForVariableAndQualifier(Variable v, Declaration qualifier) {
  result = v.getInitializer().getExpr() and qualifier = result.getEnclosingFunction()
  or
  exists(AssignExpr e | e.getLValue() = qualifiedAccess(v, qualifier) and result = e.getRValue())
}

predicate checkedFunctionCall(FunctionCall fc) {
  relevantFunctionCall(fc, _) and
  exists(Variable v, Declaration qualifier |
    fc = assignedValueForVariableAndQualifier(v, qualifier)
  |
    hasNullCheck(fc.getEnclosingFunction(), v, qualifier)
  )
}

predicate uncheckedFunctionCall(FunctionCall fc) {
  relevantFunctionCall(fc, _) and
  not checkedFunctionCall(fc) and
  not exists(File f, int line | f = fc.getFile() and line = fc.getLocation().getEndLine() |
    assertInvocation(f, line + 1) or assertInvocation(f, line)
  ) and
  not exists(Variable v, Declaration qualifier |
    fc = assignedValueForVariableAndQualifier(v, qualifier)
  |
    nullCheckAssert(_, v, qualifier)
  ) and
  not exists(ControlStructure s | callResultNullCheckInCondition(s.getControllingExpr(), fc)) and
  not exists(FunctionCall other, Variable v, Declaration qualifier, Expr arg |
    fc = assignedValueForVariableAndQualifier(v, qualifier)
  |
    arg = other.getAnArgument() and
    nullCheckInCondition(arg, v, qualifier) and
    not arg instanceof VariableAccess
  )
}

Declaration functionQualifier(FunctionCall fc) {
  fc.getQualifier().(VariableAccess).getTarget() = result
  or
  exists(PointerDereferenceExpr e, VariableAccess va |
    fc.getQualifier() = e and e.getOperand() = va and va.getTarget() = result
  )
  or
  not exists(fc.getQualifier()) and result = fc.getEnclosingFunction()
  or
  fc.getQualifier() instanceof ThisExpr and result = fc.getEnclosingFunction()
}

predicate callTargetAndEnclosing(FunctionCall fc, Function target, Function enclosing) {
  target = fc.getTarget() and enclosing = fc.getEnclosingFunction()
}

predicate callArgumentVariable(FunctionCall fc, Variable v, int i) {
  fc.getArgument(i) = v.getAnAccess()
}

predicate callResultNullCheckInCondition(Expr e, FunctionCall fc) {
  // if(v)
  exists(FunctionCall other |
    e = other and
    relevantFunctionCall(fc, _) and
    not checkedFunctionCall(fc) and
    exists(Function called, Function enclosing |
      callTargetAndEnclosing(fc, called, enclosing) and
      callTargetAndEnclosing(other, called, enclosing)
    ) and
    forall(Variable v, int i | callArgumentVariable(fc, v, i) | callArgumentVariable(other, v, i)) and
    (
      functionQualifier(fc) = functionQualifier(other)
      or
      not exists(functionQualifier(fc)) and not exists(functionQualifier(other))
    )
  )
  or
  // if(v == NULL), if(v != NULL), if(NULL != v), if(NULL == v)
  exists(EqualityOperation eq |
    eq = e and
    callResultNullCheckInCondition(eq.getAnOperand(), fc) and
    eq.getAnOperand().getValue() = "0"
  )
  or
  // if(v && something)
  exists(LogicalAndExpr exp | exp = e and callResultNullCheckInCondition(exp.getAnOperand(), fc))
  or
  // if(v || something)
  exists(LogicalOrExpr exp | exp = e and callResultNullCheckInCondition(exp.getAnOperand(), fc))
  or
  // if(!v)
  exists(NotExpr exp | exp = e and callResultNullCheckInCondition(exp.getAnOperand(), fc))
}

predicate dereferenced(Variable v, Declaration qualifier, Function f) {
  exists(PointerDereferenceExpr e |
    e.getOperand() = qualifiedAccess(v, qualifier) and
    e.getEnclosingFunction() = f and
    not exists(SizeofExprOperator s | s.getExprOperand() = e)
  )
  or
  exists(FunctionCall c |
    c.getQualifier() = qualifiedAccess(v, qualifier) and
    c.getEnclosingFunction() = f
  )
  or
  exists(VariableAccess va |
    va.getQualifier() = qualifiedAccess(v, qualifier) and
    va.getEnclosingFunction() = f
  )
}

predicate relevantFunctionCall(FunctionCall fc, Function f) {
  fc.getTarget() = f and
  exists(Variable v, Declaration qualifier |
    fc = assignedValueForVariableAndQualifier(v, qualifier)
  |
    dereferenced(v, qualifier, fc.getEnclosingFunction())
  ) and
  not okToIgnore(fc)
}

predicate okToIgnore(FunctionCall fc) { fc.isInMacroExpansion() }

predicate functionStats(Function f, int percentage) {
  exists(int used, int total |
    exists(PointerType pt | pt.getATypeNameUse() = f.getADeclarationEntry()) and
    used = strictcount(FunctionCall fc | checkedFunctionCall(fc) and f = fc.getTarget()) and
    total = strictcount(FunctionCall fc | relevantFunctionCall(fc, f)) and
    percentage = used * 100 / total
  )
}

from FunctionCall unchecked, Function f, int percent
where
  relevantFunctionCall(unchecked, f) and
  uncheckedFunctionCall(unchecked) and
  functionStats(f, percent) and
  percent >= 70
select unchecked,
  "The result of this call to " + f.getName() + " is not checked for null, but " + percent +
    "% of calls to " + f.getName() + " check for null."
