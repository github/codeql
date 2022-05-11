private import TreeSitter
private import codeql.Locations
private import codeql.ruby.AST
private import codeql.ruby.ast.internal.AST
private import codeql.ruby.ast.internal.Parameter
private import codeql.ruby.ast.internal.Pattern
private import codeql.ruby.ast.internal.Scope
private import codeql.ruby.ast.internal.Synthesis

/**
 * Holds if `n` is in the left-hand-side of an explicit assignment `assignment`.
 */
predicate explicitAssignmentNode(Ruby::AstNode n, Ruby::AstNode assignment) {
  n = assignment.(Ruby::Assignment).getLeft()
  or
  n = assignment.(Ruby::OperatorAssignment).getLeft()
  or
  exists(Ruby::AstNode parent |
    parent = n.getParent() and
    explicitAssignmentNode(parent, assignment)
  |
    parent instanceof Ruby::DestructuredLeftAssignment
    or
    parent instanceof Ruby::LeftAssignmentList
    or
    parent instanceof Ruby::RestAssignment
  )
}

/** Holds if `n` is inside an implicit assignment. */
predicate implicitAssignmentNode(Ruby::AstNode n) {
  casePattern(n) and n instanceof Ruby::Identifier
  or
  n = any(Ruby::AsPattern p).getName()
  or
  n = any(Ruby::ArrayPattern parent).getChild(_).(Ruby::SplatParameter).getName()
  or
  n = any(Ruby::FindPattern parent).getChild(_).(Ruby::SplatParameter).getName()
  or
  n = any(Ruby::HashPattern parent).getChild(_).(Ruby::HashSplatParameter).getName()
  or
  n = any(Ruby::KeywordPattern parent | not exists(parent.getValue())).getKey()
  or
  n = any(Ruby::ExceptionVariable ev).getChild()
  or
  n = any(Ruby::For for).getPattern()
  or
  implicitAssignmentNode(n.getParent())
}

/** Holds if `n` is inside a parameter. */
predicate implicitParameterAssignmentNode(Ruby::AstNode n, Callable::Range c) {
  n = c.getParameter(_)
  or
  implicitParameterAssignmentNode(n.getParent().(Ruby::DestructuredParameter), c)
}

private predicate instanceVariableAccess(
  Ruby::InstanceVariable var, string name, Scope::Range scope, boolean instance
) {
  name = var.getValue() and
  scope = enclosingModuleOrClass(var) and
  if hasEnclosingMethod(var) then instance = true else instance = false
}

private predicate classVariableAccess(Ruby::ClassVariable var, string name, Scope::Range scope) {
  name = var.getValue() and
  scope = enclosingModuleOrClass(var)
}

private predicate hasEnclosingMethod(Ruby::AstNode node) {
  exists(Scope::Range s | scopeOf(node) = s and exists(s.getEnclosingMethod()))
}

private ModuleBase::Range enclosingModuleOrClass(Ruby::AstNode node) {
  exists(Scope::Range s | scopeOf(node) = s and result = s.getEnclosingModule())
}

private predicate parameterAssignment(Callable::Range scope, string name, Ruby::Identifier i) {
  implicitParameterAssignmentNode(i, scope) and
  name = i.getValue()
}

/** Holds if `scope` defines `name` in its parameter declaration at `i`. */
private predicate scopeDefinesParameterVariable(
  Callable::Range scope, string name, Ruby::Identifier i
) {
  // In case of overlapping parameter names (e.g. `_`), only the first
  // parameter will give rise to a variable
  i =
    min(Ruby::Identifier other |
      parameterAssignment(scope, name, other)
    |
      other order by other.getLocation().getStartLine(), other.getLocation().getStartColumn()
    )
  or
  exists(Parameter::Range p |
    p = scope.getParameter(_) and
    name = i.getValue()
  |
    i = p.(Ruby::BlockParameter).getName() or
    i = p.(Ruby::HashSplatParameter).getName() or
    i = p.(Ruby::KeywordParameter).getName() or
    i = p.(Ruby::OptionalParameter).getName() or
    i = p.(Ruby::SplatParameter).getName()
  )
}

pragma[nomagic]
private string variableNameInScope(Ruby::AstNode i, Scope::Range scope) {
  scope = scopeOf(i) and
  (
    result = i.(Ruby::Identifier).getValue()
    or
    exists(Ruby::KeywordPattern p | i = p.getKey() and not exists(p.getValue()) |
      result = i.(Ruby::String).getChild(0).(Ruby::StringContent).getValue() or
      result = i.(Ruby::HashKeySymbol).getValue()
    )
    or
    exists(Ruby::Pair p | i = p.getKey() and not exists(p.getValue()) |
      result = i.(Ruby::String).getChild(0).(Ruby::StringContent).getValue() or
      result = i.(Ruby::HashKeySymbol).getValue()
    )
  )
}

/** Holds if `name` is assigned in `scope` at `i`. */
private predicate scopeAssigns(Scope::Range scope, string name, Ruby::AstNode i) {
  (explicitAssignmentNode(i, _) or implicitAssignmentNode(i)) and
  name = variableNameInScope(i, scope)
}

cached
private module Cached {
  cached
  newtype TVariable =
    TGlobalVariable(string name) { name = any(Ruby::GlobalVariable var).getValue() } or
    TClassVariable(Scope::Range scope, string name, Ruby::AstNode decl) {
      decl =
        min(Ruby::ClassVariable other |
          classVariableAccess(other, name, scope)
        |
          other order by other.getLocation().getStartLine(), other.getLocation().getStartColumn()
        )
    } or
    TInstanceVariable(Scope::Range scope, string name, boolean instance, Ruby::AstNode decl) {
      decl =
        min(Ruby::InstanceVariable other |
          instanceVariableAccess(other, name, scope, instance)
        |
          other order by other.getLocation().getStartLine(), other.getLocation().getStartColumn()
        )
    } or
    TLocalVariableReal(Scope::Range scope, string name, Ruby::AstNode i) {
      scopeDefinesParameterVariable(scope, name, i)
      or
      i =
        min(Ruby::AstNode other |
          scopeAssigns(scope, name, other)
        |
          other order by other.getLocation().getStartLine(), other.getLocation().getStartColumn()
        ) and
      not scopeDefinesParameterVariable(scope, name, _) and
      not inherits(scope, name, _)
    } or
    TSelfVariable(SelfBase::Range scope) or
    TLocalVariableSynth(AstNode n, int i) { any(Synthesis s).localVariable(n, i) }

  // Db types that can be vcalls
  private class VcallToken =
    @ruby_scope_resolution or @ruby_token_constant or @ruby_token_identifier or @ruby_token_super;

  /**
   * Holds if `i` is an `identifier` node occurring in the context where it
   * should be considered a VCALL. VCALL is the term that MRI/Ripper uses
   * internally when there's an identifier without arguments or parentheses,
   * i.e. it *might* be a method call, but it might also be a variable access,
   * depending on the bindings in the current scope.
   * ```rb
   * foo # in MRI this is a VCALL, and the predicate should hold for this
   * bar() # in MRI this would be an FCALL. Tree-sitter gives us a `call` node,
   *       # and the `method` field will be an `identifier`, but this predicate
   *       # will not hold for that identifier.
   * ```
   */
  cached
  predicate vcall(VcallToken i) {
    i = any(Ruby::ArgumentList x).getChild(_)
    or
    i = any(Ruby::Array x).getChild(_)
    or
    i = any(Ruby::Assignment x).getRight()
    or
    i = any(Ruby::Begin x).getChild(_)
    or
    i = any(Ruby::BeginBlock x).getChild(_)
    or
    i = any(Ruby::Binary x).getLeft()
    or
    i = any(Ruby::Binary x).getRight()
    or
    i = any(Ruby::Block x).getChild(_)
    or
    i = any(Ruby::BlockArgument x).getChild()
    or
    i = any(Ruby::Call x).getReceiver()
    or
    i = any(Ruby::Case x).getValue()
    or
    i = any(Ruby::CaseMatch x).getValue()
    or
    i = any(Ruby::Class x).getChild(_)
    or
    i = any(Ruby::Conditional x).getCondition()
    or
    i = any(Ruby::Conditional x).getConsequence()
    or
    i = any(Ruby::Conditional x).getAlternative()
    or
    i = any(Ruby::Do x).getChild(_)
    or
    i = any(Ruby::DoBlock x).getChild(_)
    or
    i = any(Ruby::ElementReference x).getChild(_)
    or
    i = any(Ruby::ElementReference x).getObject()
    or
    i = any(Ruby::Else x).getChild(_)
    or
    i = any(Ruby::Elsif x).getCondition()
    or
    i = any(Ruby::EndBlock x).getChild(_)
    or
    i = any(Ruby::Ensure x).getChild(_)
    or
    i = any(Ruby::Exceptions x).getChild(_)
    or
    i = any(Ruby::HashSplatArgument x).getChild()
    or
    i = any(Ruby::If x).getCondition()
    or
    i = any(Ruby::IfModifier x).getCondition()
    or
    i = any(Ruby::IfModifier x).getBody()
    or
    i = any(Ruby::In x).getChild()
    or
    i = any(Ruby::Interpolation x).getChild(_)
    or
    i = any(Ruby::KeywordParameter x).getValue()
    or
    i = any(Ruby::Method x).getChild(_)
    or
    i = any(Ruby::Module x).getChild(_)
    or
    i = any(Ruby::OperatorAssignment x).getRight()
    or
    i = any(Ruby::OptionalParameter x).getValue()
    or
    i = any(Ruby::Pair x).getKey()
    or
    i = any(Ruby::Pair x).getValue()
    or
    i = any(Ruby::ParenthesizedStatements x).getChild(_)
    or
    i = any(Ruby::Pattern x).getChild()
    or
    i = any(Ruby::Program x).getChild(_)
    or
    i = any(Ruby::Range x).getBegin()
    or
    i = any(Ruby::Range x).getEnd()
    or
    i = any(Ruby::RescueModifier x).getBody()
    or
    i = any(Ruby::RescueModifier x).getHandler()
    or
    i = any(Ruby::RightAssignmentList x).getChild(_)
    or
    i = any(Ruby::ScopeResolution x).getScope()
    or
    i = any(Ruby::SingletonClass x).getValue()
    or
    i = any(Ruby::SingletonClass x).getChild(_)
    or
    i = any(Ruby::SingletonMethod x).getChild(_)
    or
    i = any(Ruby::SingletonMethod x).getObject()
    or
    i = any(Ruby::SplatArgument x).getChild()
    or
    i = any(Ruby::Superclass x).getChild()
    or
    i = any(Ruby::Then x).getChild(_)
    or
    i = any(Ruby::Unary x).getOperand()
    or
    i = any(Ruby::Unless x).getCondition()
    or
    i = any(Ruby::UnlessModifier x).getCondition()
    or
    i = any(Ruby::UnlessModifier x).getBody()
    or
    i = any(Ruby::Until x).getCondition()
    or
    i = any(Ruby::UntilModifier x).getCondition()
    or
    i = any(Ruby::UntilModifier x).getBody()
    or
    i = any(Ruby::While x).getCondition()
    or
    i = any(Ruby::WhileModifier x).getCondition()
    or
    i = any(Ruby::WhileModifier x).getBody()
    or
    i = any(Ruby::ExpressionReferencePattern x).getValue()
  }

  pragma[nomagic]
  private predicate hasScopeAndName(VariableReal variable, Scope::Range scope, string name) {
    variable.getNameImpl() = name and
    scope = variable.getDeclaringScopeImpl()
  }

  cached
  predicate access(Ruby::AstNode access, VariableReal variable) {
    exists(string name, Scope::Range scope |
      pragma[only_bind_into](name) = variableNameInScope(access, scope)
    |
      hasScopeAndName(variable, scope, name) and
      not access.getLocation().strictlyBefore(variable.getLocationImpl()) and
      // In case of overlapping parameter names, later parameters should not
      // be considered accesses to the first parameter
      if parameterAssignment(_, _, access)
      then scopeDefinesParameterVariable(_, _, access)
      else any()
      or
      exists(Scope::Range declScope |
        hasScopeAndName(variable, declScope, pragma[only_bind_into](name)) and
        inherits(scope, name, declScope)
      )
    )
  }

  private class Access extends Ruby::Token {
    Access() {
      access(this.(Ruby::Identifier), _) or
      this instanceof Ruby::GlobalVariable or
      this instanceof Ruby::InstanceVariable or
      this instanceof Ruby::ClassVariable or
      this instanceof Ruby::Self
    }
  }

  cached
  predicate explicitWriteAccess(Access access, Ruby::AstNode assignment) {
    explicitAssignmentNode(access, assignment)
  }

  cached
  predicate implicitWriteAccess(Access access) {
    implicitAssignmentNode(access)
    or
    scopeDefinesParameterVariable(_, _, access)
  }

  cached
  predicate isCapturedAccess(LocalVariableAccess access) {
    exists(Scope scope1, Scope scope2 |
      scope1 = access.getVariable().getDeclaringScope() and
      scope2 = access.getCfgScope() and
      scope1 != scope2
    |
      if access instanceof SelfVariableAccess
      then
        // ```
        // class C
        //   def self.m // not a captured access
        //   end
        // end
        // ```
        not scope2 instanceof Toplevel or
        not access = any(SingletonMethod m).getObject()
      else any()
    )
  }

  cached
  predicate instanceVariableAccess(Ruby::InstanceVariable var, InstanceVariable v) {
    exists(string name, Scope::Range scope, boolean instance |
      v = TInstanceVariable(scope, name, instance, _) and
      instanceVariableAccess(var, name, scope, instance)
    )
  }

  cached
  predicate classVariableAccess(Ruby::ClassVariable var, ClassVariable variable) {
    exists(Scope::Range scope, string name |
      variable = TClassVariable(scope, name, _) and
      classVariableAccess(var, name, scope)
    )
  }
}

import Cached

/** Holds if this scope inherits `name` from an outer scope `outer`. */
private predicate inherits(Scope::Range scope, string name, Scope::Range outer) {
  (
    scope instanceof Ruby::Block or
    scope instanceof Ruby::DoBlock or
    scope instanceof Ruby::Lambda
  ) and
  not scopeDefinesParameterVariable(scope, name, _) and
  (
    outer = scope.getOuterScope() and
    (
      scopeDefinesParameterVariable(outer, name, _)
      or
      exists(Ruby::AstNode i |
        scopeAssigns(outer, name, i) and
        i.getLocation().strictlyBefore(scope.getLocation())
      )
    )
    or
    inherits(scope.getOuterScope(), name, outer)
  )
}

abstract class VariableImpl extends TVariable {
  abstract string getNameImpl();

  final string toString() { result = this.getNameImpl() }

  abstract Location getLocationImpl();
}

class TVariableReal =
  TGlobalVariable or TClassVariable or TInstanceVariable or TLocalVariableReal or TSelfVariable;

class TLocalVariable = TLocalVariableReal or TLocalVariableSynth or TSelfVariable;

/**
 * A "real" (i.e. non-synthesized) variable. This class only exists to
 * avoid negative recursion warnings. Ideally, we would use `VariableImpl`
 * directly, but that results in incorrect negative recursion warnings.
 * Adding new root-defs for the predicates below works around this.
 */
abstract class VariableReal extends TVariableReal {
  abstract string getNameImpl();

  abstract Location getLocationImpl();

  abstract Scope::Range getDeclaringScopeImpl();

  final string toString() { result = this.getNameImpl() }
}

// Convert extensions of `VariableReal` into extensions of `VariableImpl`
private class VariableRealAdapter extends VariableImpl, TVariableReal instanceof VariableReal {
  final override string getNameImpl() { result = VariableReal.super.getNameImpl() }

  final override Location getLocationImpl() { result = VariableReal.super.getLocationImpl() }
}

class LocalVariableReal extends VariableReal, TLocalVariableReal {
  private Scope::Range scope;
  private string name;
  private Ruby::AstNode i;

  LocalVariableReal() { this = TLocalVariableReal(scope, name, i) }

  final override string getNameImpl() { result = name }

  final override Location getLocationImpl() { result = i.getLocation() }

  final override Scope::Range getDeclaringScopeImpl() { result = scope }

  final VariableAccess getDefiningAccessImpl() { toGenerated(result) = i }
}

class LocalVariableSynth extends VariableImpl, TLocalVariableSynth {
  private AstNode n;
  private int i;

  LocalVariableSynth() { this = TLocalVariableSynth(n, i) }

  final override string getNameImpl() {
    exists(int level | level = desugarLevel(n) |
      if level > 0 then result = "__synth__" + i + "__" + level else result = "__synth__" + i
    )
  }

  final override Location getLocationImpl() { result = n.getLocation() }
}

class GlobalVariableImpl extends VariableReal, TGlobalVariable {
  private string name;

  GlobalVariableImpl() { this = TGlobalVariable(name) }

  final override string getNameImpl() { result = name }

  final override Location getLocationImpl() { none() }

  final override Scope::Range getDeclaringScopeImpl() { none() }
}

class InstanceVariableImpl extends VariableReal, TInstanceVariable {
  private ModuleBase::Range scope;
  private boolean instance;
  private string name;
  private Ruby::AstNode decl;

  InstanceVariableImpl() { this = TInstanceVariable(scope, name, instance, decl) }

  final override string getNameImpl() { result = name }

  final predicate isClassInstanceVariable() { instance = false }

  final override Location getLocationImpl() { result = decl.getLocation() }

  final override Scope::Range getDeclaringScopeImpl() { result = scope }
}

class ClassVariableImpl extends VariableReal, TClassVariable {
  private ModuleBase::Range scope;
  private string name;
  private Ruby::AstNode decl;

  ClassVariableImpl() { this = TClassVariable(scope, name, decl) }

  final override string getNameImpl() { result = name }

  final override Location getLocationImpl() { result = decl.getLocation() }

  final override Scope::Range getDeclaringScopeImpl() { result = scope }
}

class SelfVariableImpl extends VariableReal, TSelfVariable {
  private SelfBase::Range scope;

  SelfVariableImpl() { this = TSelfVariable(scope) }

  final override string getNameImpl() { result = "self" }

  final override Location getLocationImpl() { result = scope.getLocation() }

  final override Scope::Range getDeclaringScopeImpl() { result = scope }
}

abstract class VariableAccessImpl extends Expr, TVariableAccess {
  abstract VariableImpl getVariableImpl();
}

module LocalVariableAccess {
  predicate range(Ruby::Identifier id, TLocalVariableReal v) {
    access(id, v) and
    (
      explicitWriteAccess(id, _) or
      implicitWriteAccess(id) or
      vcall(id) or
      id = any(Ruby::VariableReferencePattern vr).getName()
    )
  }
}

class TVariableAccessReal =
  TLocalVariableAccessReal or TGlobalVariableAccess or TInstanceVariableAccess or
      TClassVariableAccess;

abstract class LocalVariableAccessImpl extends VariableAccessImpl, TLocalVariableAccess { }

private class LocalVariableAccessReal extends LocalVariableAccessImpl, TLocalVariableAccessReal {
  private Ruby::Identifier g;
  private LocalVariable v;

  LocalVariableAccessReal() { this = TLocalVariableAccessReal(g, v) }

  final override LocalVariable getVariableImpl() { result = v }

  final override string toString() { result = g.getValue() }
}

class LocalVariableAccessSynth extends LocalVariableAccessImpl, TLocalVariableAccessSynth {
  private LocalVariable v;

  LocalVariableAccessSynth() { this = TLocalVariableAccessSynth(_, _, v) }

  final override LocalVariable getVariableImpl() { result = v }

  final override string toString() { result = v.getName() }
}

module GlobalVariableAccess {
  predicate range(Ruby::GlobalVariable n, GlobalVariableImpl v) { n.getValue() = v.getNameImpl() }
}

abstract class GlobalVariableAccessImpl extends VariableAccessImpl, TGlobalVariableAccess { }

private class GlobalVariableAccessReal extends GlobalVariableAccessImpl, TGlobalVariableAccessReal {
  private Ruby::GlobalVariable g;
  private GlobalVariable v;

  GlobalVariableAccessReal() { this = TGlobalVariableAccessReal(g, v) }

  final override GlobalVariable getVariableImpl() { result = v }

  final override string toString() { result = g.getValue() }
}

private class GlobalVariableAccessSynth extends GlobalVariableAccessImpl, TGlobalVariableAccessSynth {
  private GlobalVariable v;

  GlobalVariableAccessSynth() { this = TGlobalVariableAccessSynth(_, _, v) }

  final override GlobalVariable getVariableImpl() { result = v }

  final override string toString() { result = v.getName() }
}

module InstanceVariableAccess {
  predicate range(Ruby::InstanceVariable n, InstanceVariable v) { instanceVariableAccess(n, v) }
}

abstract class InstanceVariableAccessImpl extends VariableAccessImpl, TInstanceVariableAccess { }

private class InstanceVariableAccessReal extends InstanceVariableAccessImpl,
  TInstanceVariableAccessReal {
  private Ruby::InstanceVariable g;
  private InstanceVariable v;

  InstanceVariableAccessReal() { this = TInstanceVariableAccessReal(g, v) }

  final override InstanceVariable getVariableImpl() { result = v }

  final override string toString() { result = g.getValue() }
}

private class InstanceVariableAccessSynth extends InstanceVariableAccessImpl,
  TInstanceVariableAccessSynth {
  private InstanceVariable v;

  InstanceVariableAccessSynth() { this = TInstanceVariableAccessSynth(_, _, v) }

  final override InstanceVariable getVariableImpl() { result = v }

  final override string toString() { result = v.getName() }
}

module ClassVariableAccess {
  predicate range(Ruby::ClassVariable n, ClassVariable v) { classVariableAccess(n, v) }
}

abstract class ClassVariableAccessRealImpl extends VariableAccessImpl, TClassVariableAccess { }

private class ClassVariableAccessReal extends ClassVariableAccessRealImpl, TClassVariableAccessReal {
  private Ruby::ClassVariable g;
  private ClassVariable v;

  ClassVariableAccessReal() { this = TClassVariableAccessReal(g, v) }

  final override ClassVariable getVariableImpl() { result = v }

  final override string toString() { result = g.getValue() }
}

private class ClassVariableAccessSynth extends ClassVariableAccessRealImpl,
  TClassVariableAccessSynth {
  private ClassVariable v;

  ClassVariableAccessSynth() { this = TClassVariableAccessSynth(_, _, v) }

  final override ClassVariable getVariableImpl() { result = v }

  final override string toString() { result = v.getName() }
}

abstract class SelfVariableAccessImpl extends LocalVariableAccessImpl, TSelfVariableAccess { }

private class SelfVariableAccessReal extends SelfVariableAccessImpl, TSelfReal {
  private SelfVariable var;

  SelfVariableAccessReal() {
    exists(Ruby::Self self | this = TSelfReal(self) and var = TSelfVariable(scopeOf(self)))
  }

  final override SelfVariable getVariableImpl() { result = var }

  final override string toString() { result = var.toString() }
}

private class SelfVariableAccessSynth extends SelfVariableAccessImpl, TSelfSynth {
  private SelfVariable v;

  SelfVariableAccessSynth() { this = TSelfSynth(_, _, v) }

  final override LocalVariable getVariableImpl() { result = v }

  final override string toString() { result = v.getName() }
}
