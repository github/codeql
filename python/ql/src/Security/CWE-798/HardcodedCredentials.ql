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

bindingset[char, fraction]
predicate fewer_characters_than(StrConst str, string char, float fraction) {
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
  exists(any(ModuleValue m).attr(name))
  or
  exists(any(ClassValue c).lookup(name))
  or
  any(ClassValue c).getName() = name
  or
  exists(Module::named(name))
  or
  exists(Value::named(name))
}

int char_count(StrConst str) { result = count(string c | c = str.getText().charAt(_)) }

predicate capitalized_word(StrConst str) { str.getText().regexpMatch("[A-Z][a-z]+") }

predicate format_string(StrConst str) { str.getText().matches("%{%}%") }

predicate maybeCredential(ControlFlowNode f) {
  /* A string that is not too short and unlikely to be text or an identifier. */
  exists(StrConst str | str = f.getNode() |
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
    exists(string name |
      name.regexpMatch(getACredentialRegex()) and
      not name.matches("%file")
    |
      any(FunctionValue func).getNamedArgumentForCall(_, name) = this.asCfgNode()
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
