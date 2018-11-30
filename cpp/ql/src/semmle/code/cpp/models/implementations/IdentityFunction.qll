import semmle.code.cpp.Function
import semmle.code.cpp.models.interfaces.DataFlow
import semmle.code.cpp.models.interfaces.SideEffectFunction

/**
 * The standard function templates `std::move` and `std::identity`
 */
class IdentityFunction extends DataFlowFunction, SideEffectFunction {
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

  override predicate parameterEscapes(int index) {
    // Note that returning the value of the parameter does not count as escaping.
    none()
  }

  override predicate hasDataFlow(FunctionInput input, FunctionOutput output) {
    // These functions simply return the argument value.
    input.isInParameter(0) and output.isOutReturnValue()
  }
}
