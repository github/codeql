/**
 * This module provides a hand-modifiable wrapper around the generated class `Element`.
 */

private import codeql.rust.generated.Element

class ElementImpl extends Generated::ElementImpl {
  override string toString() { result = this.getAPrimaryQlClass() }

  predicate isUnknown() { none() } // compatibility with test generation, to be fixed
}
