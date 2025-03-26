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
