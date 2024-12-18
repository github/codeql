/**
 * @name Hard-coded credentials
 * @description Credentials are hard coded in the source code of the application.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision medium
 * @id py/hardcoded-credentials
 * @tags security
 *       external/cwe/cwe-259
 *       external/cwe/cwe-321
 *       external/cwe/cwe-798
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.filters.Tests
private import semmle.python.dataflow.new.internal.DataFlowDispatch as DataFlowDispatch
private import semmle.python.dataflow.new.internal.Builtins::Builtins as Builtins
private import semmle.python.frameworks.data.ModelsAsData

bindingset[char, fraction]
predicate fewer_characters_than(StringLiteral str, string char, float fraction) {
  exists(string text, int chars |
    text = str.getText() and
    chars = count(int i | text.charAt(i) = char)
  |
    /* Allow one character */
    chars = 1 or
    chars < text.length() * fraction
  )
}

predicate possible_reflective_name(string name) {
  any(Function f).getName() = name
  or
  any(Class c).getName() = name
  or
  any(Module m).getName() = name
  or
  exists(Builtins::likelyBuiltin(name))
}

int char_count(StringLiteral str) { result = count(string c | c = str.getText().charAt(_)) }

predicate capitalized_word(StringLiteral str) { str.getText().regexpMatch("[A-Z][a-z]+") }

predicate format_string(StringLiteral str) { str.getText().matches("%{%}%") }

predicate maybeCredential(ControlFlowNode f) {
  /* A string that is not too short and unlikely to be text or an identifier. */
  exists(StringLiteral str | str = f.getNode() |
    /* At least 10 characters */
    str.getText().length() > 9 and
    /* Not too much whitespace */
    fewer_characters_than(str, " ", 0.05) and
    /* or underscores */
    fewer_characters_than(str, "_", 0.2) and
    /* Not too repetitive */
    exists(int chars | chars = char_count(str) |
      chars > 15 or
      chars * 3 > str.getText().length() * 2
    ) and
    not possible_reflective_name(str.getText()) and
    not capitalized_word(str) and
    not format_string(str)
  )
  or
  /* Or, an integer with over 32 bits */
  exists(IntegerLiteral lit | f.getNode() = lit |
    not exists(lit.getValue()) and
    /* Not a set of flags or round number */
    not lit.getN().matches("%00%")
  )
}

class HardcodedValueSource extends DataFlow::Node {
  HardcodedValueSource() { maybeCredential(this.asCfgNode()) }
}

class CredentialSink extends DataFlow::Node {
  CredentialSink() {
    exists(string s | s.matches("credentials-%") |
      // Actual sink-type will be things like `credentials-password` or `credentials-username`
      this = ModelOutput::getASinkNode(s).asSink()
    )
    or
    exists(string name |
      name.regexpMatch(getACredentialRegex()) and
      not name.matches("%file")
    |
      exists(DataFlowDispatch::ArgumentPosition pos | pos.isKeyword(name) |
        this.(DataFlow::ArgumentNode).argumentOf(_, pos)
      )
      or
      exists(Keyword k | k.getArg() = name and k.getValue().getAFlowNode() = this.asCfgNode())
      or
      exists(CompareNode cmp, NameNode n | n.getId() = name |
        cmp.operands(this.asCfgNode(), any(Eq eq), n)
        or
        cmp.operands(n, any(Eq eq), this.asCfgNode())
      )
    )
  }
}

/**
 * Gets a regular expression for matching names of locations (variables, parameters, keys) that
 * indicate the value being held is a credential.
 */
private string getACredentialRegex() {
  result = "(?i).*pass(wd|word|code|phrase)(?!.*question).*" or
  result = "(?i).*(puid|username|userid).*" or
  result = "(?i).*(cert)(?!.*(format|name)).*"
}

private module HardcodedCredentialsConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof HardcodedValueSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof CredentialSink }
}

module HardcodedCredentialsFlow = TaintTracking::Global<HardcodedCredentialsConfig>;

import HardcodedCredentialsFlow::PathGraph

from HardcodedCredentialsFlow::PathNode src, HardcodedCredentialsFlow::PathNode sink
where
  HardcodedCredentialsFlow::flowPath(src, sink) and
  not any(TestScope test).contains(src.getNode().asCfgNode().getNode())
select src.getNode(), src, sink, "This hardcoded value is $@.", sink.getNode(),
  "used as credentials"
