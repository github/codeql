/**
 * Provides classes representing data flow sources for parameters of public callables.
 */

import csharp

/**
 * A parameter of a public callable, for example `p` in
 *
 * ```csharp
 * public void M(int p) {
 *   ...
 * }
 * ```
 */
class PublicCallableParameterFlowSource extends DataFlow::ParameterNode {
  PublicCallableParameterFlowSource() {
    exists(Callable c, Parameter p |
      p = this.getParameter() and
      c.(Modifiable).isPublic() and
      c.getAParameter() = p and
      not p.isOut()
    )
  }
}
