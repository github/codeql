/**
 * @name Hard-coded credentials
 * @description Credentials are hard coded in the source code of the application.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision medium
 * @id rb/hardcoded-credentials
 * @tags security
 *       external/cwe/cwe-259
 *       external/cwe/cwe-321
 *       external/cwe/cwe-798
 */

import ruby
import codeql.ruby.DataFlow
import DataFlow::PathGraph
import codeql.ruby.TaintTracking
import codeql.ruby.controlflow.CfgNodes

private string getValueText(StringLiteral sl) { result = sl.getConstantValue().getString() }

bindingset[char, fraction]
predicate fewer_characters_than(StringLiteral str, string char, float fraction) {
  exists(string text, int chars |
    text = getValueText(str) and
    chars = count(int i | text.charAt(i) = char)
  |
    /* Allow one character */
    chars = 1 or
    chars < text.length() * fraction
  )
}

predicate possible_reflective_name(string name) {
  // TODO: implement this?
  none()
}

int char_count(StringLiteral str) { result = count(string c | c = getValueText(str).charAt(_)) }

predicate capitalized_word(StringLiteral str) { getValueText(str).regexpMatch("[A-Z][a-z]+") }

predicate format_string(StringLiteral str) { getValueText(str).matches("%{%}%") }

predicate maybeCredential(Expr e) {
  /* A string that is not too short and unlikely to be text or an identifier. */
  exists(StringLiteral str | str = e |
    /* At least 10 characters */
    getValueText(str).length() > 9 and
    /* Not too much whitespace */
    fewer_characters_than(str, " ", 0.05) and
    /* or underscores */
    fewer_characters_than(str, "_", 0.2) and
    /* Not too repetitive */
    exists(int chars | chars = char_count(str) |
      chars > 15 or
      chars * 3 > getValueText(str).length() * 2
    ) and
    not possible_reflective_name(getValueText(str)) and
    not capitalized_word(str) and
    not format_string(str)
  )
  or
  /* Or, an integer with over 32 bits */
  exists(IntegerLiteral lit | lit = e |
    not exists(lit.getValue()) and
    /* Not a set of flags or round number */
    not lit.toString().matches("%00%")
  )
}

class HardcodedValueSource extends DataFlow::Node {
  HardcodedValueSource() { maybeCredential(this.asExpr().getExpr()) }
}

/**
 * Gets a regular expression for matching names of locations (variables, parameters, keys) that
 * indicate the value being held is a credential.
 */
private string getACredentialRegExp() {
  result = "(?i).*pass(wd|word|code|phrase)(?!.*question).*" or
  result = "(?i).*(puid|username|userid).*" or
  result = "(?i).*(cert)(?!.*(format|name)).*"
}

bindingset[name]
private predicate maybeCredentialName(string name) {
  name.regexpMatch(getACredentialRegExp()) and
  not name.matches("%file")
}

// Positional parameter
private DataFlow::Node credentialParameter() {
  exists(Method m, NamedParameter p, int idx |
    result.asParameter() = p and
    p = m.getParameter(idx) and
    maybeCredentialName(p.getName())
  )
}

// Keyword argument
private Expr credentialKeywordArgument() {
  exists(MethodCall mc, string argKey |
    result = mc.getKeywordArgument(argKey) and
    maybeCredentialName(argKey)
  )
}

// An equality check against a credential value
private Expr credentialComparison() {
  exists(EqualityOperation op, VariableReadAccess vra |
    maybeCredentialName(vra.getVariable().getName()) and
    (
      op.getLeftOperand() = result and
      op.getRightOperand() = vra
      or
      op.getLeftOperand() = vra and op.getRightOperand() = result
    )
  )
}

private predicate isCredentialSink(DataFlow::Node node) {
  node = credentialParameter()
  or
  node.asExpr().getExpr() = credentialKeywordArgument()
  or
  node.asExpr().getExpr() = credentialComparison()
}

class CredentialSink extends DataFlow::Node {
  CredentialSink() { isCredentialSink(this) }
}

class HardcodedCredentialsConfiguration extends DataFlow::Configuration {
  HardcodedCredentialsConfiguration() { this = "HardcodedCredentialsConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof HardcodedValueSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof CredentialSink }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(ExprNodes::BinaryOperationCfgNode binop |
      (
        binop.getLeftOperand() = node1.asExpr() or
        binop.getRightOperand() = node1.asExpr()
      ) and
      binop = node2.asExpr() and
      // string concatenation
      binop.getExpr() instanceof AddExpr
    )
  }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, HardcodedCredentialsConfiguration conf
where conf.hasFlowPath(source, sink)
select source.getNode(), source, sink, "Use of $@.", source.getNode(), "hardcoded credentials"
