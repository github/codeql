import powershell
import semmle.code.powershell.controlflow.BasicBlocks

abstract private class AbstractFunction extends Ast {
  abstract string getName();

  abstract ScriptBlock getBody();

  abstract Parameter getFunctionParameter(int i);

  final Parameter getAFunctionParameter() { result = this.getFunctionParameter(_) }

  final int getNumberOfFunctionParameters() { result = count(this.getAFunctionParameter()) }

  final int getNumberOfParameters() { result = count(this.getAParameter()) }

  final Parameter getParameter(int i) {
    result = this.getFunctionParameter(i)
    or
    result = this.getBody().getParamBlock().getParameter(i)
  }

  final Parameter getAParameter() { result = this.getParameter(_) }

  EntryBasicBlock getEntryBasicBlock() { result.getScope() = this.getBody() }
}

class NonMemberFunction extends @function_definition, Stmt, AbstractFunction {
  override string toString() { result = this.getName() }

  override SourceLocation getLocation() { function_definition_location(this, result) }

  override string getName() { function_definition(this, _, result, _, _) }

  override ScriptBlock getBody() { function_definition(this, result, _, _, _) }

  predicate isFilter() { function_definition(this, _, _, true, _) }

  predicate isWorkflow() { function_definition(this, _, _, _, true) }

  override Parameter getFunctionParameter(int i) { result.isFunctionParameter(this, i) }
}

class MemberFunction extends @function_member, Member, AbstractFunction {
  override string getName() { function_member(this, _, _, _, _, _, _, result, _) }

  override SourceLocation getLocation() { function_member_location(this, result) }

  override string toString() { result = this.getName() }

  override ScriptBlock getBody() { function_member(this, result, _, _, _, _, _, _, _) }

  override predicate isHidden() { function_member(this, _, _, true, _, _, _, _, _) }

  override predicate isPrivate() { function_member(this, _, _, _, true, _, _, _, _) }

  override predicate isPublic() { function_member(this, _, _, _, _, true, _, _, _) }

  override predicate isStatic() { function_member(this, _, _, _, _, _, true, _, _) }

  predicate isConstructor() { function_member(this, _, true, _, _, _, _, _, _) }

  override Parameter getFunctionParameter(int i) { result.isFunctionParameter(this, i) }

  TypeConstraint getTypeConstraint() { function_member_return_type(this, result) }
}

class Constructor extends MemberFunction {
  Constructor() { this.isConstructor() }
}

final class Function = AbstractFunction;
