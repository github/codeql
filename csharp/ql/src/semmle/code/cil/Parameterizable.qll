/**
 * Provides `Parameterizable` class.
 */

private import CIL
private import dotnet

/**
 * A parameterizable entity, such as `FunctionPointerType` or `Method`.
 */
class Parameterizable extends DotNet::Parameterizable, Element, @cil_parameterizable {
  override Parameter getRawParameter(int n) { cil_parameter(result, this, n, _) }

  override Parameter getParameter(int n) { cil_parameter(result, this, n, _) }
}
