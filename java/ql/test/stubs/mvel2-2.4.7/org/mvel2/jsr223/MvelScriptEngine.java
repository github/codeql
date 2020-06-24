package org.mvel2.jsr223;

import java.io.Serializable;
import javax.script.CompiledScript;
import javax.script.ScriptContext;
import javax.script.ScriptException;

public class MvelScriptEngine {
  public CompiledScript compile(String script) throws ScriptException { return null; }
  public Serializable compiledScript(String script) throws ScriptException { return null; }
  public Object evaluate(Serializable expression, ScriptContext context) throws ScriptException { return null; }
}