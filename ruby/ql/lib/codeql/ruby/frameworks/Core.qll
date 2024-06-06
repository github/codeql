/**
 * Provides modeling for the Ruby core libraries.
 */

private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.FlowSummary
import core.BasicObject::BasicObject
import core.Object::Object
import core.Gem::Gem
import core.Kernel::Kernel
import core.Module
import core.Array
import core.Hash
import core.String
import core.IO
import core.Digest
import core.Base64

/**
 * A system command executed via subshell literal syntax.
 * E.g.
 * ```ruby
 * `cat foo.txt`
 * %x(cat foo.txt)
 * %x[cat foo.txt]
 * %x{cat foo.txt}
 * %x/cat foo.txt/
 * ```
 */
class SubshellLiteralExecution extends SystemCommandExecution::Range {
  SubshellLiteral literal;

  SubshellLiteralExecution() { this.asExpr().getExpr() = literal }

  override DataFlow::Node getAnArgument() { result.asExpr().getExpr() = literal.getComponent(_) }

  override predicate isShellInterpreted(DataFlow::Node arg) { arg = this.getAnArgument() }
}

/**
 * A system command executed via shell heredoc syntax.
 * E.g.
 * ```ruby
 * <<`EOF`
 * cat foo.text
 * EOF
 * ```
 */
class SubshellHeredocExecution extends SystemCommandExecution::Range {
  HereDoc heredoc;

  SubshellHeredocExecution() { this.asExpr().getExpr() = heredoc and heredoc.isSubShell() }

  override DataFlow::Node getAnArgument() { result.asExpr().getExpr() = heredoc.getComponent(_) }

  override predicate isShellInterpreted(DataFlow::Node arg) { arg = this.getAnArgument() }
}

private class SplatSummary extends SummarizedCallable {
  SplatSummary() { this = "*(splat)" }

  override SplatExpr getACallSimple() { any() }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    (
      // *1 = [1]
      input = "Argument[self].WithoutElement[any]" and
      output = "ReturnValue.Element[0]"
      or
      // *[1] = [1]
      input = "Argument[self].WithElement[any]" and
      output = "ReturnValue"
    ) and
    preservesValue = true
  }
}

private class HashSplatSummary extends SummarizedCallable {
  HashSplatSummary() { this = "**(hash-splat)" }

  override HashSplatExpr getACallSimple() { any() }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[self].WithElement[any]" and
    output = "ReturnValue" and
    preservesValue = true
  }
}
