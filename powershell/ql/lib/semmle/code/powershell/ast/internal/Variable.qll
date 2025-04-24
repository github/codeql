private import TAst
private import AstImport

module Private {
  class TVariable = TVariableReal or TVariableSynth;

  class VariableImpl extends Ast, TVariable {
    abstract string getLowerCaseNameImpl();

    final override string toString() { result = this.getLowerCaseNameImpl() }

    abstract Location getLocationImpl();

    abstract Scope::Range getDeclaringScopeImpl();
  }

  class VariableReal extends VariableImpl, TVariableReal {
    Scope::Range scope;
    string name;
    Raw::Ast n;

    VariableReal() { this = TVariableReal(scope, name, n) }

    override string getLowerCaseNameImpl() { result = name }

    override Location getLocationImpl() { result = n.getLocation() }

    final override Scope::Range getDeclaringScopeImpl() { result = scope }

    predicate isParameter(Raw::Parameter p) { n = p }
  }

  class VariableSynth extends VariableImpl, TVariableSynth {
    Raw::Ast scope;
    ChildIndex i;

    VariableSynth() { this = TVariableSynth(scope, i) }

    override string getLowerCaseNameImpl() { any(Synthesis s).variableSynthName(this, result) }

    override Location getLocationImpl() { result = any(Synthesis s).getLocation(this) }

    override Scope::Range getDeclaringScopeImpl() { result = scope }
  }

  class ParameterImpl extends VariableSynth {
    ParameterImpl() {
      i instanceof FunParam or
      i instanceof ThisVar
    }
  }

  class ThisParameterImpl extends VariableSynth {
    override ThisVar i;
  }

  class PipelineParameterImpl extends ParameterImpl {
    override FunParam i;

    PipelineParameterImpl() {
      exists(int index |
        i = FunParam(index) and
        any(Synthesis s).pipelineParameterHasIndex(super.getDeclaringScopeImpl(), index)
      )
    }

    ScriptBlock getScriptBlock() { this = TVariableSynth(getRawAst(result), _) }
  }

  class PipelineByPropertyNameParameterImpl extends ParameterImpl {
    PipelineByPropertyNameParameterImpl() {
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
        result = p.getLowerCaseName()
      )
    }

    PipelineByPropertyNameParameter getParameter() {
      exists(Raw::PipelineByPropertyNameParameter p |
        i = PipelineByPropertyNameIteratorVar(p) and
        p.getScriptBlock() = getRawAst(result.getEnclosingFunction().getBody()) and
        p.getLowerCaseName() = result.getLowerCaseName()
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

    final override string toString() { result = this.getVariableImpl().getLowerCaseName() }

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
    final string getLowerCaseName() { result = super.getLowerCaseNameImpl() }

    final override string toString() { result = this.getLowerCaseName() }

    bindingset[name]
    pragma[inline_late]
    final predicate matchesName(string name) { this.getLowerCaseName() = name.toLowerCase() }

    bindingset[result]
    pragma[inline_late]
    final string getAName() { result.toLowerCase() = this.getLowerCaseName() }

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
}

import Public
