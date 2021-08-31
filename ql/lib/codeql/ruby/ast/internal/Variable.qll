private import TreeSitter
private import codeql.Locations
private import codeql.ruby.AST
private import codeql.ruby.ast.internal.AST
private import codeql.ruby.ast.internal.Parameter
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

/** Holds if `name` is assigned in `scope` at `i`. */
private predicate scopeAssigns(Scope::Range scope, string name, Ruby::Identifier i) {
  (explicitAssignmentNode(i, _) or implicitAssignmentNode(i)) and
  name = i.getValue() and
  scope = scopeOf(i)
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
    TLocalVariableReal(Scope::Range scope, string name, Ruby::Identifier i) {
      scopeDefinesParameterVariable(scope, name, i)
      or
      i =
        min(Ruby::Identifier other |
          scopeAssigns(scope, name, other)
        |
          other order by other.getLocation().getStartLine(), other.getLocation().getStartColumn()
        ) and
      not scopeDefinesParameterVariable(scope, name, _) and
      not inherits(scope, name, _)
    } or
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
  }

  cached
  predicate access(Ruby::Identifier access, VariableReal::Range variable) {
    exists(string name |
      variable.getName() = name and
      name = access.getValue()
    |
      variable.getDeclaringScope() = scopeOf(access) and
      not access.getLocation().strictlyBefore(variable.getLocation()) and
      // In case of overlapping parameter names, later parameters should not
      // be considered accesses to the first parameter
      if parameterAssignment(_, _, access)
      then scopeDefinesParameterVariable(_, _, access)
      else any()
      or
      exists(Scope::Range declScope |
        variable.getDeclaringScope() = declScope and
        inherits(scopeOf(access), name, declScope)
      )
    )
  }

  private class Access extends Ruby::Token {
    Access() {
      access(this, _) or
      this instanceof Ruby::GlobalVariable or
      this instanceof Ruby::InstanceVariable or
      this instanceof Ruby::ClassVariable
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
    toGenerated(access.getVariable().getDeclaringScope()) != scopeOf(toGenerated(access))
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
  (scope instanceof Ruby::Block or scope instanceof Ruby::DoBlock) and
  not scopeDefinesParameterVariable(scope, name, _) and
  (
    outer = scope.getOuterScope() and
    (
      scopeDefinesParameterVariable(outer, name, _)
      or
      exists(Ruby::Identifier i |
        scopeAssigns(outer, name, i) and
        i.getLocation().strictlyBefore(scope.getLocation())
      )
    )
    or
    inherits(scope.getOuterScope(), name, outer)
  )
}

class TVariableReal = TGlobalVariable or TClassVariable or TInstanceVariable or TLocalVariableReal;

module VariableReal {
  class Range extends TVariableReal {
    abstract string getName();

    string toString() { result = this.getName() }

    abstract Location getLocation();

    abstract Scope::Range getDeclaringScope();
  }
}

class TLocalVariable = TLocalVariableReal or TLocalVariableSynth;

module LocalVariable {
  class Range extends VariableReal::Range, TLocalVariableReal {
    private Scope::Range scope;
    private string name;
    private Ruby::Identifier i;

    Range() { this = TLocalVariableReal(scope, name, i) }

    final override string getName() { result = name }

    final override Location getLocation() { result = i.getLocation() }

    final override Scope::Range getDeclaringScope() { result = scope }

    final VariableAccess getDefiningAccess() { toGenerated(result) = i }
  }
}

class VariableReal extends Variable, TVariableReal {
  VariableReal::Range range;

  VariableReal() { range = this }

  final override string getName() { result = range.getName() }

  final override Location getLocation() { result = range.getLocation() }

  final override Scope getDeclaringScope() { toGenerated(result) = range.getDeclaringScope() }
}

class LocalVariableReal extends VariableReal, LocalVariable, TLocalVariableReal {
  override LocalVariable::Range range;

  final override LocalVariableAccessReal getAnAccess() { result.getVariable() = this }

  final override VariableAccess getDefiningAccess() { result = range.getDefiningAccess() }
}

class LocalVariableSynth extends LocalVariable, TLocalVariableSynth {
  private AstNode n;
  private int i;

  LocalVariableSynth() { this = TLocalVariableSynth(n, i) }

  final override string getName() {
    exists(int level | level = desugarLevel(n) |
      if level > 0 then result = "__synth__" + i + "__" + level else result = "__synth__" + i
    )
  }

  final override Location getLocation() { result = n.getLocation() }

  final override Scope getDeclaringScope() { none() } // not relevant for synthesized variables
}

module GlobalVariable {
  class Range extends VariableReal::Range, TGlobalVariable {
    private string name;

    Range() { this = TGlobalVariable(name) }

    final override string getName() { result = name }

    final override Location getLocation() { none() }

    final override Scope::Range getDeclaringScope() { none() }
  }
}

module InstanceVariable {
  class Range extends VariableReal::Range, TInstanceVariable {
    private ModuleBase::Range scope;
    private boolean instance;
    private string name;
    private Ruby::AstNode decl;

    Range() { this = TInstanceVariable(scope, name, instance, decl) }

    final override string getName() { result = name }

    final predicate isClassInstanceVariable() { instance = false }

    final override Location getLocation() { result = decl.getLocation() }

    final override Scope::Range getDeclaringScope() { result = scope }
  }
}

module ClassVariable {
  class Range extends VariableReal::Range, TClassVariable {
    private ModuleBase::Range scope;
    private string name;
    private Ruby::AstNode decl;

    Range() { this = TClassVariable(scope, name, decl) }

    final override string getName() { result = name }

    final override Location getLocation() { result = decl.getLocation() }

    final override Scope::Range getDeclaringScope() { result = scope }
  }
}

abstract class VariableAccessImpl extends VariableAccess {
  abstract Variable getVariableImpl();
}

module LocalVariableAccess {
  predicate range(Ruby::Identifier id, LocalVariable v) {
    access(id, v) and
    (
      explicitWriteAccess(id, _)
      or
      implicitWriteAccess(id)
      or
      vcall(id)
    )
  }
}

class TVariableAccessReal =
  TLocalVariableAccessReal or TGlobalVariableAccess or TInstanceVariableAccess or
      TClassVariableAccess;

private class LocalVariableAccessReal extends VariableAccessImpl, LocalVariableAccess,
  TLocalVariableAccessReal {
  private Ruby::Identifier g;
  private LocalVariable v;

  LocalVariableAccessReal() { this = TLocalVariableAccessReal(g, v) }

  final override LocalVariable getVariableImpl() { result = v }

  final override string toString() { result = g.getValue() }
}

private class LocalVariableAccessSynth extends VariableAccessImpl, LocalVariableAccess,
  TLocalVariableAccessSynth {
  private LocalVariable v;

  LocalVariableAccessSynth() { this = TLocalVariableAccessSynth(_, _, v) }

  final override LocalVariable getVariableImpl() { result = v }

  final override string toString() { result = v.getName() }
}

module GlobalVariableAccess {
  predicate range(Ruby::GlobalVariable n, GlobalVariable v) { n.getValue() = v.getName() }
}

private class GlobalVariableAccessReal extends GlobalVariableAccess, VariableAccessImpl,
  TGlobalVariableAccessReal {
  private Ruby::GlobalVariable g;
  private GlobalVariable v;

  GlobalVariableAccessReal() { this = TGlobalVariableAccessReal(g, v) }

  final override GlobalVariable getVariableImpl() { result = v }

  final override string toString() { result = g.getValue() }
}

private class GlobalVariableAccessSynth extends GlobalVariableAccess, VariableAccessImpl,
  TGlobalVariableAccessSynth {
  private GlobalVariable v;

  GlobalVariableAccessSynth() { this = TGlobalVariableAccessSynth(_, _, v) }

  final override GlobalVariable getVariableImpl() { result = v }

  final override string toString() { result = v.getName() }
}

module InstanceVariableAccess {
  predicate range(Ruby::InstanceVariable n, InstanceVariable v) { instanceVariableAccess(n, v) }
}

private class InstanceVariableAccessReal extends InstanceVariableAccess, VariableAccessImpl,
  TInstanceVariableAccessReal {
  private Ruby::InstanceVariable g;
  private InstanceVariable v;

  InstanceVariableAccessReal() { this = TInstanceVariableAccessReal(g, v) }

  final override InstanceVariable getVariableImpl() { result = v }

  final override string toString() { result = g.getValue() }
}

private class InstanceVariableAccessSynth extends InstanceVariableAccess, VariableAccessImpl,
  TInstanceVariableAccessSynth {
  private InstanceVariable v;

  InstanceVariableAccessSynth() { this = TInstanceVariableAccessSynth(_, _, v) }

  final override InstanceVariable getVariableImpl() { result = v }

  final override string toString() { result = v.getName() }
}

module ClassVariableAccess {
  predicate range(Ruby::ClassVariable n, ClassVariable v) { classVariableAccess(n, v) }
}

private class ClassVariableAccessReal extends ClassVariableAccess, VariableAccessImpl,
  TClassVariableAccessReal {
  private Ruby::ClassVariable g;
  private ClassVariable v;

  ClassVariableAccessReal() { this = TClassVariableAccessReal(g, v) }

  final override ClassVariable getVariableImpl() { result = v }

  final override string toString() { result = g.getValue() }
}

private class ClassVariableAccessSynth extends ClassVariableAccess, VariableAccessImpl,
  TClassVariableAccessSynth {
  private ClassVariable v;

  ClassVariableAccessSynth() { this = TClassVariableAccessSynth(_, _, v) }

  final override ClassVariable getVariableImpl() { result = v }

  final override string toString() { result = v.getName() }
}
