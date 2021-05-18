/*
 * @name Hard-coded credentials
 * @description Credentials are hard coded in the source code of the application.
 * @problem.severity error
 * @precision medium TODO
 * @id rb/hardcoded-credentials
 * @tags security
 *       external/cwe/cwe-259
 *       external/cwe/cwe-321
 *       external/cwe/cwe-798
 */

import ruby
import codeql_ruby.DataFlow
import DataFlow::PathGraph
private import codeql_ruby.dataflow.SSA
private import codeql_ruby.CFG

bindingset[char, fraction]
predicate fewer_characters_than(StringLiteral str, string char, float fraction) {
  exists(string text, int chars |
    text = str.getValueText() and
    chars = count(int i | text.charAt(i) = char)
  |
    /* Allow one character */
    chars = 1 or
    chars < text.length() * fraction
  )
}

predicate possible_reflective_name(string name) {
  // TODO: implement me
  none()
}

int char_count(StringLiteral str) { result = count(string c | c = str.getValueText().charAt(_)) }

predicate capitalized_word(StringLiteral str) { str.getValueText().regexpMatch("[A-Z][a-z]+") }

predicate format_string(StringLiteral str) { str.getValueText().matches("%{%}%") }

predicate maybeCredential(Expr e) {
  /* A string that is not too short and unlikely to be text or an identifier. */
  exists(StringLiteral str | str = e |
    /* At least 10 characters */
    str.getValueText().length() > 9 and
    /* Not too much whitespace */
    fewer_characters_than(str, " ", 0.05) and
    /* or underscores */
    fewer_characters_than(str, "_", 0.2) and
    /* Not too repetitive */
    exists(int chars | chars = char_count(str) |
      chars > 15 or
      chars * 3 > str.getValueText().length() * 2
    ) and
    not possible_reflective_name(str.getValueText()) and
    not capitalized_word(str) and
    not format_string(str)
  )
  or
  /* Or, an integer with over 32 bits */
  exists(IntegerLiteral lit | lit = e |
    not exists(lit.getValue()) and
    /* Not a set of flags or round number */
    not lit.getValueText().matches("%00%")
  )
}

class HardcodedValueSource extends DataFlow::Node {
  HardcodedValueSource() { maybeCredential(this.asExpr().getExpr()) }
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

private predicate isCredentialSink(Expr e) {
  exists(string name |
    name.regexpMatch(getACredentialRegex()) and
    not name.suffix(name.length() - 4) = "file"
  |
    // A method call with a parameter that may hold a credential
    exists(Method m, NamedParameter p, int idx, MethodCall mc |
      mc.getArgument(idx).getAChild*() = e and
      p = m.getParameter(idx) and
      p.getName() = name and
      // TODO: link call w/ method more precisely
      mc.getMethodName() = m.getName()
    )
    or
    // An equality check against a credential value
    exists(EqualityOperation op, VariableReadAccess vra | vra.getVariable().getName() = name |
      op.getLeftOperand() = e and op.getRightOperand() = vra
      or
      op.getLeftOperand() = vra and op.getRightOperand() = e
    )
    /*
     *      or
     *      exists(Keyword k | k.getArg() = name and k.getValue().getAFlowNode() = this)
     */

    )
}

class CredentialSink extends DataFlow::Node {
  CredentialSink() { isCredentialSink(this.asExpr().getExpr()) }
}

class HardcodedCredentialsConfiguration extends DataFlow::Configuration {
  HardcodedCredentialsConfiguration() { this = "HardcodedCredentialsConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof HardcodedValueSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof CredentialSink }
}

from Method m, NamedParameter p, int idx, MethodCall mc, Expr e
where
  mc.getArgument(idx) = e and
  p = m.getParameter(idx) and
  // TODO: link call w/ method more precisely
  mc.getMethodName() = m.getName()
select m, p, idx, mc, e
