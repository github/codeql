/**
 * This module provides a hand-modifiable wrapper around the generated class `Label`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Label

/**
 * INTERNAL: This module contains the customizable definition of `Label` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A label. For example:
   * ```rust
   * 'label: loop {
   *     println!("Hello, world (once)!");
   *     break 'label;
   * };
   * ```
   */
  class Label extends Generated::Label {
    override string toString() { result = this.getText() }

    override string toAbbreviatedString() { result = this.getText() }

    /**
     * Gets the name of the label, together with the leading `'`.
     */
    string getText() { result = this.getLifetime().getText() }
  }
}
