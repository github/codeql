/**
 * Provides definitions related to strings.
 */

import csharp
private import semmle.code.csharp.frameworks.Format
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.Text

/**
 * An expression that appears in a context where an implicit `ToString()`
 * invocation will take place, unless the expression is already a string.
 * For example, `o` and `o.ToString()` on lines 2 and 3, respectively, in
 *
 * ```csharp
 * void Hello(object o) {
 *   Console.WriteLine("Hello, " + o);
 *   Console.WriteLine("Hello, " + o.ToString());
 * }
 * ```
 *
 * Note that only `o` on line 2 has an implicit invocation of `ToString()`.
 */
class ImplicitToStringExpr extends Expr {
  ImplicitToStringExpr() {
    exists(Parameter p, Method m |
      this = getAnAssignedArgumentOrParam(p) and
      m = p.getCallable()
    |
      m = any(SystemTextStringBuilderClass c).getAMethod() and
      m.getName().regexpMatch("Append(Line)?") and
      not p.getType() instanceof ArrayType
      or
      p instanceof StringFormatItemParameter and
      not p.getType() =
        any(ArrayType at |
          at.getElementType() instanceof ObjectType and
          this.getType().isImplicitlyConvertibleTo(at)
        )
      or
      m = any(SystemClass c | c.hasName("Console")).getAMethod() and
      m.getName().regexpMatch("Write(Line)?") and
      p.getPosition() = 0
    )
    or
    exists(AddExpr add, Expr o | o = add.getAnOperand() |
      o.stripImplicit().getType() instanceof StringType and
      this = add.getOtherOperand(o).stripImplicit()
    )
    or
    this = any(InterpolatedStringExpr ise).getAnInsert().stripImplicit()
  }
}

private Expr getAnAssignedArgumentOrParam(Parameter p) {
  result = p.getAnAssignedArgument()
  or
  p.isParams() and
  exists(MethodCall mc, int i | mc.getTarget().getAParameter() = p |
    result = mc.getArgument(i) and
    i >= p.getPosition()
  )
}
