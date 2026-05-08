/** Provides functionality for inferring types. */

private import Type
private import TypeAbstraction
private import TypeAbstraction as TA
private import Type
private import Type as T
private import TypeMention
private import codeql.util.Void
private import codeql.typeinference.internal.TypeInference

class Type = T::Type;

private module Input1 implements InputSig1<Location> {
  private import codeql.swift.generated.Raw
  private import codeql.swift.generated.Synth

  class Type = T::Type;

  class UnknownType = T::UnknownType;

  class TypeParameter = T::TypeParameter;

  class TypeAbstraction = TA::TypeAbstraction;

  class TypeArgumentPosition = Void; // Swift does not support explicit type arguments

  class TypeParameterPosition = int;

  bindingset[apos]
  bindingset[ppos]
  predicate typeArgumentParameterPositionMatch(TypeArgumentPosition apos, TypeParameterPosition ppos) {
    none()
  }

  int getTypeParameterId(TypeParameter tp) {
    tp =
      rank[result](TypeParameter tp0, int kind, int id1, int id2 |
        kind = 1 and
        id1 = idOfTypeParameterAstNode(tp0.(GenericTypeParamDeclTypeParameter).getDecl()) and
        id2 = 0
        or
        kind = 2 and
        id1 = idOfTypeParameterAstNode(tp0.(AssociatedTypeTypeParameter).getProtocol()) and
        id2 = idOfTypeParameterAstNode(tp0.(AssociatedTypeTypeParameter).getAssociatedType())
        or
        kind = 3 and
        id1 = idOfTypeParameterAstNode(tp0.(SelfTypeParameter).getProtocol()) and
        id2 = 0
        or
        kind = 4 and
        tp0 = TTupleTypeTypeParameter(id1, id2)
      |
        tp0 order by kind, id1, id2
      )
  }
}

private import Input1

private module M1 = Make1<Location, Input1>;

import M1

predicate getTypePathLimit = Input1::getTypePathLimit/0;

predicate getTypeParameterId = Input1::getTypeParameterId/1;

class TypePath = M1::TypePath;

module TypePath = M1::TypePath;

private module Input2 implements InputSig2<TypeMention> {
  TypeMention getATypeParameterConstraint(TypeParameter tp) {
    result.(GenericContextMention).getContext() = tp.(SelfTypeParameter).getProtocol()
    or
    // todo: type parameter constraints
    result.(GenericContextMention).getContext() =
      tp.(GenericTypeParamDeclTypeParameter).getDecl().(GenericTypeParamDecl).getABaseTypeDecl()
  }

  /**
   * Use the constraint mechanism in the shared type inference library to
   * support class hierarchies.
   *
   * See the documentation of `conditionSatisfiesConstraint` in the shared type
   * inference module for more information.
   */
  predicate conditionSatisfiesConstraint(
    TypeAbstraction abs, TypeMention condition, TypeMention constraint, boolean transitive
  ) {
    transitive = true and
    condition.(GenericContextMention).getContext() =
      any(GenericContext ctx |
        abs = ctx and
        ctx =
          [
            constraint.(TypeDeclBaseTypeMention).getDecl().(GenericContext),
            constraint.(ExtensionDeclBaseTypeMention).getDecl()
          ]
      )
  }

  predicate typeParameterIsFunctionallyDetermined(TypeParameter tp) {
    tp instanceof AssociatedTypeTypeParameter // todo: check
  }

  predicate typeAbstractionHasAmbiguousConstraintAt(
    TypeAbstraction abs, Type constraint, TypePath path
  ) {
    none() // todo
  }
}

private import Input2

private module M2 = Make2<TypeMention, Input2>;

import M2

private module Input3 implements InputSig3 {
  private import swift as Swift

  predicate cachedStageRevRef() { MethodCallResolution::resolveMethodCall(_, _) implies any() }

  predicate inferType = M3::inferType/2;

  class BoolType extends TypeDeclType {
    BoolType() { this.getDecl() = any(Swift::BoolType b).(AnyGenericType).getDeclaration() } // check
  }

  class AstNode = Swift::AstNode;

  TypeMention getTypeAnnotation(AstNode n) {
    result.(ParamDeclTypeMention).getDecl() = n
    or
    result.(TypedPatternTypeMention).getPattern() = n
    // todo: more cases, like local variables with explicit type annotations and casts
  }

  class Expr = Swift::Expr;

  class Switch extends AstNode {
    Switch() { none() }

    Expr getExpr() { none() }

    Case getCase(int index) { none() }
  }

  class Case extends AstNode {
    Case() { none() }

    AstNode getAPattern() { none() }

    AstNode getBody() { none() }
  }

  class ConditionalExpr extends IfExpr {
    Expr getThen() { result = super.getThenExpr() }

    Expr getElse() { result = super.getElseExpr() }
  }

  abstract class BinaryExpr extends Expr {
    abstract Expr getLeftOperand();

    abstract Expr getRightOperand();
  }

  class LogicalAndExpr extends BinaryExpr instanceof Swift::LogicalAndExpr {
    override Expr getLeftOperand() { result = Swift::LogicalAndExpr.super.getLeftOperand() }

    override Expr getRightOperand() { result = Swift::LogicalAndExpr.super.getRightOperand() }
  }

  class LogicalOrExpr extends BinaryExpr instanceof Swift::LogicalOrExpr {
    override Expr getLeftOperand() { result = Swift::LogicalOrExpr.super.getLeftOperand() }

    override Expr getRightOperand() { result = Swift::LogicalOrExpr.super.getRightOperand() }
  }

  abstract class Assignment extends BinaryExpr { }

  class AssignExpr extends Assignment instanceof Swift::AssignExpr {
    override Expr getLeftOperand() { result = Swift::AssignExpr.super.getDest() }

    override Expr getRightOperand() { result = Swift::AssignExpr.super.getSource() }
  }

  class ParenExpr extends Swift::ParenExpr {
    Expr getExpr() { result = super.getSubExpr() }
  }

  class Variable extends Swift::VarDecl {
    AstNode getDefiningNode() { result = this }

    Expr getAnAccess() { result = super.getAnAccess() }
  }

  abstract class LetDeclaration extends AstNode {
    abstract predicate isCoercionSite();

    abstract AstNode getLeftOperand();

    abstract AstNode getRightOperand();
  }

  private class PatternBindingDeclLetDeclaration extends LetDeclaration, PatternBindingDecl {
    override predicate isCoercionSite() { none() } // todo

    override AstNode getLeftOperand() { result = this.getPattern(0) }

    override AstNode getRightOperand() { result = this.getInit(0) }
  }

  class CallResolutionContext = Unit;

  class TypePosition extends int {
    bindingset[this]
    TypePosition() { exists(this) }

    predicate isSelf() { this = -1 }

    predicate isReturn() { this = -2 }
  }

  class Callable extends Function {
    TypeParameter getTypeParameter(int i) {
      result.(GenericTypeParamDeclTypeParameter).getDecl() = this.getGenericTypeParam(i)
    }

    TypeMention getAdditionalTypeParameterConstraint(TypeParameter tp) { none() } // todo

    Type getDeclaredType(TypePosition pos, TypePath path) {
      exists(ParamDeclTypeMention param | result = param.getTypeAt(path) |
        pos.isSelf() and
        param.getDecl() = this.getSelfParam()
        or
        param.getDecl() = this.getParam(pos)
      )
      or
      exists(CallableReturnTypeMention ret |
        this = ret.getCallable() and
        pos.isReturn() and
        result = ret.getTypeAt(path)
      )
    }
  }

  class Call extends CallExpr {
    Type getTypeArgument(TypeArgumentPosition apos, TypePath path) { none() }

    AstNode getNodeAt(TypePosition pos) {
      result = this.getQualifier() and
      pos.isSelf()
      or
      result = this.getArgument(pos).getExpr()
      or
      pos.isReturn() and
      result = this
    }

    Callable getTargetCertain() { none() }

    Callable getTarget(CallResolutionContext ctx) {
      exists(ctx) and
      result = getCallTarget(this)
    }
  }

  Type inferCallReturnType(AstNode n, TypePath path) {
    result = M3::inferCallReturnType(_, _, n, path)
  }

  Type inferCallArgumentTypeTopDown(AstNode n, TypePath path) {
    result = M3::inferCallArgumentTypeTopDown(_, _, _, n, path)
  }

  predicate inferStepSymmetric(AstNode n1, TypePath path1, AstNode n2, TypePath path2) {
    path1.isEmpty() and
    path2.isEmpty() and
    exists(Variable v |
      n1 = v.getParentPattern() and
      n2 = v.getDefiningNode()
    )
  }

  predicate inferStep(AstNode n1, TypePath path1, AstNode n2, TypePath path2) {
    path1.isEmpty() and
    path2.isEmpty() and
    exists(Variable v |
      n1 = v.getParentInitializer() and
      n2 = v.getDefiningNode()
    )
  }

  predicate inferLubStep(AstNode n1, TypePath path1, AstNode n2, TypePath path2) {
    n1 = n2.(ArrayExpr).getAnElement() and
    path1.isEmpty() and
    path2 = TypePath::singleton(any(ArrayType at).getPositionalTypeParameter(0))
  }

  Type inferTypeTopDown(AstNode n, TypePath path) { none() }

  pragma[nomagic]
  private Type inferLiteralType(AstNode n, TypePath path) {
    path.isEmpty() and
    (
      n instanceof StringLiteralExpr and
      result instanceof StringType
      or
      n instanceof IntegerLiteralExpr and
      result instanceof IntType
      or
      n instanceof ArrayExpr and
      result instanceof ArrayType
    )
  }

  Type inferTypeSpecific(AstNode n, TypePath path) { result = inferLiteralType(n, path) }
}

private module M3 = Make3<Input3>;

predicate inferType = M3::inferType/1;

predicate inferType = M3::inferType/2;

predicate inferTypeCertain = M3::inferTypeCertain/2;

private module MethodCallResolution {
  private class MethodCall extends MethodCallExpr {
    pragma[nomagic]
    predicate hasInfo(string name, int arity) {
      name =
        this.getFunction()
            .(MethodLookupExpr)
            .getMethodRef()
            .(DeclRefExpr)
            .getDecl()
            .(Method)
            .getName() and
      arity = this.getNumberOfArguments()
    }

    Type getTypeAt(TypePath path) { result = inferType(this.getQualifier(), path) }
  }

  pragma[nomagic]
  private predicate methodInfo(Method m, string name, int arity, TypeMention selfType) {
    name = m.getName() and
    arity = m.getNumberOfParams() and
    (
      selfType.(ParamDeclTypeMention).getDecl() = m.getSelfParam()
      or
      exists(ExtensionDecl decl |
        decl = selfType.(GenericContextMention).getContext() and
        m.getDeclaringDecl() = decl
      )
    )
  }

  private module MethodCallQualifierSatisfiesSelfTypeInput implements
    SatisfiesConstraintInputSig<MethodCall, TypeMention>
  {
    additional predicate relevantConstraint(MethodCall call, TypeMention constraint, Method m) {
      exists(string name, int arity |
        call.hasInfo(name, arity) and
        methodInfo(m, name, arity, constraint)
      )
    }

    pragma[nomagic]
    predicate relevantConstraint(MethodCall call, TypeMention constraint) {
      relevantConstraint(call, constraint, _)
    }
  }

  private module MethodCallQualifierSatisfiesSelfType =
    SatisfiesConstraint<MethodCall, TypeMention, MethodCallQualifierSatisfiesSelfTypeInput>;

  cached
  predicate resolveMethodCall(MethodCallExpr call, Method m) {
    M3::CachedStage::ref() and
    exists(TypeMention selfType |
      MethodCallQualifierSatisfiesSelfType::satisfiesConstraint(call, selfType, _, _) and
      MethodCallQualifierSatisfiesSelfTypeInput::relevantConstraint(call, selfType, m)
    )
  }
}

Callable getCallTarget(CallExpr call) {
  MethodCallResolution::resolveMethodCall(call, result)
  or
  // todo: implement in QL
  result = call.getStaticTarget() and
  (
    not call instanceof MethodCallExpr
    or
    result instanceof Initializer
  )
}

module Consistency {
  import M2::Consistency
}
