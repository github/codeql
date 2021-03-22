private import TreeSitter
private import codeql.Locations
private import codeql_ruby.AST
private import codeql_ruby.ast.internal.AST
private import codeql_ruby.ast.internal.Parameter
private import codeql_ruby.ast.internal.Scope

/**
 * Holds if `n` is in the left-hand-side of an explicit assignment `assignment`.
 */
predicate explicitAssignmentNode(Generated::AstNode n, Generated::AstNode assignment) {
  n = assignment.(Generated::Assignment).getLeft()
  or
  n = assignment.(Generated::OperatorAssignment).getLeft()
  or
  exists(Generated::AstNode parent |
    parent = n.getParent() and
    explicitAssignmentNode(parent, assignment)
  |
    parent instanceof Generated::DestructuredLeftAssignment
    or
    parent instanceof Generated::LeftAssignmentList
    or
    parent instanceof Generated::RestAssignment
  )
}

/** Holds if `n` is inside an implicit assignment. */
predicate implicitAssignmentNode(Generated::AstNode n) {
  n = any(Generated::ExceptionVariable ev).getChild()
  or
  n = any(Generated::For for).getPattern()
  or
  implicitAssignmentNode(n.getParent())
}

/** Holds if `n` is inside a parameter. */
predicate implicitParameterAssignmentNode(Generated::AstNode n, Callable::Range c) {
  n = c.getParameter(_)
  or
  implicitParameterAssignmentNode(n.getParent().(Generated::DestructuredParameter), c)
}

private predicate instanceVariableAccess(
  Generated::InstanceVariable var, string name, Scope::Range scope, boolean instance
) {
  name = var.getValue() and
  scope = enclosingModuleOrClass(var) and
  if hasEnclosingMethod(var) then instance = true else instance = false
}

private predicate classVariableAccess(Generated::ClassVariable var, string name, Scope::Range scope) {
  name = var.getValue() and
  scope = enclosingModuleOrClass(var)
}

private predicate hasEnclosingMethod(Generated::AstNode node) {
  exists(Scope::Range s | scopeOf(node) = s and exists(s.getEnclosingMethod()))
}

private ModuleBase::Range enclosingModuleOrClass(Generated::AstNode node) {
  exists(Scope::Range s | scopeOf(node) = s and result = s.getEnclosingModule())
}

private predicate parameterAssignment(Callable::Range scope, string name, Generated::Identifier i) {
  implicitParameterAssignmentNode(i, scope) and
  name = i.getValue()
}

/** Holds if `scope` defines `name` in its parameter declaration at `i`. */
private predicate scopeDefinesParameterVariable(
  Callable::Range scope, string name, Generated::Identifier i
) {
  // In case of overlapping parameter names (e.g. `_`), only the first
  // parameter will give rise to a variable
  i =
    min(Generated::Identifier other |
      parameterAssignment(scope, name, other)
    |
      other order by other.getLocation().getStartLine(), other.getLocation().getStartColumn()
    )
  or
  exists(Parameter::Range p |
    p = scope.getParameter(_) and
    name = i.getValue()
  |
    i = p.(Generated::BlockParameter).getName() or
    i = p.(Generated::HashSplatParameter).getName() or
    i = p.(Generated::KeywordParameter).getName() or
    i = p.(Generated::OptionalParameter).getName() or
    i = p.(Generated::SplatParameter).getName()
  )
}

/** Holds if `name` is assigned in `scope` at `i`. */
private predicate scopeAssigns(Scope::Range scope, string name, Generated::Identifier i) {
  (explicitAssignmentNode(i, _) or implicitAssignmentNode(i)) and
  name = i.getValue() and
  scope = scopeOf(i)
}

/** Holds if location `one` starts strictly before location `two` */
pragma[inline]
private predicate strictlyBefore(Location one, Location two) {
  one.getStartLine() < two.getStartLine()
  or
  one.getStartLine() = two.getStartLine() and one.getStartColumn() < two.getStartColumn()
}

cached
private module Cached {
  cached
  newtype TVariable =
    TGlobalVariable(string name) { name = any(Generated::GlobalVariable var).getValue() } or
    TClassVariable(Scope::Range scope, string name, Generated::AstNode decl) {
      decl =
        min(Generated::ClassVariable other |
          classVariableAccess(other, name, scope)
        |
          other order by other.getLocation().getStartLine(), other.getLocation().getStartColumn()
        )
    } or
    TInstanceVariable(Scope::Range scope, string name, boolean instance, Generated::AstNode decl) {
      decl =
        min(Generated::InstanceVariable other |
          instanceVariableAccess(other, name, scope, instance)
        |
          other order by other.getLocation().getStartLine(), other.getLocation().getStartColumn()
        )
    } or
    TLocalVariable(Scope::Range scope, string name, Generated::Identifier i) {
      scopeDefinesParameterVariable(scope, name, i)
      or
      i =
        min(Generated::Identifier other |
          scopeAssigns(scope, name, other)
        |
          other order by other.getLocation().getStartLine(), other.getLocation().getStartColumn()
        ) and
      not scopeDefinesParameterVariable(scope, name, _) and
      not inherits(scope, name, _)
    }

  // Db types that can be vcalls
  private class VcallToken =
    @scope_resolution or @token_constant or @token_identifier or @token_super;

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
    i = any(Generated::ArgumentList x).getChild(_)
    or
    i = any(Generated::Array x).getChild(_)
    or
    i = any(Generated::Assignment x).getRight()
    or
    i = any(Generated::Begin x).getChild(_)
    or
    i = any(Generated::BeginBlock x).getChild(_)
    or
    i = any(Generated::Binary x).getLeft()
    or
    i = any(Generated::Binary x).getRight()
    or
    i = any(Generated::Block x).getChild(_)
    or
    i = any(Generated::BlockArgument x).getChild()
    or
    i = any(Generated::Call x).getReceiver()
    or
    i = any(Generated::Case x).getValue()
    or
    i = any(Generated::Class x).getChild(_)
    or
    i = any(Generated::Conditional x).getCondition()
    or
    i = any(Generated::Conditional x).getConsequence()
    or
    i = any(Generated::Conditional x).getAlternative()
    or
    i = any(Generated::Do x).getChild(_)
    or
    i = any(Generated::DoBlock x).getChild(_)
    or
    i = any(Generated::ElementReference x).getChild(_)
    or
    i = any(Generated::ElementReference x).getObject()
    or
    i = any(Generated::Else x).getChild(_)
    or
    i = any(Generated::Elsif x).getCondition()
    or
    i = any(Generated::EndBlock x).getChild(_)
    or
    i = any(Generated::Ensure x).getChild(_)
    or
    i = any(Generated::Exceptions x).getChild(_)
    or
    i = any(Generated::HashSplatArgument x).getChild()
    or
    i = any(Generated::If x).getCondition()
    or
    i = any(Generated::IfModifier x).getCondition()
    or
    i = any(Generated::IfModifier x).getBody()
    or
    i = any(Generated::In x).getChild()
    or
    i = any(Generated::Interpolation x).getChild(_)
    or
    i = any(Generated::KeywordParameter x).getValue()
    or
    i = any(Generated::Method x).getChild(_)
    or
    i = any(Generated::Module x).getChild(_)
    or
    i = any(Generated::OperatorAssignment x).getRight()
    or
    i = any(Generated::OptionalParameter x).getValue()
    or
    i = any(Generated::Pair x).getKey()
    or
    i = any(Generated::Pair x).getValue()
    or
    i = any(Generated::ParenthesizedStatements x).getChild(_)
    or
    i = any(Generated::Pattern x).getChild()
    or
    i = any(Generated::Program x).getChild(_)
    or
    i = any(Generated::Range x).getBegin()
    or
    i = any(Generated::Range x).getEnd()
    or
    i = any(Generated::RescueModifier x).getBody()
    or
    i = any(Generated::RescueModifier x).getHandler()
    or
    i = any(Generated::RightAssignmentList x).getChild(_)
    or
    i = any(Generated::ScopeResolution x).getScope()
    or
    i = any(Generated::SingletonClass x).getValue()
    or
    i = any(Generated::SingletonClass x).getChild(_)
    or
    i = any(Generated::SingletonMethod x).getChild(_)
    or
    i = any(Generated::SingletonMethod x).getObject()
    or
    i = any(Generated::SplatArgument x).getChild()
    or
    i = any(Generated::Superclass x).getChild()
    or
    i = any(Generated::Then x).getChild(_)
    or
    i = any(Generated::Unary x).getOperand()
    or
    i = any(Generated::Unless x).getCondition()
    or
    i = any(Generated::UnlessModifier x).getCondition()
    or
    i = any(Generated::UnlessModifier x).getBody()
    or
    i = any(Generated::Until x).getCondition()
    or
    i = any(Generated::UntilModifier x).getCondition()
    or
    i = any(Generated::UntilModifier x).getBody()
    or
    i = any(Generated::While x).getCondition()
    or
    i = any(Generated::WhileModifier x).getCondition()
    or
    i = any(Generated::WhileModifier x).getBody()
  }

  cached
  predicate access(Generated::Identifier access, Variable::Range variable) {
    exists(string name |
      variable.getName() = name and
      name = access.getValue()
    |
      variable.getDeclaringScope() = scopeOf(access) and
      not strictlyBefore(access.getLocation(), variable.getLocation()) and
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

  private class Access extends Generated::Token {
    Access() {
      access(this, _) or
      this instanceof Generated::GlobalVariable or
      this instanceof Generated::InstanceVariable or
      this instanceof Generated::ClassVariable
    }
  }

  cached
  predicate explicitWriteAccess(Access access, Generated::AstNode assignment) {
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
  predicate instanceVariableAccess(Generated::InstanceVariable var, InstanceVariable v) {
    exists(string name, Scope::Range scope, boolean instance |
      v = TInstanceVariable(scope, name, instance, _) and
      instanceVariableAccess(var, name, scope, instance)
    )
  }

  cached
  predicate classVariableAccess(Generated::ClassVariable var, ClassVariable variable) {
    exists(Scope::Range scope, string name |
      variable = TClassVariable(scope, name, _) and
      classVariableAccess(var, name, scope)
    )
  }
}

import Cached

/** Holds if this scope inherits `name` from an outer scope `outer`. */
private predicate inherits(Scope::Range scope, string name, Scope::Range outer) {
  (scope instanceof Generated::Block or scope instanceof Generated::DoBlock) and
  not scopeDefinesParameterVariable(scope, name, _) and
  (
    outer = scope.getOuterScope() and
    (
      scopeDefinesParameterVariable(outer, name, _)
      or
      exists(Generated::Identifier i |
        scopeAssigns(outer, name, i) and
        strictlyBefore(i.getLocation(), scope.getLocation())
      )
    )
    or
    inherits(scope.getOuterScope(), name, outer)
  )
}

module Variable {
  class Range extends TVariable {
    abstract string getName();

    string toString() { result = this.getName() }

    abstract Location getLocation();

    abstract Scope::Range getDeclaringScope();
  }
}

module LocalVariable {
  class Range extends Variable::Range, TLocalVariable {
    private Scope::Range scope;
    private string name;
    private Generated::Identifier i;

    Range() { this = TLocalVariable(scope, name, i) }

    final override string getName() { result = name }

    final override Location getLocation() { result = i.getLocation() }

    final override Scope::Range getDeclaringScope() { result = scope }

    final VariableAccess getDefiningAccess() { toGenerated(result) = i }
  }
}

module GlobalVariable {
  class Range extends Variable::Range, TGlobalVariable {
    private string name;

    Range() { this = TGlobalVariable(name) }

    final override string getName() { result = name }

    final override Location getLocation() { none() }

    final override Scope::Range getDeclaringScope() { none() }
  }
}

module InstanceVariable {
  class Range extends Variable::Range, TInstanceVariable {
    private ModuleBase::Range scope;
    private boolean instance;
    private string name;
    private Generated::AstNode decl;

    Range() { this = TInstanceVariable(scope, name, instance, decl) }

    final override string getName() { result = name }

    final predicate isClassInstanceVariable() { instance = false }

    final override Location getLocation() { result = decl.getLocation() }

    final override Scope::Range getDeclaringScope() { result = scope }
  }
}

module ClassVariable {
  class Range extends Variable::Range, TClassVariable {
    private ModuleBase::Range scope;
    private string name;
    private Generated::AstNode decl;

    Range() { this = TClassVariable(scope, name, decl) }

    final override string getName() { result = name }

    final override Location getLocation() { result = decl.getLocation() }

    final override Scope::Range getDeclaringScope() { result = scope }
  }
}

module LocalVariableAccess {
  predicate range(Generated::Identifier id, LocalVariable v) {
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

module GlobalVariableAccess {
  predicate range(Generated::GlobalVariable n, GlobalVariable v) { n.getValue() = v.getName() }
}

module InstanceVariableAccess {
  predicate range(Generated::InstanceVariable n, InstanceVariable v) {
    instanceVariableAccess(n, v)
  }
}

module ClassVariableAccess {
  predicate range(Generated::ClassVariable n, ClassVariable v) { classVariableAccess(n, v) }
}
