/** Provides sink models relating to Groovy injection vulnerabilities. */

private import semmle.code.java.dataflow.ExternalFlow

private class DefaultGroovyInjectionSinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        // Signatures are specified to exclude sinks of the type `File`
        "groovy.lang;GroovyShell;false;evaluate;(GroovyCodeSource);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;evaluate;(Reader);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;evaluate;(Reader,String);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;evaluate;(String);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;evaluate;(String,String);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;evaluate;(String,String,String);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;evaluate;(URI);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;parse;(Reader);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;parse;(Reader,String);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;parse;(String);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;parse;(String,String);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;parse;(URI);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;run;(GroovyCodeSource,String[]);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;run;(GroovyCodeSource,List);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;run;(Reader,String,String[]);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;run;(Reader,String,List);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;run;(String,String,String[]);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;run;(String,String,List);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;run;(URI,String[]);;Argument[0];groovy",
        "groovy.lang;GroovyShell;false;run;(URI,List);;Argument[0];groovy",
        "groovy.util;Eval;false;me;(String);;Argument[0];groovy",
        "groovy.util;Eval;false;me;(String,Object,String);;Argument[2];groovy",
        "groovy.util;Eval;false;x;(Object,String);;Argument[1];groovy",
        "groovy.util;Eval;false;xy;(Object,Object,String);;Argument[2];groovy",
        "groovy.util;Eval;false;xyz;(Object,Object,Object,String);;Argument[3];groovy",
        "groovy.lang;GroovyClassLoader;false;parseClass;(GroovyCodeSource);;Argument[0];groovy",
        "groovy.lang;GroovyClassLoader;false;parseClass;(GroovyCodeSource,boolean);;Argument[0];groovy",
        "groovy.lang;GroovyClassLoader;false;parseClass;(InputStream,String);;Argument[0];groovy",
        "groovy.lang;GroovyClassLoader;false;parseClass;(Reader,String);;Argument[0];groovy",
        "groovy.lang;GroovyClassLoader;false;parseClass;(String);;Argument[0];groovy",
        "groovy.lang;GroovyClassLoader;false;parseClass;(String,String);;Argument[0];groovy",
        "org.codehaus.groovy.control;CompilationUnit;false;compile;;;Argument[-1];groovy"
      ]
  }
}
