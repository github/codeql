package javax.script;

public interface ScriptEngine {
    Object eval(String var1) throws ScriptException;

    public ScriptEngineFactory getFactory();
}

