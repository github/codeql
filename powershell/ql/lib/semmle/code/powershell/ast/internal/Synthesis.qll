private import TAst
private import Ast
private import Location
private import Variable
private import TypeConstraint
private import Expr
private import Parameter
private import ExprStmt
private import NamedBlock
private import FunctionBase
private import ScriptBlock
private import Command
private import Internal::Private
private import Type
private import Scopes
private import BoolLiteral
private import Member
private import EnvVariable
private import Raw.Raw as Raw
private import codeql.util.Boolean
private import AutomaticVariable

newtype VarKind =
  ThisVarKind() or
  ParamVarRealKind() or
  ParamVarPipelineKind() or
  PipelineIteratorKind() or
  PipelineByPropertyNameIteratorKind(string name) {
    exists(Raw::ProcessBlock pb |
      name = pb.getScriptBlock().getParamBlock().getAPipelineByPropertyNameParameter().getName()
    )
  }

newtype SynthKind =
  ExprStmtKind() or
  VarAccessRealKind(VariableReal v) or
  VarAccessSynthKind(VariableSynth v) or
  FunctionSynthKind() or
  TypeSynthKind() or
  BoolLiteralKind(Boolean b) or
  NullLiteralKind() or
  EnvVariableKind(string var) { Raw::isEnvVariableAccess(_, var) } or
  AutomaticVariableKind(string var) { Raw::isAutomaticVariableAccess(_, var) } or
  VarSynthKind(VarKind k)

newtype Child =
  SynthChild(SynthKind kind) or
  RealChildRef(TAstReal n) or
  SynthChildRef(TAstSynth n)

pragma[inline]
private Child childRef(TAst n) {
  result = RealChildRef(n)
  or
  result = SynthChildRef(n)
}

private newtype TSynthesis = MkSynthesis()

class Synthesis extends TSynthesis {
  predicate child(Raw::Ast parent, ChildIndex i, Child child) { none() }

  Location getLocation(Ast n) { none() }

  predicate isRelevant(Raw::Ast a) { none() }

  string toString(Ast n) { none() }

  Ast getResultAstImpl(Raw::Ast r) { none() }

  predicate explicitAssignment(Raw::Ast dest, string name, Raw::Ast assignment) { none() }

  predicate implicitAssignment(Raw::Ast dest, string name) { none() }

  predicate variableSynthName(VariableSynth v, string name) { none() }

  predicate exprStmtExpr(ExprStmt e, Expr expr) { none() }

  predicate parameterStaticType(Parameter p, string type) { none() }

  predicate isPipelineParameter(Parameter p) { none() }

  predicate pipelineParameterHasIndex(ScriptBlock s, int i) { none() }

  predicate functionName(FunctionBase f, string name) { none() }

  predicate memberName(Member m, string name) { none() }

  predicate typeName(Type t, string name) { none() }

  predicate typeMember(Type t, int i, Member m) { none() }

  predicate functionScriptBlock(FunctionBase f, ScriptBlock block) { none() }

  predicate isNamedArgument(CmdCall call, int i, string name) { none() }

  predicate booleanValue(BoolLiteral b, boolean value) { none() }

  predicate envVariableName(EnvVariable var, string name) { none() }

  predicate automaticVariableName(AutomaticVariable var, string name) { none() }

  final string toString() { none() }
}

/** Gets the user-facing AST element that is generated from `r`. */
Ast getResultAst(Raw::Ast r) {
  not any(Synthesis s).isRelevant(r) and
  toRaw(result) = r
  or
  any(Synthesis s).isRelevant(r) and
  result = any(Synthesis s).getResultAstImpl(r)
}

Raw::Ast getRawAst(Ast r) { r = getResultAst(result) }

private module ThisSynthesis {
  private class ThisSynthesis extends Synthesis {
    override predicate child(Raw::Ast parent, ChildIndex i, Child child) {
      parent instanceof Raw::MethodScriptBlock and
      i = ThisVar() and
      child = SynthChild(VarSynthKind(ThisVarKind()))
      or
      parent.getChild(toRawChildIndex(i)).(Raw::VarAccess).getUserPath().toLowerCase() = "this" and
      child = SynthChild(VarAccessSynthKind(TVariableSynth(parent.getScope(), ThisVar())))
    }

    override predicate variableSynthName(VariableSynth v, string name) {
      v = TVariableSynth(_, ThisVar()) and
      name = "this"
    }

    override Location getLocation(Ast n) {
      exists(Raw::Ast scope |
        n = TVariableSynth(scope, ThisVar()) and
        result = scope.getLocation()
      )
    }
  }
}

private module SetVariableAssignment {
  private class SetVariableAssignment extends Synthesis {
    override predicate explicitAssignment(Raw::Ast dest, string name, Raw::Ast assignment) {
      exists(Raw::Cmd cmd |
        assignment = cmd and
        cmd.getCommandName().toLowerCase() = "set-variable" and
        cmd.getNamedArgument("name") = dest and
        name = dest.(Raw::StringConstExpr).getValue().getValue()
      )
    }
  }
}

/**
 * Syntesize parameters from parameter blocks and function definitions
 * so that they have a uniform API.
 */
private module ParameterSynth {
  private class ParameterSynth extends Synthesis {
    final override predicate isRelevant(Raw::Ast a) { a = any(Scope::Range r).getAParameter() }

    private predicate parameter(
      Raw::Ast parent, ChildIndex i, Raw::Parameter p, Child child, boolean isPipelineParameter
    ) {
      exists(Scope::Range r, int index |
        p = r.getParameter(index) and
        parent = r and
        i = funParam(index) and
        child = SynthChild(VarSynthKind(ParamVarRealKind())) and
        if p instanceof Raw::PipelineParameter
        then isPipelineParameter = true
        else isPipelineParameter = false
      )
    }

    final override predicate isPipelineParameter(Parameter p) {
      exists(Raw::Ast parent, ChildIndex i |
        parent = getRawAst(p.getFunction().getBody()) and
        this.isPipelineParameterChild(parent, _, i) and
        p = TVariableSynth(parent, i)
      )
    }

    override predicate implicitAssignment(Raw::Ast dest, string name) {
      exists(Raw::Parameter p |
        dest = p and
        name = p.getName()
      )
    }

    final override predicate variableSynthName(VariableSynth v, string name) {
      exists(Raw::Ast parent, int i, Raw::Parameter p |
        this.parameter(parent, FunParam(i), p, _, false) and
        v = TVariableSynth(parent, FunParam(i)) and
        name = p.getName()
      )
      or
      exists(Raw::Ast parent |
        this.child(parent, PipelineParamVar(), _) and
        v = TVariableSynth(parent, PipelineParamVar()) and
        name = "[synth] pipeline"
      )
    }

    private predicate isPipelineParameterChild(Raw::Ast parent, int index, ChildIndex i) {
      exists(Scope::Range r | parent = r and i = PipelineParamVar() |
        r.getParameter(index) instanceof Raw::PipelineParameter
        or
        not r.getAParameter() instanceof Raw::PipelineParameter and
        index = synthPipelineParameterChildIndex(r)
      )
    }

    final override predicate pipelineParameterHasIndex(ScriptBlock s, int i) {
      exists(Raw::ScriptBlock scriptBlock |
        s = TScriptBlock(scriptBlock) and
        this.isPipelineParameterChild(scriptBlock, i, _)
      )
    }

    final override predicate child(Raw::Ast parent, ChildIndex i, Child child) {
      // Synthesize parameters
      this.parameter(parent, i, _, child, false)
      or
      // Synthesize pipeline parameter
      child = SynthChild(VarSynthKind(ParamVarPipelineKind())) and
      this.isPipelineParameterChild(parent, _, i)
      or
      // Synthesize default values
      exists(Raw::Parameter q |
        parent = q and
        this.parameter(_, _, q, _, _)
      |
        i = paramDefaultVal() and
        child = childRef(getResultAst(q.getDefaultValue()))
        or
        exists(int index |
          i = paramAttr(index) and
          child = childRef(getResultAst(q.getAttribute(index)))
        )
      )
    }

    final override Parameter getResultAstImpl(Raw::Ast r) {
      exists(Raw::Ast parent, int i |
        this.parameter(parent, FunParam(i), r, _, false) and
        result = TVariableSynth(parent, FunParam(i))
      )
      or
      exists(Scope::Range scope, int i, ChildIndex index |
        scope.getParameter(i) = r and
        this.isPipelineParameterChild(scope, i, index) and
        result = TVariableSynth(scope, index)
      )
    }

    final override Location getLocation(Ast n) {
      exists(Raw::Ast parent, Raw::Parameter p, int i |
        this.parameter(parent, _, p, _, _) and
        n = TVariableSynth(parent, FunParam(i)) and
        result = p.getLocation()
      )
    }

    final override predicate parameterStaticType(Parameter n, string type) {
      exists(Raw::Ast parent, int i, Raw::Parameter p |
        this.parameter(parent, FunParam(i), p, _, false) and
        n = TVariableSynth(parent, FunParam(i)) and
        type = p.getStaticType()
      )
    }
  }
}

/**
 * Holds if `child` is a child of `n` that is a `Stmt` in the raw AST, but should
 * be mapped to an `Expr` in the synthesized AST.
 */
private predicate mustHaveExprChild(Raw::Ast n, Raw::Stmt child) {
  n.(Raw::AssignStmt).getRightHandSide() = child
  or
  n.(Raw::Pipeline).getAComponent() = child
  or
  n.(Raw::ReturnStmt).getPipeline() = child
  or
  n.(Raw::HashTableExpr).getAStmt() = child
  or
  n.(Raw::ParenExpr).getBase() = child
  or
  n.(Raw::DoUntilStmt).getCondition() = child
  or
  n.(Raw::DoWhileStmt).getCondition() = child
  or
  n.(Raw::ExitStmt).getPipeline() = child
  or
  n.(Raw::ForEachStmt).getIterableExpr() = child
  or
  // TODO: What to do about initializer and iterator?
  exists(Raw::ForStmt for | n = for | for.getCondition() = child)
  or
  n.(Raw::IfStmt).getACondition() = child
  or
  n.(Raw::SwitchStmt).getCondition() = child
  or
  n.(Raw::ThrowStmt).getPipeline() = child
  or
  n.(Raw::WhileStmt).getCondition() = child
}

private class RawStmtThatShouldBeExpr extends Raw::Stmt {
  RawStmtThatShouldBeExpr() {
    this instanceof Raw::Cmd or
    this instanceof Raw::Pipeline or
    this instanceof Raw::PipelineChain or
    this instanceof Raw::IfStmt
  }

  Expr getExpr() {
    result = TCmd(this)
    or
    result = TPipeline(this)
    or
    result = TPipelineChain(this)
    or
    result = TIf(this)
  }
}

/**
 * Insert expr-to-stmt conversions where needed.
 */
private module ExprToStmtSynth {
  private class ExprToStmtSynth extends Synthesis {
    private predicate exprToSynthStmtChild(Raw::Ast parent, ChildIndex i, Raw::Stmt stmt, Expr e) {
      this.child(parent, i, SynthChild(ExprStmtKind()), stmt) and
      e = stmt.(RawStmtThatShouldBeExpr).getExpr()
    }

    private predicate child(Raw::Ast parent, ChildIndex i, Child child, Raw::Stmt stmt) {
      // Synthesize the expr-to-stmt conversion
      child = SynthChild(ExprStmtKind()) and
      stmt instanceof RawStmtThatShouldBeExpr and
      parent.getChild(toRawChildIndex(i)) = stmt and
      not mustHaveExprChild(parent, stmt)
    }

    final override predicate child(Raw::Ast parent, ChildIndex i, Child child) {
      this.child(parent, i, child, _)
    }

    final override predicate exprStmtExpr(ExprStmt e, Expr expr) {
      exists(Raw::Ast parent, ChildIndex i, Raw::Stmt stmt |
        e = TExprStmtSynth(parent, i) and
        this.exprToSynthStmtChild(parent, i, stmt, expr)
      )
    }

    final override Location getLocation(Ast n) {
      exists(Raw::Ast parent, ChildIndex i, Raw::Stmt stmt |
        n = TExprStmtSynth(parent, i) and
        this.exprToSynthStmtChild(parent, i, stmt, _) and
        result = stmt.getLocation()
      )
    }

    final override string toString(Ast n) {
      exists(Raw::Ast parent, ChildIndex i, Raw::Stmt stmt |
        n = TExprStmtSynth(parent, i) and
        this.exprToSynthStmtChild(parent, i, stmt, _) and
        result = stmt.toString()
      )
    }
  }
}
