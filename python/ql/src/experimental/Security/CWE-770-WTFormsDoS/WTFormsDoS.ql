/**
 * @name Denial of service due to inadequate validation on a WTform field.
 * @kind problem
 * @id python/wtforms-dos
 * @severity error
 * @tags security
 *       experimental
 *       external/cwe/cwe-770
 */

import python
import semmle.python.ApiGraphs

private API::Node wtforms() { result = API::moduleImport("wtforms") }

private API::Node wtvalidators() { result = wtforms().getMember("validators") }

bindingset[result]
private string vName() {
  result
      .toLowerCase()
      .matches([
          "length", "regexp", "ipaddress", "macaddress", "numberrange", "uuid", "anyof", "noneof"
        ])
}

private class SanitizingValidators extends API::CallNode {
  SanitizingValidators() {
    // Treat a length or regex check as sanitizer
    this = wtvalidators().getMember(vName()).getACall()
  }
}

private class StringFieldCall extends API::CallNode {
  StringFieldCall() {
    this = API::moduleImport("wtforms").getMember("fields").getMember("StringField").getACall()
  }
}

from StringFieldCall w
where
  not exists(DataFlow::Node validators |
    validators =
      DataFlow::exprNode(w.getArgByName("validators").asExpr().(List).getASubExpression())
  |
    // None of the sanitizing functions should be invoked. We don't reason about the correctness of the check.
    DataFlow::localFlow(any(SanitizingValidators v), validators)
    or
    // Any validator which is not from the default library provided validators is taken as a sanitizer for the vulnerablity.
    not validators = wtvalidators().getAMember().getACall()
  ) and
  // WTForms would by default call a validator named `validate_<var_name>`, if it exists, defined in the same class definition as the field.
  // This would mean the field is validated and should be ignored.
  not exists(Variable v, Assign a, Function c |
    a.defines(v) and
    w.flowsTo(DataFlow::exprNode(a.getASubExpression())) and
    not a instanceof ClassDef and
    not a instanceof FunctionDef and
    a.getScope().contains(c.getDefinition()) and
    c.getName().matches("validate_%" + v.getId().toLowerCase())
  ) and
  not exists(KeyValuePair k, StringValue s, BooleanLiteral b |
    k = w.getArgByName("render_kw").asExpr().(Dict).getAnItem()
  |
    k.getKey().pointsTo() = s and
    s.getText() = "readonly" and
    b.booleanValue() = true
  ) and
  // ignore results in test files
  not (
    w.asExpr().getLocation().getFile().getAbsolutePath().matches(["test", "examples", "example"]) and
    not w.asExpr().getLocation().getFile().getAbsolutePath().matches("ql/test")
  )
select w, "This WTForm field may be vulnerable to Denial of Service (DoS) attacks."
