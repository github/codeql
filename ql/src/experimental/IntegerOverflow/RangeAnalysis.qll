import go

//Builtin function `len`
class LenFunction extends BuiltinFunction {
  LenFunction() { this.getName().matches("len") }
}

Expr getAUse(SsaDefinition def) {
  result = def.getVariable().getAUse().(IR::EvalInstruction).getExpr()
}

/*
 *  calculate the upper bound of an expression
 */

float upperBound(Expr expr) { result = max(getUpperBounds(expr)) }

/*
 *  calculate the lower bound of an expression
 */

float lowerBound(Expr expr) { result = min(getLowerBounds(expr)) }

/*
 *  calculate the upper bound of an SSA definition
 */

float defUpperBound(SsaDefinition def) { result = max(getDefUpperBounds(def)) }

/*
 *  calculate the lower bound of an SSA definition
 */

float defLowerBound(SsaDefinition def) { result = min(getDefLowerBounds(def)) }

/*
 *  calculate all possible upper bounds of an expression
 */

float getUpperBounds(Expr expr) {
  if expr.isConst()
  then
    result = expr.getFloatValue() or
    result = expr.getIntValue() or
    result = expr.getExactValue().toFloat()
  else (
    //if an expression with parenthesis, strip the parenthesis first
    exists(ParenExpr paren |
      paren = expr and
      result = getUpperBounds(paren.stripParens())
    )
    or
    //if this expression is an identifier
    exists(SsaVariable v, Ident identifier |
      identifier = expr and
      identifier.refersTo(v.getSourceVariable()) and
      v.getAUse() = IR::evalExprInstruction(identifier) and
      (
        if
          //if a condition expression exists before and one of the operand happens to be the identifier, we use this condition expression to narrow down the range.
          exists(
            ControlFlow::ConditionGuardNode n, DataFlow::Node lesser, DataFlow::Node greater,
            ReachableBasicBlock bb
          |
            n.ensuresLeq(lesser, greater, _) and
            IR::evalExprInstruction(lesser.asExpr()) = v.getAUse() and
            n.dominates(bb) and
            bb.getANode() = IR::evalExprInstruction(identifier) and
            not exists(Expr e |
              e = v.getAUse().(IR::EvalInstruction).getExpr() and
              e.getParent*() = greater.asExpr()
            )
          )
        then
          exists(
            ControlFlow::ConditionGuardNode n, ReachableBasicBlock bb, DataFlow::Node lesser,
            DataFlow::Node greater, int bias
          |
            n.dominates(bb) and
            bb.getANode() = IR::evalExprInstruction(identifier) and
            n.ensuresLeq(lesser, greater, bias) and
            v.getAUse() = IR::evalExprInstruction(lesser.asExpr()) and
            not exists(Expr e |
              e = v.getAUse().(IR::EvalInstruction).getExpr() and
              e.getParent*() = greater.asExpr()
            ) and
            result = getUpperBounds(greater.asExpr()) + bias
          )
        else
          //If not, find the coresponding `SsaDefinition`, then call `getDefUpperBounds` on it.
          result = getDefUpperBounds(v.getDefinition())
      )
    )
    or
    //if this expression is an add expression
    exists(AddExpr add, float lhsUB, float rhsUB |
      add = expr and
      lhsUB = getUpperBounds(add.getLeftOperand()) and
      rhsUB = getUpperBounds(add.getRightOperand()) and
      result = addRoundingUp(lhsUB, rhsUB)
    )
    or
    //if this expression is an sub expression
    exists(SubExpr sub, float lhsUB, float rhsLB |
      sub = expr and
      lhsUB = getUpperBounds(sub.getLeftOperand()) and
      rhsLB = getLowerBounds(sub.getRightOperand()) and
      result = addRoundingUp(lhsUB, -rhsLB)
    )
    or
    //if this expression is an remainder operation
    exists(RemExpr rem | rem = expr |
      result = 0
      or
      exists(float lhsUB, float rhsLB, float rhsUB |
        lhsUB = getUpperBounds(rem.getLeftOperand()) and
        lhsUB > 0 and
        rhsLB = getLowerBounds(rem.getRightOperand()) and
        rhsUB = getUpperBounds(rem.getRightOperand())
      |
        result = rhsLB.abs() or
        result = rhsUB.abs()
      )
    )
    or
    //if this expression is an unary plus expression
    exists(PlusExpr plus |
      plus = expr and
      result = getUpperBounds(plus.getOperand())
    )
    or
    //if this expression is an unary minus expression
    exists(MinusExpr minus |
      minus = expr and
      result = -getLowerBounds(minus.getOperand())
    )
    or
    //if this expression is an multiply expression and one of the operator is a constant integer.
    exists(MulExpr mul |
      mul = expr and
      exists(mul.getAnOperand().getIntValue()) and
      if exists(mul.getLeftOperand().getIntValue())
      then
        exists(float lhs |
          lhs = mul.getLeftOperand().getIntValue() and
          (
            result = lhs * getUpperBounds(mul.getRightOperand()) or
            result = lhs * getLowerBounds(mul.getRightOperand())
          )
        )
      else
        exists(float rhs |
          rhs = mul.getRightOperand().getIntValue() and
          (
            result = rhs * getUpperBounds(mul.getLeftOperand()) or
            result = rhs * getLowerBounds(mul.getLeftOperand())
          )
        )
    )
    or
    //if this expression is a selector expression, simply returns maximum value which the expression can represent.
    exists(SelectorExpr sel, Entity e |
      sel = expr and
      sel.getSelector().refersTo(e) and
      result = typeMaxValue(e.getType())
    )
    or
    //if this expression is a conversion
    exists(ConversionExpr conv |
      conv = expr and
      result = typeMaxValue(conv.getType())
    )
    or
    //if this expression is an bitwise-and expression and one of the operator is an constant integer.
    exists(AndExpr bitAnd, int i, int j |
      bitAnd = expr and
      i = bitAnd.getAnOperand().getIntValue() and
      j in [0 .. 31] and
      i = 2.pow(j) - 1 and
      result = i
    )
    or
    //all other kind of expressions which we cannot determine the range
    (
      expr instanceof IndexExpr or
      expr instanceof CallExpr or
      expr instanceof StarExpr or
      expr instanceof DerefExpr
    ) and
    result = typeMaxValue(expr.getType())
  )
}

/*
 *  calculate all possible lower bounds of an expression
 */

float getLowerBounds(Expr expr) {
  if expr.isConst()
  then
    result = expr.getFloatValue() or
    result = expr.getIntValue() or
    result = expr.getExactValue().toFloat()
  else (
    exists(ParenExpr paren |
      paren = expr and
      result = getLowerBounds(paren.stripParens())
    )
    or
    //if this expression is an identifer
    exists(SsaVariable v, Ident identifier |
      identifier = expr and
      identifier.refersTo(v.getSourceVariable()) and
      v.getAUse() = IR::evalExprInstruction(identifier) and
      (
        //if exists a condition expression before this identifier
        if
          exists(
            ControlFlow::ConditionGuardNode n, DataFlow::Node greater, DataFlow::Node lesser,
            ReachableBasicBlock bb
          |
            n.ensuresLeq(lesser, greater, _) and
            IR::evalExprInstruction(greater.asExpr()) = v.getAUse() and
            n.dominates(bb) and
            bb.getANode() = IR::evalExprInstruction(identifier) and
            not exists(Expr e |
              e = v.getAUse().(IR::EvalInstruction).getExpr() and
              e.getParent*() = lesser.asExpr()
            )
          )
        then
          exists(
            ControlFlow::ConditionGuardNode n, ReachableBasicBlock bb, DataFlow::Node lesser,
            DataFlow::Node greater, int bias, float lbs
          |
            n.dominates(bb) and
            bb.getANode() = IR::evalExprInstruction(identifier) and
            n.ensuresLeq(lesser, greater, bias) and
            v.getAUse() = IR::evalExprInstruction(greater.asExpr()) and
            not exists(Expr e |
              e = v.getAUse().(IR::EvalInstruction).getExpr() and
              e.getParent*() = lesser.asExpr()
            ) and
            lbs = getLowerBounds(lesser.asExpr()) and
            result = lbs - bias
          )
        else
          //find coresponding SSA definition and calls `getDefLowerBounds` on it.
          result = getDefLowerBounds(v.getDefinition())
      )
    )
    or
    //add expr
    exists(AddExpr add, float lhsLB, float rhsLB |
      add = expr and
      lhsLB = getLowerBounds(add.getLeftOperand()) and
      rhsLB = getLowerBounds(add.getRightOperand()) and
      result = addRoundingDown(lhsLB, rhsLB)
    )
    or
    //sub expr
    exists(SubExpr sub, float lhsLB, float rhsUB |
      sub = expr and
      lhsLB = getLowerBounds(sub.getLeftOperand()) and
      rhsUB = getUpperBounds(sub.getRightOperand()) and
      result = addRoundingDown(lhsLB, -rhsUB)
    )
    or
    //remainder expr
    exists(RemExpr rem | rem = expr |
      result = 0
      or
      exists(float lhsLB, float rhsLB, float rhsUB |
        lhsLB = getLowerBounds(rem.getLeftOperand()) and
        lhsLB < 0 and
        rhsLB = getLowerBounds(rem.getRightOperand()) and
        rhsUB = getUpperBounds(rem.getRightOperand()) and
        (
          result = -rhsLB.abs() or
          result = -rhsUB.abs()
        )
      )
    )
    or
    //unary plus expr
    exists(PlusExpr plus |
      plus = expr and
      result = getLowerBounds(plus.getOperand())
    )
    or
    //unary minus expr
    exists(MinusExpr minus |
      minus = expr and
      result = -getUpperBounds(minus.getOperand())
    )
    or
    //multiply expression and one of the operator is an constant integer
    exists(MulExpr mul |
      mul = expr and
      exists(mul.getAnOperand().getIntValue()) and
      if exists(mul.getLeftOperand().getIntValue())
      then
        exists(float lhs |
          lhs = mul.getLeftOperand().getIntValue() and
          (
            result = lhs * getUpperBounds(mul.getRightOperand()) or
            result = lhs * getLowerBounds(mul.getRightOperand())
          )
        )
      else
        exists(float rhs |
          rhs = mul.getRightOperand().getIntValue() and
          (
            result = rhs * getUpperBounds(mul.getLeftOperand()) or
            result = rhs * getLowerBounds(mul.getLeftOperand())
          )
        )
    )
    or
    //selector expression
    exists(SelectorExpr sel, Entity e |
      sel = expr and
      sel.getSelector().refersTo(e) and
      result = typeMinValue(e.getType())
    )
    or
    //conversion expr
    exists(ConversionExpr conv |
      conv = expr and
      result = typeMinValue(conv.getType())
    )
    or
    //call expression when the function is builtin function `len`
    exists(CallExpr call |
      call = expr and
      if call.getTarget() instanceof LenFunction
      then result = 0
      else result = typeMinValue(call.getType())
    )
    or
    //bitwise-and expression and one of the operator is a constant integer
    exists(AndExpr bitAnd, int i, int j |
      bitAnd = expr and
      i = bitAnd.getAnOperand().getIntValue() and
      j in [0 .. 31] and
      i = 2.pow(j) - 1 and
      result = 0
    )
    or
    //other kind of expression which we cannot determine the range
    (
      expr instanceof IndexExpr or
      expr instanceof StarExpr or
      expr instanceof DerefExpr
    ) and
    result = typeMinValue(expr.getType())
  )
}

/*
 *  calculate all possible upper bounds of an SSA definition
 */

float getDefUpperBounds(SsaDefinition def) {
  if recursiveSelfDef(def)
  then none()
  else (
    if def instanceof SsaExplicitDefinition
    then
      exists(SsaExplicitDefinition explicitDef | explicitDef = def |
        //SSA definition coresponding to a `SimpleAssignStmt`
        if explicitDef.getInstruction() instanceof IR::AssignInstruction
        then
          exists(IR::AssignInstruction assignInstr, SimpleAssignStmt simpleAssign |
            assignInstr = explicitDef.getInstruction() and
            assignInstr.getRhs().(IR::EvalInstruction).getExpr() = simpleAssign.getRhs() and
            result = getUpperBounds(simpleAssign.getRhs())
          )
          or
          //SSA definition coresponding to a ValueSpec(used in a variable declaration)
          exists(IR::AssignInstruction declInstr, ValueSpec vs, int i, Expr init |
            declInstr = explicitDef.getInstruction() and
            declInstr = IR::initInstruction(vs, i) and
            init = vs.getInit(i) and
            result = getUpperBounds(init)
          )
          or
          //SSA definition coresponding to an `AddAssignStmt` (x += y) or `SubAssignStmt` (x -= y)
          exists(
            IR::AssignInstruction assignInstr, SsaExplicitDefinition prevDef,
            CompoundAssignStmt compoundAssign, float prevBound, float delta
          |
            assignInstr = explicitDef.getInstruction() and
            getAUse(prevDef) = compoundAssign.getLhs() and
            assignInstr = IR::assignInstruction(compoundAssign, 0) and
            prevBound = getDefUpperBounds(prevDef) and
            if compoundAssign instanceof AddAssignStmt
            then
              delta = getUpperBounds(compoundAssign.getRhs()) and
              result = addRoundingUp(prevBound, delta)
            else
              if compoundAssign instanceof SubAssignStmt
              then
                delta = getLowerBounds(compoundAssign.getRhs()) and
                result = addRoundingUp(prevBound, -delta)
              else none()
          )
        else
          //SSA definition coresponding to an `IncDecStmt`
          if explicitDef.getInstruction() instanceof IR::IncDecInstruction
          then
            exists(IncDecStmt incOrDec, IR::IncDecInstruction instr, float exprLB |
              instr = explicitDef.getInstruction() and
              exprLB = getUpperBounds(incOrDec.getOperand()) and
              instr.getRhs().(IR::EvalIncDecRhsInstruction).getStmt() = incOrDec and
              (
                //IncStmt(x++)
                exists(IncStmt inc |
                  inc = incOrDec and
                  result = addRoundingUp(exprLB, 1)
                )
                or
                //DecStmt(x--)
                exists(DecStmt dec |
                  dec = incOrDec and
                  result = addRoundingUp(exprLB, -1)
                )
              )
            )
          else
            //SSA definition coreponding to the init of the parameter
            if explicitDef.getInstruction() instanceof IR::InitParameterInstruction
            then
              exists(IR::InitParameterInstruction instr, Parameter p |
                instr = explicitDef.getInstruction() and
                IR::initParamInstruction(p) = instr and
                result = typeMaxValue(p.getType())
              )
            else none()
      )
    else
      //this SSA definition is a phi node.
      if def instanceof SsaPhiNode
      then
        exists(SsaPhiNode phi |
          phi = def and
          result = getDefUpperBounds(phi.getAnInput().getDefinition())
        )
      else none()
  )
}

/*
 *  calculate all possible lower bounds of an SSA definition
 */

float getDefLowerBounds(SsaDefinition def) {
  if recursiveSelfDef(def)
  then none()
  else (
    if def instanceof SsaExplicitDefinition
    then
      exists(SsaExplicitDefinition explicitDef | explicitDef = def |
        if explicitDef.getInstruction() instanceof IR::AssignInstruction
        then
          //SimpleAssignStmt
          exists(IR::AssignInstruction assignInstr, SimpleAssignStmt simpleAssign |
            assignInstr = explicitDef.getInstruction() and
            assignInstr.getRhs().(IR::EvalInstruction).getExpr() = simpleAssign.getRhs() and
            result = getLowerBounds(simpleAssign.getRhs())
          )
          or
          //ValueSpec
          exists(IR::AssignInstruction declInstr, ValueSpec vs, int i, Expr init |
            declInstr = explicitDef.getInstruction() and
            declInstr = IR::initInstruction(vs, i) and
            init = vs.getInit(i) and
            result = getLowerBounds(init)
          )
          or
          //AddAssignStmt(x += y)
          exists(
            IR::AssignInstruction assignInstr, SsaExplicitDefinition prevDef,
            CompoundAssignStmt compoundAssign, float prevBound, float delta
          |
            assignInstr = explicitDef.getInstruction() and
            getAUse(prevDef) = compoundAssign.getLhs() and
            assignInstr = IR::assignInstruction(compoundAssign, 0) and
            prevBound = getDefLowerBounds(prevDef) and
            if compoundAssign instanceof AddAssignStmt
            then
              delta = getLowerBounds(compoundAssign.getRhs()) and
              result = addRoundingDown(prevBound, delta)
            else
              if compoundAssign instanceof SubAssignStmt
              then
                delta = getUpperBounds(compoundAssign.getRhs()) and
                result = addRoundingDown(prevBound, -delta)
              else none()
          )
        else
          //IncDecStmt
          if explicitDef.getInstruction() instanceof IR::IncDecInstruction
          then
            exists(IncDecStmt incOrDec, IR::IncDecInstruction instr, float exprLB |
              instr = explicitDef.getInstruction() and
              exprLB = getLowerBounds(incOrDec.getOperand()) and
              instr.getRhs().(IR::EvalIncDecRhsInstruction).getStmt() = incOrDec and
              (
                //IncStmt(x++)
                exists(IncStmt inc |
                  inc = incOrDec and
                  result = addRoundingDown(exprLB, 1)
                )
                or
                //DecStmt(x--)
                exists(DecStmt dec |
                  dec = incOrDec and
                  result = addRoundingDown(exprLB, -1)
                )
              )
            )
          else
            //init of the function parameter
            if explicitDef.getInstruction() instanceof IR::InitParameterInstruction
            then
              exists(IR::InitParameterInstruction instr, Parameter p |
                instr = explicitDef.getInstruction() and
                IR::initParamInstruction(p) = instr and
                result = typeMinValue(p.getType())
              )
            else none()
      )
    else
      //phi node
      if def instanceof SsaPhiNode
      then
        exists(SsaPhiNode phi |
          phi = def and
          result = getDefLowerBounds(phi.getAnInput().getDefinition())
        )
      else none()
  )
}

/*
 *  decide if an SSA definition is depends on another SSA definition directively.
 *  The structure of this function needs to be same as `getDefLowerBounds`
 */

predicate defDependsOnDef(SsaDefinition nextDef, SsaDefinition prevDef) {
  //SSA definition coresponding to a `SimpleAssignStmt`
  exists(SimpleAssignStmt simpleAssign, int i |
    nextDef.(SsaExplicitDefinition).getInstruction().(IR::AssignInstruction) =
      IR::assignInstruction(simpleAssign, i) and
    defDependsOnExpr(prevDef, simpleAssign.getRhs())
  )
  or
  //SSA definition coresponding to a `ValueSpec`(used in variable declaration)
  exists(IR::AssignInstruction declInstr, ValueSpec vs, int i, Expr init |
    declInstr = nextDef.(SsaExplicitDefinition).getInstruction() and
    declInstr = IR::initInstruction(vs, i) and
    init = vs.getInit(i) and
    defDependsOnExpr(prevDef, init)
  )
  or
  //SSA definition coresponding to a `AddAssignStmt` or `SubAssignStmt`
  exists(CompoundAssignStmt compoundAssign |
    (compoundAssign instanceof AddAssignStmt or compoundAssign instanceof SubAssignStmt) and
    nextDef.(SsaExplicitDefinition).getInstruction() = IR::assignInstruction(compoundAssign, 0) and
    (
      getAUse(prevDef) = compoundAssign.getLhs() or
      defDependsOnExpr(prevDef, compoundAssign.getRhs())
    )
  )
  or
  //SSA definition coresponding to a `IncDecStmt`
  exists(IncDecStmt incDec |
    nextDef
        .(SsaExplicitDefinition)
        .getInstruction()
        .(IR::IncDecInstruction)
        .getRhs()
        .(IR::EvalIncDecRhsInstruction)
        .getStmt() = incDec and
    defDependsOnExpr(prevDef, incDec.getOperand())
  )
  or
  //if `nextDef` coresponding to the init of a parameter, there is no coresponding `prevDef`
  //if `nextDef` is a phi node and `prevDef` is one of the input of the phi node, then `nextDef` depends on `prevDef` directly.
  exists(SsaPhiNode phi | nextDef = phi and phi.getAnInput().getDefinition() = prevDef)
}

/*
 *  decide if a SSA definition depends on an expr. The structure of this function needs to be same as `getUpperBounds`
 */

predicate defDependsOnExpr(SsaDefinition def, Expr expr) {
  if expr.isConst()
  then none()
  else (
    //if an expression with parenthesis, strip the parenthesis
    exists(ParenExpr paren |
      paren = expr and
      defDependsOnExpr(def, paren.stripParens())
    )
    or
    exists(Ident ident |
      ident = expr and
      getAUse(def) = ident
    )
    or
    exists(AddExpr add | add = expr and defDependsOnExpr(def, add.getAnOperand()))
    or
    exists(SubExpr sub | sub = expr and defDependsOnExpr(def, sub.getAnOperand()))
    or
    exists(RemExpr rem | rem = expr and defDependsOnExpr(def, rem.getAnOperand()))
    or
    exists(PlusExpr plus |
      plus = expr and
      defDependsOnExpr(def, plus.getOperand())
    )
    or
    exists(MinusExpr minus |
      minus = expr and
      defDependsOnExpr(def, minus.getOperand())
    )
    or
    exists(MulExpr mul |
      mul = expr and
      defDependsOnExpr(def, mul.getAnOperand())
    )
    or
    //if the expr is a selector expression, we currently do not support analyze it.
    //if the expr is a conversion
    exists(ConversionExpr conv |
      conv = expr and
      defDependsOnExpr(def, conv.getOperand())
    )
    or
    exists(AndExpr bitAnd |
      bitAnd = expr and
      defDependsOnExpr(def, bitAnd.getAnOperand())
    )
  )
}

/*
 *  decide if a SSA definition depends on another SSA definition transitively
 */

predicate defDependsOnDefTransitively(SsaDefinition nextDef, SsaDefinition prevDef) {
  defDependsOnDef(nextDef, prevDef)
  or
  exists(SsaDefinition midDef |
    defDependsOnDef(nextDef, midDef) and
    defDependsOnDefTransitively(midDef, prevDef)
  )
}

/*
 *  decide if a SSA definition depends on self.
 */

predicate recursiveSelfDef(SsaDefinition def) { defDependsOnDefTransitively(def, def) }

/*
 *  get the maximum value an expression can represent.
 */

float getMaxRepresentableValue(Expr expr) {
  exists(Type t |
    t = expr.getType() and
    result = typeMaxValue(t)
  )
}

/*
 *  get the minimum value an expression can represent.
 */

float getMinRepresentableValue(Expr expr) {
  exists(Type t |
    t = expr.getType() and
    result = typeMinValue(t)
  )
}

/*
 *  get maximum value a type can represent.
 */

float typeMaxValue(Type t) {
  if t instanceof IntegerType
  then
    exists(IntegerType integerTp, int bits |
      integerTp = t and
      bits = min(integerTp.getASize()) and
      if integerTp instanceof SignedIntegerType
      then result = 2.pow(bits - 1) - 1
      else result = 2.pow(bits) - 1
    )
  else
    if t instanceof FloatType
    then result = 1.0 / 0.0
    else
      if t instanceof UintptrType
      then
        exists(UintptrType upt |
          upt = t and
          result = 2.pow(64) - 1
        )
      else none()
}

/*
 *  get minimum value a type can represent
 */

float typeMinValue(Type t) {
  if t instanceof IntegerType
  then
    exists(IntegerType integerTp, int bits |
      integerTp = t and
      bits = min(integerTp.getASize()) and
      if integerTp instanceof SignedIntegerType then result = -2.pow(bits - 1) else result = 0
    )
  else
    if t instanceof FloatType
    then result = -1.0 / 0.0
    else
      if t instanceof UintptrType
      then
        exists(UintptrType upt |
          upt = t and
          result = 0
        )
      else none()
}

/*
 *  decide if an expression may overflow
 */

predicate exprMayOverflow(Expr expr) { upperBound(expr) > getMaxRepresentableValue(expr) }

/*
 *  decide if an expression may underflow
 */

predicate exprMayUnderflow(Expr expr) { lowerBound(expr) < getMinRepresentableValue(expr) }

/**
 * Computes a normal form of `x` where -0.0 has changed to +0.0. This can be
 * needed on the lesser side of a floating-point comparison or on both sides of
 * a floating point equality because QL does not follow IEEE in floating-point
 * comparisons but instead defines -0.0 to be less than and distinct from 0.0.
 */
bindingset[x]
private float normalizeFloatUp(float x) { result = x + 0.0 }

/**
 * Computes `x + y`, rounded towards +Inf. This is the general case where both
 * `x` and `y` may be large numbers.
 */
bindingset[x, y]
float addRoundingUp(float x, float y) {
  if normalizeFloatUp((x + y) - x) < y or normalizeFloatUp((x + y) - y) < x
  then result = (x + y).nextUp()
  else result = (x + y)
}

/**
 * Computes `x + y`, rounded towards -Inf. This is the general case where both
 * `x` and `y` may be large numbers.
 */
bindingset[x, y]
float addRoundingDown(float x, float y) {
  if (x + y) - x > normalizeFloatUp(y) or (x + y) - y > normalizeFloatUp(x)
  then result = (x + y).nextDown()
  else result = (x + y)
}
