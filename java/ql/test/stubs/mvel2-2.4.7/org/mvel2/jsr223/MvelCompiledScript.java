package org.mvel2.jsr223;

import java.io.Serializable;
import javax.script.CompiledScript;
import javax.script.ScriptContext;
import javax.script.ScriptEngine;
import javax.script.ScriptException;

public class MvelCompiledScript extends CompiledScript {
  public MvelCompiledScript(MvelScriptEngine engine, Serializable compiledScript) {}

  public Object eval(ScriptContext context) throws ScriptException {
    return null;
  }

  public ScriptEngine getEngine() {
    return null;
  }
}
