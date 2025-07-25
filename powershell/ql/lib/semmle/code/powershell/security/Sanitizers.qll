private import powershell
private import semmle.code.powershell.dataflow.DataFlow

/**
 * A dataflow node that is guarenteed to have a "simple" type.
 *
 * Simple types include integers, floats, characters, booleans, and `datetime`.
 */
class SimpleTypeSanitizer extends DataFlow::Node {
  SimpleTypeSanitizer() {
    this.asParameter().getStaticType() =
      ["int32", "int64", "single", "double", "decimal", "char", "boolean", "datetime"]
  }
}
