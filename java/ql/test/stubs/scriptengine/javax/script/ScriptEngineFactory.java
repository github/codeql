package javax.script;

public interface ScriptEngineFactory {
    public String getEngineName();

    public String getMethodCallSyntax(String obj, String m, String... args);

    public String getProgram(String... statements);

    ScriptEngine getScriptEngine();
}
