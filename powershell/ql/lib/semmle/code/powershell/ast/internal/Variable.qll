private import TAst
private import AstImport

module Private {
  class TVariable = TVariableReal or TVariableSynth;

  class VariableImpl extends Ast, TVariable {
    abstract string getNameImpl();

    final override string toString() { result = this.getNameImpl() }

    abstract Location getLocationImpl();

    abstract Scope::Range getDeclaringScopeImpl();
  }

  class VariableReal extends VariableImpl, TVariableReal {
    Scope::Range scope;
    string name;
    Raw::Ast n;

    VariableReal() { this = TVariableReal(scope, name, n) }

    override string getNameImpl() { result = name }

    override Location getLocationImpl() { result = n.getLocation() }

    final override Scope::Range getDeclaringScopeImpl() { result = scope }

    predicate isParameter(Raw::Parameter p) { n = p }
  }

  class VariableSynth extends VariableImpl, TVariableSynth {
    Raw::Ast scope;
    ChildIndex i;

    VariableSynth() { this = TVariableSynth(scope, i) }

    override string getNameImpl() { any(Synthesis s).variableSynthName(this, result) }

    override Location getLocationImpl() { result = scope.getLocation() }

    override Scope::Range getDeclaringScopeImpl() { result = scope }
  }

  class ParameterImpl extends VariableSynth {
    ParameterImpl() {
      i instanceof FunParam or
      i instanceof PipelineParamVar or
      i instanceof ThisVar
    }
  }

  class ThisParameterImpl extends VariableSynth {
    override ThisVar i;
  }

  class PipelineVariableImpl extends ParameterImpl {
    override PipelineParamVar i;

    ScriptBlock getScriptBlock() { this = TVariableSynth(getRawAst(result), _) }
  }

  class PipelineByPropertyNameVariableImpl extends ParameterImpl {
    PipelineByPropertyNameVariableImpl() {
      getRawAst(this) instanceof Raw::PipelineByPropertyNameParameter
    }

    ScriptBlock getScriptBlock() { this = TVariableSynth(getRawAst(result), _) }
  }

  class PipelineIteratorVariableImpl extends VariableSynth {
    override PipelineIteratorVar i;

    ProcessBlock getProcessBlock() { this = TVariableSynth(getRawAst(result), _) }
  }

  class PipelineByPropertyNameIteratorVariableImpl extends VariableSynth {
    override PipelineByPropertyNameIteratorVar i;

    ProcessBlock getProcessBlock() { this = TVariableSynth(getRawAst(result), _) }

    /**
     * Note: No result if this is not a pipeline-by-property-name.
     */
    string getPropertyName() {
      exists(Raw::PipelineByPropertyNameParameter p |
        i = PipelineByPropertyNameIteratorVar(p) and
        result = p.getName()
      )
    }

    PipelineByPropertyNameParameter getParameter() {
      exists(Raw::PipelineByPropertyNameParameter p |
        i = PipelineByPropertyNameIteratorVar(p) and
        p.getScriptBlock() = getRawAst(result.getEnclosingFunction().getBody()) and
        p.getName() = result.getName()
      )
    }
  }

  abstract class VarAccessImpl extends Expr, TVarAccess {
    abstract VariableImpl getVariableImpl();
  }

  class VarAccessReal extends VarAccessImpl, TVarAccessReal {
    Raw::VarAccess va;

    VarAccessReal() { this = TVarAccessReal(va) }

    final override Variable getVariableImpl() { access(va, result) }

    final override string toString() { result = va.getUserPath() }
  }

  class VarAccessSynth extends VarAccessImpl, TVarAccessSynth {
    Raw::Ast parent;
    ChildIndex i;

    VarAccessSynth() { this = TVarAccessSynth(parent, i) }

    final override Variable getVariableImpl() { any(Synthesis s).getAnAccess(this, result) }

    final override string toString() { result = this.getVariableImpl().getName() }

    final override Location getLocation() { result = parent.getLocation() }
  }

  predicate explicitAssignment(Raw::Ast dest, Raw::Ast assignment) {
    assignment.(Raw::AssignStmt).getLeftHandSide() = dest
    or
    any(Synthesis s).explicitAssignment(dest, _, assignment)
  }

  predicate implicitAssignment(Raw::Ast n) { any(Synthesis s).implicitAssignment(n, _) }
}

private import Private

module Public {
  class Variable extends Ast instanceof VariableImpl {
    final string getName() { result = super.getNameImpl() }

    final override string toString() { result = this.getName() }

    final override Location getLocation() { result = super.getLocationImpl() }

    Scope getDeclaringScope() { getRawAst(result) = super.getDeclaringScopeImpl() }

    VarAccess getAnAccess() { result.getVariable() = this }
  }

  class VarAccess extends Expr instanceof VarAccessImpl {
    Variable getVariable() { result = super.getVariableImpl() }

    predicate isExplicitWrite(Ast assignment) {
      explicitAssignment(getRawAst(this), getRawAst(assignment))
    }

    predicate isImplicitWrite() { implicitAssignment(getRawAst(this)) }
  }

  class VarWriteAccess extends VarAccess {
    VarWriteAccess() { this.isExplicitWrite(_) or this.isImplicitWrite() }
  }

  class VarReadAccess extends VarAccess {
    VarReadAccess() { not this instanceof VarWriteAccess }
  }

  class PipelineByPropertyNameIteratorVariable extends Variable instanceof PipelineByPropertyNameIteratorVariableImpl
  {
    ProcessBlock getProcessBlock() { result = super.getProcessBlock() }

    string getPropertyName() { result = super.getPropertyName() }

    PipelineByPropertyNameParameter getParameter() { result = super.getParameter() }
  }

  class PipelineVariable extends Variable instanceof PipelineVariableImpl {
    ScriptBlock getScriptBlock() { result = super.getScriptBlock() }
  }

  class PipelineByPropertyNameVariable extends Variable instanceof PipelineByPropertyNameVariableImpl
  {
    ScriptBlock getScriptBlock() { result = super.getScriptBlock() }
  }

  class PipelineIteratorVariable extends Variable instanceof PipelineIteratorVariableImpl {
    ProcessBlock getProcessBlock() { result = super.getProcessBlock() }
  }
}

import Public
