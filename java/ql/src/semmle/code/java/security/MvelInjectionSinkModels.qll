/** Provides sink models relating to MVEL injection vulnerabilities. */

import semmle.code.java.dataflow.ExternalFlow

private class DefaulMvelEvaluationSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.script;CompiledScript;false;eval;;;Argument[-1];mvel",
        "org.mvel2;MVEL;false;eval;;;Argument[0];mvel",
        "org.mvel2;MVEL;false;executeExpression;;;Argument[0];mvel",
        "org.mvel2;MVEL;false;evalToBoolean;;;Argument[0];mvel",
        "org.mvel2;MVEL;false;evalToString;;;Argument[0];mvel",
        "org.mvel2;MVEL;false;executeAllExpression;;;Argument[0];mvel",
        "org.mvel2;MVEL;false;executeSetExpression;;;Argument[0];mvel",
        "org.mvel2;MVELRuntime;false;execute;;;Argument[1];mvel",
        "org.mvel2.templates;TemplateRuntime;false;eval;;;Argument[0];mvel",
        "org.mvel2.templates;TemplateRuntime;false;execute;;;Argument[0];mvel",
        "org.mvel2.jsr223;MvelScriptEngine;false;eval;;;Argument[0];mvel",
        "org.mvel2.jsr223;MvelScriptEngine;false;evaluate;;;Argument[0];mvel",
        "org.mvel2.jsr223;MvelCompiledScript;false;eval;;;Argument[-1];mvel",
        "org.mvel2.compiler;ExecutableStatement;false;getValue;;;Argument[-1];mvel",
        "org.mvel2.compiler;CompiledExpression;false;getDirectValue;;;Argument[-1];mvel",
        "org.mvel2.compiler;CompiledAccExpression;false;getValue;;;Argument[-1];mvel",
        "org.mvel2.compiler;Accessor;false;getValue;;;Argument[-1];mvel"
      ]
  }
}
