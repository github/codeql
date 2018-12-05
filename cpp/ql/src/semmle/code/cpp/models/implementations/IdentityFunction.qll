import semmle.code.cpp.Function
import semmle.code.cpp.models.interfaces.Alias
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.SideEffect

/**
 * The standard function templates `std::move` and `std::identity`
 */
class IdentityFunction extends DataFlowFunction, SideEffectModel::SideEffectFunction,
    AliasModel::AliasFunction {
  IdentityFunction() {
    this.getNamespace().getParentNamespace() instanceof GlobalNamespace and
    this.getNamespace().getName() = "std" and
    ( 
      this.getName() = "move" or
      this.getName() = "forward"
    )
  }

  override predicate readsMemory() {
    none()
  }

  override predicate writesMemory() {
    none()
  }

  override AliasModel::ParameterEscape getParameterEscapeBehavior(int index) {
    exists(getParameter(index)) and
    if index = 0 then
      result instanceof AliasModel::EscapesOnlyViaReturn
    else
      result instanceof AliasModel::DoesNotEscape
  }

  override predicate parameterIsAlwaysReturned(int index) {
    index = 0
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // These functions simply return the argument value.
    input.isInParameter(0) and output.isOutReturnValue()
  }
}
