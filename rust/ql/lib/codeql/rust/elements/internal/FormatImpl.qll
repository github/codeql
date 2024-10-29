/**
 * This module provides a hand-modifiable wrapper around the generated class `Format`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Format
private import codeql.rust.elements.internal.generated.Raw
private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.internal.FormatConstructor
private import codeql.rust.elements.internal.LocatableImpl::Impl as LocatableImpl
private import codeql.files.FileSystem
import codeql.rust.elements.FormatArgument

/**
 * INTERNAL: This module contains the customizable definition of `Format` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A format element in a formatting template. For example the `{}` in:
   * ```rust
   * println!("Hello {}", "world");
   * ```
   */
  class Format extends Generated::Format {
    private Raw::FormatArgsExpr parent;
    string text;
    private int index;
    int offset;

    Format() { this = Synth::TFormat(parent, index, text, offset) }

    override string toString() { result = text }

    override FormatArgsExpr getParent() { result = Synth::convertFormatArgsExprFromRaw(parent) }

    override int getIndex() { result = index }

    /**
     * Gets the name or position reference of this format, if any. For example `name` and `0` in:
     * ```rust
     * let name = "Alice";
     * println!("{name} in wonderland");
     * println!("{0} in wonderland", name);
     * ```
     */
    FormatArgument getArgumentRef() {
      result.getParent() = this and result = Synth::TFormatArgument(_, _, 0, _, _, _)
    }

    /**
     * Gets the name or position reference of the width parameter in this format, if any. For example `width` and `1` in:
     * ```rust
     * let width = 6;
     * println!("{:width$}", PI);
     * println!("{:1$}", PI, width);
     * ```
     */
    FormatArgument getWidthArgument() {
      result.getParent() = this and result = Synth::TFormatArgument(_, _, 1, _, _, _)
    }

    /**
     * Gets the name or position reference of the width parameter in this format, if any. For example `prec` and `1` in:
     * ```rust
     * let prec = 6;
     * println!("{:.prec$}", PI);
     * println!("{:.1$}", PI, prec);
     * ```
     */
    FormatArgument getPrecisionArgument() {
      result.getParent() = this and result = Synth::TFormatArgument(_, _, 2, _, _, _)
    }
  }

  private class FormatSynthLocationImpl extends Format, LocatableImpl::SynthLocatable {
    override predicate hasSynthLocationInfo(
      File file, int startline, int startcolumn, int endline, int endcolumn
    ) {
      LocatableImpl::getLocationDefault(this.getParent().getTemplate())
          .hasLocationFileInfo(file, startline, startcolumn - offset, _, _) and
      endline = startline and
      endcolumn = startcolumn + text.length() - 1
    }
  }
}
