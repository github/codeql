private import TreeSitter
private import codeql.Locations
private import codeql_ruby.AST
private import codeql_ruby.ast.internal.Expr
private import codeql_ruby.ast.internal.Pattern

private Generated::AstNode parent(Generated::AstNode n) {
  result = n.getParent() and
  not n = any(VariableScope s).getScopeElement()
}

private predicate instanceVariableAccess(
  Generated::InstanceVariable var, string name, VariableScope scope, boolean instance
) {
  name = var.getValue() and
  scope = enclosingModuleOrClass(var) and
  if exists(enclosingMethod(var)) then instance = true else instance = false
}

private predicate classVariableAccess(Generated::ClassVariable var, string name, VariableScope scope) {
  name = var.getValue() and
  scope = enclosingModuleOrClass(var)
}

private Callable enclosingMethod(Generated::AstNode node) {
  parentCallableScope*(enclosingScope(node)) = TCallableScope(result) and
  (
    result instanceof Method or
    result instanceof SingletonMethod
  )
}

private TCallableScope parentCallableScope(TCallableScope scope) {
  exists(Callable c |
    scope = TCallableScope(c) and
    not c instanceof Method and
    not c instanceof SingletonMethod
  |
    result = outerScope(scope)
  )
}

private VariableScope parentScope(VariableScope scope) {
  not scope instanceof ModuleOrClassScope and
  result = outerScope(scope)
}

private ModuleOrClassScope enclosingModuleOrClass(Generated::AstNode node) {
  result = parentScope*(enclosingScope(node))
}

private predicate parameterAssignment(
  CallableScope::Range scope, string name, Generated::Identifier i
) {
  implicitParameterAssignmentNode(i, scope.getScopeElement()) and
  name = i.getValue()
}

/** Holds if `scope` defines `name` in its parameter declaration at `i`. */
private predicate scopeDefinesParameterVariable(
  CallableScope::Range scope, string name, Generated::Identifier i
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
  exists(Parameter p |
    p = scope.getScopeElement().getAParameter() and
    name = p.(NamedParameter).getName()
  |
    i = p.(Generated::BlockParameter).getName() or
    i = p.(Generated::HashSplatParameter).getName() or
    i = p.(Generated::KeywordParameter).getName() or
    i = p.(Generated::OptionalParameter).getName() or
    i = p.(Generated::SplatParameter).getName()
  )
}

/** Holds if `name` is assigned in `scope` at `i`. */
private predicate scopeAssigns(VariableScope scope, string name, Generated::Identifier i) {
  (explicitAssignmentNode(i, _) or implicitAssignmentNode(i)) and
  name = i.getValue() and
  scope = enclosingScope(i)
}

/** Holds if location `one` starts strictly before location `two` */
pragma[inline]
private predicate strictlyBefore(Location one, Location two) {
  one.getStartLine() < two.getStartLine()
  or
  one.getStartLine() = two.getStartLine() and one.getStartColumn() < two.getStartColumn()
}

private VariableScope outerScope(VariableScope scope) {
  result = enclosingScope(scope.getScopeElement())
}

/** A scope that may capture outer local variables. */
private class CapturingScope extends VariableScope {
  CapturingScope() {
    exists(Callable c | c = this.getScopeElement() |
      c instanceof Block
      or
      c instanceof DoBlock
      or
      c instanceof Lambda // TODO: Check if this is actually the case
    )
  }

  /** Gets the scope in which this scope is nested, if any. */
  VariableScope getOuterScope() { result = outerScope(this) }

  /** Holds if this scope inherits `name` from an outer scope `outer`. */
  predicate inherits(string name, VariableScope outer) {
    not scopeDefinesParameterVariable(this, name, _) and
    (
      outer = this.getOuterScope() and
      (
        scopeDefinesParameterVariable(outer, name, _)
        or
        exists(Generated::Identifier i |
          scopeAssigns(outer, name, i) and
          strictlyBefore(i.getLocation(), this.getLocation())
        )
      )
      or
      this.getOuterScope().(CapturingScope).inherits(name, outer)
    )
  }
}

cached
private module Cached {
  /** Gets the enclosing scope for `node`. */
  cached
  VariableScope enclosingScope(Generated::AstNode node) {
    result.getScopeElement() = parent*(node.getParent())
  }

  cached
  newtype TScope =
    TGlobalScope() or
    TTopLevelScope(Generated::Program node) or
    TModuleScope(Generated::Module node) or
    TClassScope(AstNode cls) {
      cls instanceof Generated::Class or cls instanceof Generated::SingletonClass
    } or
    TCallableScope(Callable c)

  cached
  newtype TVariable =
    TGlobalVariable(string name) { name = any(Generated::GlobalVariable var).getValue() } or
    TClassVariable(VariableScope scope, string name, Generated::AstNode decl) {
      decl =
        min(Generated::ClassVariable other |
          classVariableAccess(other, name, scope)
        |
          other order by other.getLocation().getStartLine(), other.getLocation().getStartColumn()
        )
    } or
    TInstanceVariable(VariableScope scope, string name, boolean instance, Generated::AstNode decl) {
      decl =
        min(Generated::InstanceVariable other |
          instanceVariableAccess(other, name, scope, instance)
        |
          other order by other.getLocation().getStartLine(), other.getLocation().getStartColumn()
        )
    } or
    TLocalVariable(VariableScope scope, string name, Generated::Identifier i) {
      scopeDefinesParameterVariable(scope, name, i)
      or
      i =
        min(Generated::Identifier other |
          scopeAssigns(scope, name, other)
        |
          other order by other.getLocation().getStartLine(), other.getLocation().getStartColumn()
        ) and
      not scopeDefinesParameterVariable(scope, name, _) and
      not scope.(CapturingScope).inherits(name, _)
    }

  // Token types that can be vcalls
  private class VcallToken = @token_identifier or @token_super;

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
    i = any(Generated::Interpolation x).getChild()
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
    i = any(Generated::Range x).getChild(_)
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
  predicate access(Generated::Identifier access, Variable variable) {
    exists(string name | name = access.getValue() |
      variable = enclosingScope(access).getVariable(name) and
      not strictlyBefore(access.getLocation(), variable.getLocation()) and
      // In case of overlapping parameter names, later parameters should not
      // be considered accesses to the first parameter
      if parameterAssignment(_, _, access)
      then scopeDefinesParameterVariable(_, _, access)
      else any()
      or
      exists(VariableScope declScope |
        variable = declScope.getVariable(name) and
        enclosingScope(access).(CapturingScope).inherits(name, declScope)
      )
    )
  }

  private class Access extends Generated::Token {
    Access() { access(this, _) or this instanceof Generated::GlobalVariable }
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
  predicate isCapturedAccess(LocalVariableAccess::Range access) {
    access.getVariable().getDeclaringScope() != enclosingScope(access)
  }
}

import Cached

module VariableScope {
  abstract class Range extends TScope {
    abstract string toString();

    abstract AstNode getScopeElement();
  }
}

module GlobalScope {
  class Range extends VariableScope::Range, TGlobalScope {
    override string toString() { result = "global scope" }

    override AstNode getScopeElement() { none() }
  }
}

module TopLevelScope {
  class Range extends VariableScope::Range, TTopLevelScope {
    override string toString() { result = "top-level scope" }

    override AstNode getScopeElement() { TTopLevelScope(result) = this }
  }
}

module ModuleScope {
  class Range extends VariableScope::Range, TModuleScope {
    override string toString() { result = "module scope" }

    override AstNode getScopeElement() { TModuleScope(result) = this }
  }
}

module ClassScope {
  class Range extends VariableScope::Range, TClassScope {
    override string toString() { result = "class scope" }

    override AstNode getScopeElement() { TClassScope(result) = this }
  }
}

module CallableScope {
  class Range extends VariableScope::Range, TCallableScope {
    private Callable c;

    Range() { this = TCallableScope(c) }

    override string toString() {
      (c instanceof Method or c instanceof SingletonMethod) and
      result = "method scope"
      or
      c instanceof Lambda and
      result = "lambda scope"
      or
      c instanceof Block and
      result = "block scope"
    }

    override Callable getScopeElement() { TCallableScope(result) = this }
  }
}

module Variable {
  class Range extends TVariable {
    abstract string getName();

    string toString() { result = this.getName() }

    abstract Location getLocation();

    abstract VariableScope getDeclaringScope();
  }
}

module LocalVariable {
  class Range extends Variable::Range, TLocalVariable {
    private VariableScope scope;
    private string name;
    private Generated::Identifier i;

    Range() { this = TLocalVariable(scope, name, i) }

    final override string getName() { result = name }

    final override Location getLocation() { result = i.getLocation() }

    final override VariableScope getDeclaringScope() { result = scope }

    final VariableAccess getDefiningAccess() { result = i }
  }
}

module GlobalVariable {
  class Range extends Variable::Range, TGlobalVariable {
    private string name;

    Range() { this = TGlobalVariable(name) }

    final override string getName() { result = name }

    final override Location getLocation() { none() }

    final override VariableScope getDeclaringScope() { result = TGlobalScope() }
  }
}

private class ModuleOrClassScope = TClassScope or TModuleScope or TTopLevelScope;

module InstanceVariable {
  class Range extends Variable::Range, TInstanceVariable {
    private ModuleOrClassScope scope;
    private boolean instance;
    private string name;
    private Generated::AstNode decl;

    Range() { this = TInstanceVariable(scope, name, instance, decl) }

    final override string getName() { result = name }

    final predicate isClassInstanceVariable() { instance = false }

    final override Location getLocation() { result = decl.getLocation() }

    final override VariableScope getDeclaringScope() { result = scope }
  }
}

module ClassVariable {
  class Range extends Variable::Range, TClassVariable {
    private ModuleOrClassScope scope;
    private string name;
    private Generated::AstNode decl;

    Range() { this = TClassVariable(scope, name, decl) }

    final override string getName() { result = name }

    final override Location getLocation() { result = decl.getLocation() }

    final override VariableScope getDeclaringScope() { result = scope }
  }
}

module VariableAccess {
  abstract class Range extends Expr::Range {
    abstract Variable getVariable();
  }
}

module LocalVariableAccess {
  class Range extends VariableAccess::Range, @token_identifier {
    override Generated::Identifier generated;
    LocalVariable variable;

    Range() {
      access(this, variable) and
      (
        explicitWriteAccess(this, _)
        or
        implicitWriteAccess(this)
        or
        vcall(this)
      )
    }

    final override LocalVariable getVariable() { result = variable }
  }
}

module GlobalVariableAccess {
  class Range extends VariableAccess::Range, @token_global_variable {
    GlobalVariable variable;

    Range() { this.(Generated::GlobalVariable).getValue() = variable.getName() }

    final override GlobalVariable getVariable() { result = variable }
  }
}

module InstanceVariableAccess {
  class Range extends VariableAccess::Range, @token_instance_variable {
    InstanceVariable variable;

    Range() {
      exists(boolean instance, VariableScope scope, string name |
        variable = TInstanceVariable(scope, name, instance, _) and
        instanceVariableAccess(this, name, scope, instance)
      )
    }

    final override InstanceVariable getVariable() { result = variable }
  }
}

module ClassVariableAccess {
  class Range extends VariableAccess::Range, @token_class_variable {
    ClassVariable variable;

    Range() {
      exists(VariableScope scope, string name |
        variable = TClassVariable(scope, name, _) and
        classVariableAccess(this, name, scope)
      )
    }

    final override ClassVariable getVariable() { result = variable }
  }
}
