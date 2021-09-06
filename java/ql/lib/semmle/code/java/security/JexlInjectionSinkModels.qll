/** Provides sink models relating to Expression Langauge (JEXL) injection vulnerabilities. */

private import semmle.code.java.dataflow.ExternalFlow

private class DefaultJexlInjectionSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // JEXL2
        "org.apache.commons.jexl2;JexlEngine;false;getProperty;(JexlContext,Object,String);;Argument[2];jexl",
        "org.apache.commons.jexl2;JexlEngine;false;getProperty;(Object,String);;Argument[1];jexl",
        "org.apache.commons.jexl2;JexlEngine;false;setProperty;(JexlContext,Object,String,Object);;Argument[2];jexl",
        "org.apache.commons.jexl2;JexlEngine;false;setProperty;(Object,String,Object);;Argument[1];jexl",
        "org.apache.commons.jexl2;Expression;false;evaluate;;;Argument[-1];jexl",
        "org.apache.commons.jexl2;Expression;false;callable;;;Argument[-1];jexl",
        "org.apache.commons.jexl2;JexlExpression;false;evaluate;;;Argument[-1];jexl",
        "org.apache.commons.jexl2;JexlExpression;false;callable;;;Argument[-1];jexl",
        "org.apache.commons.jexl2;Script;false;execute;;;Argument[-1];jexl",
        "org.apache.commons.jexl2;Script;false;callable;;;Argument[-1];jexl",
        "org.apache.commons.jexl2;JexlScript;false;execute;;;Argument[-1];jexl",
        "org.apache.commons.jexl2;JexlScript;false;callable;;;Argument[-1];jexl",
        "org.apache.commons.jexl2;UnifiedJEXL$Expression;false;evaluate;;;Argument[-1];jexl",
        "org.apache.commons.jexl2;UnifiedJEXL$Expression;false;prepare;;;Argument[-1];jexl",
        "org.apache.commons.jexl2;UnifiedJEXL$Template;false;evaluate;;;Argument[-1];jexl",
        // JEXL3
        "org.apache.commons.jexl3;JexlEngine;false;getProperty;(JexlContext,Object,String);;Argument[2];jexl",
        "org.apache.commons.jexl3;JexlEngine;false;getProperty;(Object,String);;Argument[1];jexl",
        "org.apache.commons.jexl3;JexlEngine;false;setProperty;(JexlContext,Object,String);;Argument[2];jexl",
        "org.apache.commons.jexl3;JexlEngine;false;setProperty;(Object,String,Object);;Argument[1];jexl",
        "org.apache.commons.jexl3;Expression;false;evaluate;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;Expression;false;callable;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;JexlExpression;false;evaluate;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;JexlExpression;false;callable;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;Script;false;execute;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;Script;false;callable;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;JexlScript;false;execute;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;JexlScript;false;callable;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;JxltEngine$Expression;false;evaluate;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;JxltEngine$Expression;false;prepare;;;Argument[-1];jexl",
        "org.apache.commons.jexl3;JxltEngine$Template;false;evaluate;;;Argument[-1];jexl"
      ]
  }
}
